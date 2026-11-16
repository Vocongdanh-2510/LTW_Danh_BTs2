package Service;

import Model.User;

/**
 * TẦNG SERVICE - Interface
 * Định nghĩa các nghiệp vụ liên quan đến User
 */
public interface UserService {

    // ── Đăng nhập ──────────────────────────────────────────
    User login(String username, String password);

    // Lấy user theo username
    User get(String username);

    // Lấy user theo email
    User getByEmail(String email);

    // ── Đăng ký ────────────────────────────────────────────
    void insert(User user);

    boolean register(String username, String password,
                     String email, String fullname, String phone);

    // Đăng ký với mã OTP (status = 0, lưu mã OTP và hash password)
    boolean registerWithOtp(String username, String password,
                            String email, String fullname, String phone, String otp);

    // Kích hoạt tài khoản
    boolean activateUser(String email);

    // Cập nhật mật khẩu mới (hash)
    boolean updatePassword(String email, String newPassword);

    // Cập nhật mã OTP
    boolean updateCode(String email, String code);

    boolean checkExistEmail(String email);

    boolean checkExistUsername(String username);

    boolean checkExistPhone(String phone);
}
