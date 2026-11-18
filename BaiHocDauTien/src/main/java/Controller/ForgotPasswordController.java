package Controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Model.User;
import Service.UserService;
import Service.impl.UserServiceImpl;
import Utils.EmailUtil;

/**
 * TẦNG CONTROLLER - Quên mật khẩu (Bài 3)
 * GET  /forgot-password -> hiển thị form nhập Email
 * POST /forgot-password -> kiểm tra email tồn tại -> sinh OTP -> gửi qua email -> chuyển sang /reset-password
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    public static final String FORGOT_VIEW = "/views/forgot-password.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(FORGOT_VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập địa chỉ email của bạn!");
            req.getRequestDispatcher(FORGOT_VIEW).forward(req, resp);
            return;
        }

        email = email.trim();
        UserService service = new UserServiceImpl();
        User user = service.getByEmail(email);

        if (user == null) {
            req.setAttribute("alert", "Không tìm thấy tài khoản với email hoặc tên đăng nhập này trong hệ thống!");
            req.setAttribute("email", email);
            req.getRequestDispatcher(FORGOT_VIEW).forward(req, resp);
            return;
        }

        // Ưu tiên dùng email thật của user, nếu chưa có thì dùng username
        String targetIdentifier = (user.getEmail() != null && !user.getEmail().trim().isEmpty())
                ? user.getEmail().trim()
                : user.getUserName().trim();

        // Sinh mã OTP 6 số
        String otp = EmailUtil.generateOtp();
        long expiry = System.currentTimeMillis() + (5 * 60 * 1000); // 5 phút

        // Cập nhật mã OTP vào CSDL
        service.updateCode(targetIdentifier, otp);

        // Lưu thông tin vào session
        HttpSession session = req.getSession(true);
        session.setAttribute("forgot_email", targetIdentifier);
        session.setAttribute("forgot_otp", otp);
        session.setAttribute("forgot_expiry", expiry);

        // Gửi email chứa mã OTP (đồng thời in ra console server)
        EmailUtil.sendOtpEmail(targetIdentifier, otp, "Mã xác nhận đặt lại mật khẩu");

        // Chuyển hướng sang trang đặt lại mật khẩu
        String encodedEmail = URLEncoder.encode(targetIdentifier, StandardCharsets.UTF_8.toString());
        resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + encodedEmail);
    }
}
