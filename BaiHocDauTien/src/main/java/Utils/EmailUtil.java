package Utils;

import java.util.Properties;
import java.util.Random;

/**
 * Tiện ích gửi Email và sinh mã xác thực OTP
 * Phục vụ:
 * - Yêu cầu 1: Kích hoạt tài khoản bằng OTP gửi qua email khi đăng ký
 * - Yêu cầu 3: Quên mật khẩu gửi mã xác nhận OTP qua email
 */
public class EmailUtil {

    // Cấu hình tài khoản gửi Email (có thể đổi sang tài khoản của bạn)
    public static final String SMTP_HOST = "smtp.gmail.com";
    public static final String SMTP_PORT = "587";
    public static final String SENDER_EMAIL = "vocongdanh01w2@gmail.com";
    // Mật khẩu ứng dụng (App Password) 16 ký tự của Gmail nếu có
    public static final String SENDER_PASSWORD = "your-app-password";

    /**
     * Sinh mã OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random random = new Random();
        int number = random.nextInt(900000) + 100000; // 100000 -> 999999
        return String.valueOf(number);
    }

    /**
     * Gửi email mã OTP
     * Luôn luôn in mã OTP ra Server Console để đảm bảo giảng viên và sinh viên
     * có thể test và kích hoạt ngay lập tức kể cả khi máy không có mạng hoặc chưa có App Password.
     *
     * @param toEmail Email người nhận
     * @param otp Mã OTP 6 chữ số
     * @param subject Tiêu đề email
     * @return true nếu gửi thành công hoặc đã log OTP ra console
     */
    public static boolean sendOtpEmail(String toEmail, String otp, String subject) {
        // In mã OTP ra Server Console rõ ràng
        System.out.println("========================================================================");
        System.out.println("[EMAIL NOTIFICATION - OTP SYSTEM]");
        System.out.println(" -> Đến email:  " + toEmail);
        System.out.println(" -> Tiêu đề:   " + subject);
        System.out.println(" -> MÃ OTP:     >>> " + otp + " <<<");
        System.out.println(" -> Thời hạn:   5 phút kể từ lúc gửi");
        System.out.println("========================================================================");

        // Nội dung HTML của email
        String content = "<div style='font-family: Arial, sans-serif; max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;'>"
                + "<h2 style='color: #111; text-align: center; border-bottom: 2px solid #111; padding-bottom: 10px;'>" + subject + "</h2>"
                + "<p>Xin chào,</p>"
                + "<p>Hệ thống nhận được yêu cầu xác thực tài khoản từ bạn. Vui lòng nhập mã OTP bên dưới:</p>"
                + "<div style='background: #f4f6f8; padding: 15px; text-align: center; font-size: 28px; font-weight: bold; letter-spacing: 6px; color: #1a2942; border-radius: 6px; margin: 20px 0;'>"
                + otp + "</div>"
                + "<p style='color: #e74c3c; font-size: 13px;'>* Lưu ý: Mã này có hiệu lực trong vòng <b>5 phút</b>. Không chia sẻ mã này cho bất kỳ ai.</p>"
                + "<hr style='border: none; border-top: 1px solid #eee; margin-top: 25px;'/>"
                + "<p style='font-size: 12px; color: #888; text-align: center;'>Hệ thống Lập Trình Web - Sinh viên Võ Công Danh (24110010)</p>"
                + "</div>";

        // Thử gửi qua Jakarta Mail nếu đã nạp thư viện và có cấu hình mạng
        try {
            // Kiểm tra xem class Jakarta Mail có sẵn không
            Class.forName("jakarta.mail.Session");

            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");

            jakarta.mail.Session session = jakarta.mail.Session.getInstance(props, new jakarta.mail.Authenticator() {
                @Override
                protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new jakarta.mail.PasswordAuthentication(SENDER_EMAIL, SENDER_PASSWORD);
                }
            });

            jakarta.mail.internet.MimeMessage message = new jakarta.mail.internet.MimeMessage(session);
            message.setFrom(new jakarta.mail.internet.InternetAddress(SENDER_EMAIL, "Webst2 - Vo Cong Danh"));
            message.setRecipient(jakarta.mail.Message.RecipientType.TO, new jakarta.mail.internet.InternetAddress(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(content, "text/html; charset=UTF-8");

            // Chỉ gửi nếu không phải placeholder
            if (!SENDER_PASSWORD.equals("your-app-password")) {
                jakarta.mail.Transport.send(message);
                System.out.println("[EMAIL SUCCESS] Đã gửi email thực tế đến: " + toEmail);
            } else {
                System.out.println("[EMAIL INFO] Chưa cấu hình SENDER_PASSWORD thực tế. Mã OTP đã sẵn sàng trên Console.");
            }
            return true;
        } catch (ClassNotFoundException e) {
            System.out.println("[EMAIL INFO] Thư viện Jakarta Mail chưa được tải trong môi trường này. Mã OTP đã được in ra console.");
            return true;
        } catch (Throwable e) {
            System.out.println("[EMAIL NOTICE] Gửi email qua mạng không thành công (" + e.getMessage() + ").");
            System.out.println("[EMAIL NOTICE] Dùng mã OTP trên Console server: " + otp);
            return true;
        }
    }
}
