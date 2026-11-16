package Controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Model.User;
import Service.UserService;
import Service.impl.UserServiceImpl;

/**
 * TẦNG CONTROLLER - Đặt lại mật khẩu bằng mã OTP (Bài 3)
 * GET  /reset-password -> hiển thị form nhập OTP & mật khẩu mới
 * POST /reset-password -> xác thực OTP, kiểm tra khớp mật khẩu -> hash SHA-256 -> update DB -> redirect /login
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/reset-password")
public class ResetPasswordController extends HttpServlet {

    public static final String RESET_VIEW = "/views/reset-password.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        HttpSession session = req.getSession(false);

        if ((email == null || email.trim().isEmpty()) && session != null) {
            email = (String) session.getAttribute("forgot_email");
        }

        req.setAttribute("email", email);

        if ("1".equals(req.getParameter("resend"))) {
            req.setAttribute("msg", "Mã OTP mới đã được gửi tới email của bạn!");
        }

        req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email       = req.getParameter("email");
        String otpInput    = req.getParameter("otp");
        String newPassword = req.getParameter("newPassword");
        String rePassword  = req.getParameter("rePassword");

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Email không hợp lệ!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
            return;
        }

        email = email.trim();
        req.setAttribute("email", email);

        if (otpInput == null || otpInput.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || rePassword == null || rePassword.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ mã OTP và mật khẩu mới!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
            return;
        }

        otpInput = otpInput.trim();

        // Kiểm tra khớp mật khẩu
        if (!newPassword.equals(rePassword)) {
            req.setAttribute("alert", "Mật khẩu xác nhận không khớp!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
            return;
        }

        // Kiểm tra OTP
        HttpSession session = req.getSession(false);
        boolean isValidOtp = false;

        if (session != null) {
            String sessionOtp = (String) session.getAttribute("forgot_otp");
            Long expiry = (Long) session.getAttribute("forgot_expiry");
            String sessionEmail = (String) session.getAttribute("forgot_email");

            if (sessionOtp != null && sessionOtp.equals(otpInput) && (sessionEmail == null || sessionEmail.equalsIgnoreCase(email))) {
                if (expiry == null || System.currentTimeMillis() <= expiry) {
                    isValidOtp = true;
                }
            }
        }

        UserService service = new UserServiceImpl();
        if (!isValidOtp) {
            User user = service.getByEmail(email);
            if (user != null && otpInput.equals(user.getCode())) {
                isValidOtp = true;
            }
        }

        if (!isValidOtp) {
            req.setAttribute("alert", "Mã OTP không chính xác hoặc đã hết hạn (5 phút)! Vui lòng kiểm tra lại.");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
            return;
        }

        // Cập nhật mật khẩu mới (được mã hóa SHA-256 trong service)
        boolean isSuccess = service.updatePassword(email, newPassword);

        if (isSuccess) {
            if (session != null) {
                session.removeAttribute("forgot_otp");
                session.removeAttribute("forgot_expiry");
                session.removeAttribute("forgot_email");
                session.setAttribute("registerSuccess", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("alert", "Đã xảy ra lỗi khi cập nhật mật khẩu, vui lòng thử lại!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
        }
    }
}
