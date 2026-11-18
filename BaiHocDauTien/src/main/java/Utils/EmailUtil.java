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

    // Cấu hình tài khoản gửi Email qua Google SMTP
    public static final String SMTP_HOST = "smtp.gmail.com";
    public static final String SMTP_PORT = "587";
    public static String SENDER_EMAIL = "vocongdanh01w2@gmail.com";
    
    // Mật khẩu ứng dụng (App Password 16 chữ cái) của Gmail
    // Có thể cấu hình trực tiếp ở đây hoặc qua biến môi trường GMAIL_APP_PASSWORD
    public static String SENDER_PASSWORD = "your-app-password";

    /**
     * Lấy mật khẩu app thực tế (ưu tiên biến môi trường hoặc biến static)
     */
    public static String getAppPassword() {
        String envPass = System.getenv("GMAIL_APP_PASSWORD");
        if (envPass != null && !envPass.trim().isEmpty()) {
            return envPass.trim();
        }
        return SENDER_PASSWORD;
    }

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
        System.out.println(" -> Đến email / tài khoản: " + toEmail);
        System.out.println(" -> Tiêu đề:             " + subject);
        System.out.println(" -> MÃ OTP:               >>> " + otp + " <<<");
        System.out.println(" -> Thời hạn hiệu lực:    5 phút kể từ lúc gửi");
        System.out.println("========================================================================");

        // Nội dung HTML của email
        String content = "<div style='font-family: Arial, sans-serif; max-width: 500px; margin: auto; padding: 25px; border: 1px solid #e1e4e8; border-radius: 10px; background-color: #ffffff;'>"
                + "<h2 style='color: #111; text-align: center; border-bottom: 2px solid #111; padding-bottom: 15px; margin-top: 0;'>" + subject + "</h2>"
                + "<p style='font-size: 15px; color: #333;'>Xin chào <b>" + toEmail + "</b>,</p>"
                + "<p style='font-size: 14px; color: #555;'>Hệ thống nhận được yêu cầu xác thực tài khoản từ bạn. Vui lòng sử dụng mã OTP dưới đây để hoàn tất:</p>"
                + "<div style='background: #f6f8fa; padding: 18px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #0969da; border: 1px dashed #0969da; border-radius: 8px; margin: 25px 0;'>"
                + otp + "</div>"
                + "<p style='color: #cf222e; font-size: 13px;'>* <b>Lưu ý:</b> Mã xác nhận này có hiệu lực trong vòng <b>5 phút</b>. Tuyệt đối không chia sẻ mã này cho bất kỳ ai.</p>"
                + "<hr style='border: none; border-top: 1px solid #eaecef; margin-top: 25px;'/>"
                + "<p style='font-size: 12px; color: #6e7781; text-align: center; margin-bottom: 0;'>Hệ thống Lập Trình Web - Sinh viên Võ Công Danh (MSSV: 24110010)</p>"
                + "</div>";

        String activePassword = getAppPassword();

        // Thử gửi qua Jakarta Mail nếu đã có cấu hình App Password hợp lệ
        if (activePassword != null && !activePassword.trim().isEmpty() && !activePassword.equals("your-app-password")) {
            try {
                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.starttls.required", "true");
                props.put("mail.smtp.host", SMTP_HOST);
                props.put("mail.smtp.port", SMTP_PORT);
                props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
                props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
                props.put("mail.smtp.connectiontimeout", "6000");
                props.put("mail.smtp.timeout", "6000");
                props.put("mail.smtp.writetimeout", "6000");

                jakarta.mail.Session session = jakarta.mail.Session.getInstance(props, new jakarta.mail.Authenticator() {
                    @Override
                    protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new jakarta.mail.PasswordAuthentication(SENDER_EMAIL, activePassword);
                    }
                });

                jakarta.mail.internet.MimeMessage message = new jakarta.mail.internet.MimeMessage(session);
                message.setFrom(new jakarta.mail.internet.InternetAddress(SENDER_EMAIL, "Hệ Thống Lập Trình Web - Võ Công Danh"));
                message.setRecipient(jakarta.mail.Message.RecipientType.TO, new jakarta.mail.internet.InternetAddress(toEmail));
                message.setSubject(subject, "UTF-8");
                message.setContent(content, "text/html; charset=UTF-8");

                jakarta.mail.Transport.send(message);
                System.out.println("[EMAIL SUCCESS] Đã gửi email thực tế thành công đến hòm thư: " + toEmail);
            } catch (Throwable e) {
                System.err.println("[EMAIL WARNING] Không thể gửi email qua Gmail SMTP (" + e.getMessage() + ").");
                System.out.println("[EMAIL INFO] Bạn có thể lấy mã OTP trực tiếp từ Console ở trên: " + otp);
            }
        } else {
            System.out.println("[EMAIL INFO] SENDER_PASSWORD hiện tại là mặc định (chưa gắn 16 chữ cái App Password Gmail).");
            System.out.println("[EMAIL INFO] Đã in mã OTP ra Console server để test trực tiếp: " + otp);
        }

        return true;
    }
}
