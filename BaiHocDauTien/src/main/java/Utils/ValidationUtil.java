package Utils;

import java.util.regex.Pattern;

/**
 * Tiện ích kiểm tra và xác thực dữ liệu (Form Validation)
 * Phục vụ Yêu cầu 2: Validation cho Login, Register, ForgotPassword, Insert, Edit
 */
public class ValidationUtil {

    // Regex kiểm tra định dạng email tiêu chuẩn RFC 5322 cơ bản
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    );

    // Regex kiểm tra số điện thoại Việt Nam (10 số, bắt đầu bằng 03, 05, 07, 08, 09)
    private static final Pattern PHONE_PATTERN = Pattern.compile(
        "^(0|\\+84)(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-9]|9[0-9])[0-9]{7}$"
    );

    // Regex kiểm tra username (3 - 50 ký tự, chữ cái, số, gạch dưới)
    private static final Pattern USERNAME_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9_]{3,50}$"
    );

    // Regex kiểm tra mã OTP (đúng 6 chữ số)
    private static final Pattern OTP_PATTERN = Pattern.compile(
        "^[0-9]{6}$"
    );

    public static boolean isEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        // Bỏ khoảng trắng và dấu gạch nối nếu có
        String cleanPhone = phone.replaceAll("[\\s-]", "");
        return PHONE_PATTERN.matcher(cleanPhone).matches();
    }

    public static boolean isValidUsername(String username) {
        if (isEmpty(username)) return false;
        return USERNAME_PATTERN.matcher(username.trim()).matches();
    }

    public static boolean isValidPassword(String password) {
        if (isEmpty(password)) return false;
        return password.trim().length() >= 6;
    }

    public static boolean isValidOtp(String otp) {
        if (isEmpty(otp)) return false;
        return OTP_PATTERN.matcher(otp.trim()).matches();
    }

    public static boolean isValidLength(String str, int min, int max) {
        if (str == null) return false;
        int len = str.trim().length();
        return len >= min && len <= max;
    }
}
