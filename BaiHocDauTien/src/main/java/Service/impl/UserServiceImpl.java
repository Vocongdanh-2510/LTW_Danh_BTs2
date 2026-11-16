package Service.impl;

import java.sql.Date;

import DAO.UserDao;
import DAO.impl.UserDaoImpl;
import Model.User;
import Service.UserService;
import Utils.PasswordUtil;

/**
 * TẦNG SERVICE - Implementation
 * Xử lý logic nghiệp vụ, gọi xuống tầng DAO
 */
public class UserServiceImpl implements UserService {

    private UserDao userDao = new UserDaoImpl();

    // ─────────────────────────────────────────────────────────
    //  ĐĂNG NHẬP
    //  1. Lấy user theo username từ DAO
    //  2. Kiểm tra mật khẩu (đã mã hóa hash SHA-256) qua PasswordUtil
    //  3. Trả về User nếu khớp mật khẩu, ngược lại trả về null
    // ─────────────────────────────────────────────────────────
    @Override
    public User login(String username, String password) {
        User user = this.get(username);
        if (user != null && password != null) {
            // Kiểm tra mật khẩu mã hóa hash
            if (PasswordUtil.checkPassword(password, user.getPassWord())) {
                return user;
            }
        }
        return null;
    }

    @Override
    public User get(String username) {
        return userDao.get(username);
    }

    @Override
    public User getByEmail(String email) {
        return userDao.getByEmail(email);
    }

    // ─────────────────────────────────────────────────────────
    //  ĐĂNG KÝ CƠ BẢN
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean register(String username, String password,
                            String email, String fullname, String phone) {
        if (userDao.checkExistUsername(username) || userDao.checkExistEmail(email)) {
            return false;
        }
        long millis = System.currentTimeMillis();
        Date date = new Date(millis);

        // Mật khẩu được mã hóa băm SHA-256
        String hashedPassword = PasswordUtil.hashPassword(password);

        // roleid = 5 là user thường, status = 1
        userDao.insert(new User(email, username, fullname,
                                hashedPassword, null, 5, phone, date));
        return true;
    }

    // ─────────────────────────────────────────────────────────
    //  ĐĂNG KÝ VỚI MÃ XÁC THỰC OTP (Bài 1)
    //  Tài khoản tạo với status = 0 (chưa kích hoạt) và code = otp
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean registerWithOtp(String username, String password,
                                   String email, String fullname, String phone, String otp) {
        if (userDao.checkExistUsername(username)) {
            return false;
        }

        long millis = System.currentTimeMillis();
        Date date = new Date(millis);

        // Băm mật khẩu bằng SHA-256
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Tạo User với status = 0 (chờ kích hoạt OTP)
        User user = new User(email, username, fullname, hashedPassword, null, 5, phone, date, 0, otp);
        userDao.insert(user);
        return true;
    }

    // ─────────────────────────────────────────────────────────
    //  KÍCH HOẠT TÀI KHOẢN (Bài 1)
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean activateUser(String email) {
        return userDao.activateUser(email);
    }

    // ─────────────────────────────────────────────────────────
    //  ĐẶT LẠI MẬT KHẨU (Bài 3)
    // ─────────────────────────────────────────────────────────
    @Override
    public boolean updatePassword(String email, String newPassword) {
        String hashedPassword = PasswordUtil.hashPassword(newPassword);
        return userDao.updatePassword(email, hashedPassword);
    }

    @Override
    public boolean updateCode(String email, String code) {
        return userDao.updateCode(email, code);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public boolean checkExistUsername(String username) {
        return userDao.checkExistUsername(username);
    }

    @Override
    public boolean checkExistPhone(String phone) {
        return userDao.checkExistPhone(phone);
    }

    @Override
    public void insert(User user) {
        userDao.insert(user);
    }
}
