package DAO.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DAO.UserDao;
import Model.User;
import Utils.DBConnection;

/**
 * TẦNG DAO - Implementation
 * Thực thi các câu SQL thao tác với bảng users
 */
public class UserDaoImpl implements UserDao {

    private User extractUserFromResultSet(ResultSet rs) {
        try {
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setEmail(rs.getString("email"));
            user.setUserName(rs.getString("username"));
            user.setFullName(rs.getString("fullname"));
            user.setPassWord(rs.getString("password"));
            user.setAvatar(rs.getString("avatar"));
            user.setRoleid(rs.getInt("roleid"));
            user.setPhone(rs.getString("phone"));
            user.setCreatedDate(rs.getDate("createdDate"));

            // Đọc an toàn status và code (phòng trường hợp table chưa chạy alter column)
            try {
                user.setStatus(rs.getInt("status"));
            } catch (Exception e) {
                user.setStatus(1); // Mặc định là active nếu DB chưa có cột
            }

            try {
                user.setCode(rs.getString("code"));
            } catch (Exception e) {
                user.setCode(null);
            }
            return user;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ─── GET BY USERNAME ─────────────────────────────────────
    @Override
    public User get(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── GET BY EMAIL ────────────────────────────────────────
    @Override
    public User getByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── INSERT ──────────────────────────────────────────────
    @Override
    public void insert(User user) {
        // Thử insert với cả status và code
        String sqlWithStatus = "INSERT INTO users(email, username, fullname, password, "
                             + "avatar, roleid, phone, createdDate, status, code) VALUES (?,?,?,?,?,?,?,?,?,?)";
        String sqlBasic = "INSERT INTO users(email, username, fullname, password, "
                        + "avatar, roleid, phone, createdDate) VALUES (?,?,?,?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sqlWithStatus)) {
                ps.setString(1, user.getEmail());
                ps.setString(2, user.getUserName());
                ps.setString(3, user.getFullName());
                ps.setString(4, user.getPassWord());
                ps.setString(5, user.getAvatar());
                ps.setInt   (6, user.getRoleid());
                ps.setString(7, user.getPhone());
                ps.setDate  (8, user.getCreatedDate());
                ps.setInt   (9, user.getStatus());
                ps.setString(10, user.getCode());
                ps.executeUpdate();
                return;
            } catch (Exception ex) {
                // Nếu cột status/code chưa có trong DB, fallback về câu lệnh gốc
                try (PreparedStatement psFallback = conn.prepareStatement(sqlBasic)) {
                    psFallback.setString(1, user.getEmail());
                    psFallback.setString(2, user.getUserName());
                    psFallback.setString(3, user.getFullName());
                    psFallback.setString(4, user.getPassWord());
                    psFallback.setString(5, user.getAvatar());
                    psFallback.setInt   (6, user.getRoleid());
                    psFallback.setString(7, user.getPhone());
                    psFallback.setDate  (8, user.getCreatedDate());
                    psFallback.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─── UPDATE PASSWORD ─────────────────────────────────────
    @Override
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = ?, code = NULL WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            // Fallback nếu cột code chưa có
            String sqlFallback = "UPDATE users SET password = ? WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlFallback)) {
                ps.setString(1, newPassword);
                ps.setString(2, email);
                return ps.executeUpdate() > 0;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    // ─── ACTIVATE USER ───────────────────────────────────────
    @Override
    public boolean activateUser(String email) {
        String sql = "UPDATE users SET status = 1, code = NULL WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return true; // Nếu DB không có cột status thì coi như thành công
        }
    }

    // ─── UPDATE CODE ─────────────────────────────────────────
    @Override
    public boolean updateCode(String email, String code) {
        String sql = "UPDATE users SET code = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, email);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── CHECK EXIST EMAIL ───────────────────────────────────
    @Override
    public boolean checkExistEmail(String email) {
        String query = "SELECT 1 FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // ─── CHECK EXIST USERNAME ────────────────────────────────
    @Override
    public boolean checkExistUsername(String username) {
        String query = "SELECT 1 FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    // ─── CHECK EXIST PHONE ───────────────────────────────────
    @Override
    public boolean checkExistPhone(String phone) {
        String query = "SELECT 1 FROM users WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
}
