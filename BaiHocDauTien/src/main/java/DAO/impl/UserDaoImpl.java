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
        if (username == null) return null;
        String trimmed = username.trim();
        // Cho phép tìm theo username HOẶC email
        String sql = "SELECT * FROM users WHERE LOWER(LTRIM(RTRIM(username))) = LOWER(?) "
                   + "OR LOWER(LTRIM(RTRIM(email))) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimmed);
            ps.setString(2, trimmed);
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
        if (email == null) return null;
        String trimmed = email.trim();
        // Cho phép tìm theo email HOẶC username để thuận tiện tối đa cho người dùng
        String sql = "SELECT * FROM users WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(?) "
                   + "OR LOWER(LTRIM(RTRIM(username))) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimmed);
            ps.setString(2, trimmed);
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
        if (email == null || newPassword == null) return false;
        String trimmed = email.trim();
        boolean success = false;

        // 1. Cập nhật qua JDBC PreparedStatement (bảo vệ bằng LOWER, LTRIM, RTRIM)
        String sql = "UPDATE users SET password = ?, code = NULL "
                   + "WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(?) "
                   + "   OR LOWER(LTRIM(RTRIM(username))) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setString(2, trimmed);
            ps.setString(3, trimmed);
            int rows = ps.executeUpdate();
            System.out.println("[DEBUG UserDaoImpl] updatePassword cho '" + trimmed + "' - Số dòng ảnh hưởng: " + rows);
            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            System.err.println("[ERROR UserDaoImpl] JDBC updatePassword gặp lỗi: " + e.getMessage());
            // Fallback nếu bảng chưa có cột code
            String sqlFallback = "UPDATE users SET password = ? WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(?) OR LOWER(LTRIM(RTRIM(username))) = LOWER(?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sqlFallback)) {
                ps.setString(1, newPassword);
                ps.setString(2, trimmed);
                ps.setString(3, trimmed);
                int rows = ps.executeUpdate();
                if (rows > 0) success = true;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        // 2. Đồng thời cập nhật qua JPA (Hibernate) để đảm bảo đồng bộ hoàn toàn với Persistence Context
        try {
            jakarta.persistence.EntityManager em = vn.iotstar.config.JpaConfig.getEntityManager();
            jakarta.persistence.EntityTransaction trans = em.getTransaction();
            try {
                trans.begin();
                jakarta.persistence.Query q = em.createQuery(
                    "UPDATE User u SET u.password = :pwd, u.code = NULL " +
                    "WHERE LOWER(TRIM(u.email)) = LOWER(:id) OR LOWER(TRIM(u.username)) = LOWER(:id)");
                q.setParameter("pwd", newPassword);
                q.setParameter("id", trimmed);
                int count = q.executeUpdate();
                trans.commit();
                System.out.println("[DEBUG JPA] updatePassword JPA EntityManager - Số dòng ảnh hưởng: " + count);
                if (count > 0) success = true;
            } catch (Exception ex) {
                if (trans.isActive()) trans.rollback();
            } finally {
                em.close();
            }
        } catch (Throwable t) {
            // Không ngắt tiến trình nếu JPA đã đồng bộ xong
        }

        return success;
    }

    // ─── ACTIVATE USER ───────────────────────────────────────
    @Override
    public boolean activateUser(String email) {
        if (email == null) return false;
        String trimmed = email.trim();
        String sql = "UPDATE users SET status = 1, code = NULL "
                   + "WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(?) "
                   + "   OR LOWER(LTRIM(RTRIM(username))) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, trimmed);
            ps.setString(2, trimmed);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return true;
        }
    }

    // ─── UPDATE CODE ─────────────────────────────────────────
    @Override
    public boolean updateCode(String email, String code) {
        if (email == null) return false;
        String trimmed = email.trim();
        String sql = "UPDATE users SET code = ? "
                   + "WHERE LOWER(LTRIM(RTRIM(email))) = LOWER(?) "
                   + "   OR LOWER(LTRIM(RTRIM(username))) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, trimmed);
            ps.setString(3, trimmed);
            int rows = ps.executeUpdate();
            System.out.println("[DEBUG UserDaoImpl] updateCode OTP cho '" + trimmed + "' - Số dòng ảnh hưởng: " + rows);
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
