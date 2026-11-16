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
 * TẦNG CONTROLLER - Gửi lại mã xác thực OTP
 * GET /resend-otp?email=...&type=register|forgot
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/resend-otp")
public class ResendOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String type  = req.getParameter("type"); // "register" hoặc "forgot"

        HttpSession session = req.getSession(false);
        if ((email == null || email.trim().isEmpty()) && session != null) {
            if ("forgot".equals(type)) {
                email = (String) session.getAttribute("forgot_email");
            } else {
                email = (String) session.getAttribute("verify_email");
            }
        }

        if (email == null || email.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        email = email.trim();
        UserService service = new UserServiceImpl();
        User user = service.getByEmail(email);

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Sinh mã OTP mới
        String newOtp = EmailUtil.generateOtp();
        long newExpiry = System.currentTimeMillis() + (5 * 60 * 1000);

        // Cập nhật vào DB
        service.updateCode(email, newOtp);

        String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8.toString());

        if ("forgot".equals(type)) {
            EmailUtil.sendOtpEmail(email, newOtp, "Mã OTP mới đặt lại mật khẩu");
            if (session != null) {
                session.setAttribute("forgot_otp", newOtp);
                session.setAttribute("forgot_expiry", newExpiry);
                session.setAttribute("forgot_email", email);
            }
            resp.sendRedirect(req.getContextPath() + "/reset-password?email=" + encodedEmail + "&resend=1");
        } else {
            EmailUtil.sendOtpEmail(email, newOtp, "Mã OTP mới kích hoạt tài khoản");
            if (session != null) {
                session.setAttribute("verify_otp", newOtp);
                session.setAttribute("verify_expiry", newExpiry);
                session.setAttribute("verify_email", email);
            }
            resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + encodedEmail + "&resend=1");
        }
    }
}
