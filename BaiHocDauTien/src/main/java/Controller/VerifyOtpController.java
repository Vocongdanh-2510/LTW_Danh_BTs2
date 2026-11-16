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
 * TẦNG CONTROLLER - Xác thực mã OTP kích hoạt tài khoản
 * GET  /verify-otp -> hiển thị form nhập mã OTP (verify-otp.jsp)
 * POST /verify-otp -> kiểm tra mã OTP:
 *    - Nếu đúng -> kích hoạt tài khoản (status = 1) -> redirect /login
 *    - Nếu sai -> báo lỗi và ở lại trang nhập OTP
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/verify-otp")
public class VerifyOtpController extends HttpServlet {

    public static final String VERIFY_VIEW = "/views/verify-otp.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        HttpSession session = req.getSession(false);

        if ((email == null || email.trim().isEmpty()) && session != null) {
            email = (String) session.getAttribute("verify_email");
        }

        req.setAttribute("email", email);
        req.getRequestDispatcher(VERIFY_VIEW).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String otpInput = req.getParameter("otp");

        if (email == null || email.trim().isEmpty() || otpInput == null || otpInput.trim().isEmpty()) {
            req.setAttribute("alert", "Vui lòng nhập đầy đủ email và mã OTP!");
            req.setAttribute("email", email);
            req.getRequestDispatcher(VERIFY_VIEW).forward(req, resp);
            return;
        }

        email = email.trim();
        otpInput = otpInput.trim();

        HttpSession session = req.getSession(false);
        boolean isValid = false;

        // 1. Kiểm tra OTP qua Session
        if (session != null) {
            String sessionOtp = (String) session.getAttribute("verify_otp");
            Long expiry = (Long) session.getAttribute("verify_expiry");
            String sessionEmail = (String) session.getAttribute("verify_email");

            if (sessionOtp != null && sessionOtp.equals(otpInput) && (sessionEmail == null || sessionEmail.equalsIgnoreCase(email))) {
                if (expiry == null || System.currentTimeMillis() <= expiry) {
                    isValid = true;
                }
            }
        }

        // 2. Kiểm tra OTP qua Database (phòng trường hợp mất session)
        UserService service = new UserServiceImpl();
        if (!isValid) {
            User user = service.getByEmail(email);
            if (user != null && otpInput.equals(user.getCode())) {
                isValid = true;
            }
        }

        if (isValid) {
            // Kích hoạt tài khoản thành công
            service.activateUser(email);

            if (session != null) {
                session.removeAttribute("verify_otp");
                session.removeAttribute("verify_expiry");
                session.removeAttribute("verify_email");
                session.setAttribute("registerSuccess", "Kích hoạt tài khoản thành công! Bạn có thể đăng nhập ngay bây giờ.");
            }

            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("alert", "Mã OTP không chính xác hoặc đã hết hạn (5 phút)! Vui lòng kiểm tra lại.");
            req.setAttribute("email", email);
            req.getRequestDispatcher(VERIFY_VIEW).forward(req, resp);
        }
    }
}
