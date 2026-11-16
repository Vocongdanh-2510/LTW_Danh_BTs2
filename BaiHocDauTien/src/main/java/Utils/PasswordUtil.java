package Utils;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Tiện ích mã hóa băm mật khẩu (SHA-256)
 * Phục vụ yêu cầu 2: Đăng nhập với mật khẩu được mã hóa (hash password)
 */
public class PasswordUtil {

    /**
     * Băm mật khẩu chuỗi thường thành mã băm SHA-256 dạng Hexadecimal (64 ký tự)
     * @param password Mật khẩu gốc dạng text
     * @return Chuỗi băm SHA-256
     */
    public static String hashPassword(String password) {
        if (password == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Lỗi: Không tìm thấy thuật toán SHA-256", e);
        }
    }

    /**
     * Kiểm tra mật khẩu plain-text nhập vào có khớp với mật khẩu lưu trong DB hay không.
     * Hỗ trợ 2 trường hợp:
     * 1. Mật khẩu trong DB đã được hash SHA-256 -> băm mật khẩu nhập vào rồi so sánh.
     * 2. Mật khẩu trong DB là mật khẩu thường (các tài khoản seed sẵn như admin/1234) -> so sánh trực tiếp
     *    để đảm bảo không làm gián đoạn các tài khoản cũ.
     *
     * @param plainPassword Mật khẩu người dùng nhập vào từ form
     * @param storedPassword Mật khẩu đang lưu trong Database
     * @return true nếu mật khẩu khớp, ngược lại false
     */
    public static boolean checkPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }

        // So khớp với mã băm SHA-256
        String hashedInput = hashPassword(plainPassword);
        if (hashedInput.equalsIgnoreCase(storedPassword)) {
            return true;
        }

        // Tương thích ngược với mật khẩu chưa băm
        return plainPassword.equals(storedPassword);
    }
}
