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

        HttpSession session = req.getSession(false);

        // Fallback lấy email từ session nếu form submit bị thiếu
        if ((email == null || email.trim().isEmpty()) && session != null) {
            email = (String) session.getAttribute("forgot_email");
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("alert", "Thông tin tài khoản không hợp lệ hoặc phiên đã hết hạn!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
            return;
        }

        email = email.trim();
        req.setAttribute("email", email);

        boolean hasError = false;
        if (Utils.ValidationUtil.isEmpty(otpInput)) {
            req.setAttribute("errorOtp", "Vui lòng nhập mã OTP 6 chữ số!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidOtp(otpInput.trim())) {
            req.setAttribute("errorOtp", "Mã OTP phải gồm chính xác 6 chữ số!");
            hasError = true;
        }

        if (Utils.ValidationUtil.isEmpty(newPassword)) {
            req.setAttribute("errorNewPassword", "Vui lòng nhập mật khẩu mới!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidPassword(newPassword)) {
            req.setAttribute("errorNewPassword", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            hasError = true;
        }

        if (Utils.ValidationUtil.isEmpty(rePassword)) {
            req.setAttribute("errorRePassword", "Vui lòng xác nhận mật khẩu mới!");
            hasError = true;
        } else if (newPassword != null && !newPassword.equals(rePassword)) {
            req.setAttribute("errorRePassword", "Mật khẩu xác nhận không khớp!");
            hasError = true;
        }

        if (hasError) {
            req.setAttribute("alert", "Vui lòng kiểm tra lại thông tin đặt lại mật khẩu!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
            return;
        }

        otpInput = otpInput.trim();

        // Kiểm tra OTP
        boolean isValidOtp = false;

        if (session != null) {
            String sessionOtp = (String) session.getAttribute("forgot_otp");
            Long expiry = (Long) session.getAttribute("forgot_expiry");

            if (sessionOtp != null && sessionOtp.equals(otpInput)) {
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
        System.out.println("[RESET-PASSWORD] Kết quả đổi mật khẩu cho '" + email + "': " + isSuccess);

        if (isSuccess) {
            if (session != null) {
                session.removeAttribute("forgot_otp");
                session.removeAttribute("forgot_expiry");
                session.removeAttribute("forgot_email");
                session.removeAttribute("account");
                session.setAttribute("registerSuccess", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới.");
            }
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("alert", "Đã xảy ra lỗi khi cập nhật mật khẩu vào CSDL, vui lòng kiểm tra lại kết nối Database!");
            req.getRequestDispatcher(RESET_VIEW).forward(req, resp);
        }
    }
}
