package DAO;

import Model.User;

/**
 * TẦNG DAO - Interface
 * Định nghĩa các thao tác với bảng users trong database
 */
public interface UserDao {

    // Lấy user theo username - dùng cho đăng nhập
    User get(String username);

    // Lấy user theo email - dùng cho kích hoạt OTP và quên mật khẩu
    User getByEmail(String email);

    // Thêm user mới - dùng cho đăng ký
    void insert(User user);

    // Cập nhật mật khẩu mới (đã hash) theo email
    boolean updatePassword(String email, String newPassword);

    // Kích hoạt tài khoản theo email (status = 1, code = null)
    boolean activateUser(String email);

    // Cập nhật mã OTP theo email
    boolean updateCode(String email, String code);

    // Kiểm tra email đã tồn tại chưa
    boolean checkExistEmail(String email);

    // Kiểm tra username đã tồn tại chưa
    boolean checkExistUsername(String username);

    // Kiểm tra phone đã tồn tại chưa
    boolean checkExistPhone(String phone);
}
