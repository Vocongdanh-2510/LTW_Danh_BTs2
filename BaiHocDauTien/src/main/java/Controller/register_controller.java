package Controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Service.UserService;
import Service.impl.UserServiceImpl;
import Utils.EmailUtil;

/**
 * TẦNG CONTROLLER - Đăng ký
 * GET  /register -> kiểm tra session/cookie -> hiện register.jsp
 * POST /register -> xử lý đăng ký
 *   - Kiểm tra password và repassword
 *   - Kiểm tra email đã tồn tại
 *   - Kiểm tra username đã tồn tại
 *   - Sinh mã OTP và gửi qua email
 *   - Lưu trạng thái tài khoản chờ kích hoạt (status = 0)
 *   - Chuyển hướng sang trang nhập mã OTP (/verify-otp)
 */
@SuppressWarnings({"serial", "static-access"})
@WebServlet(urlPatterns = "/register")
public class register_controller extends HttpServlet {

    public static final String REGISTER = "/views/register.jsp";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu đã đăng nhập -> về trang admin/waiting
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("account") != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        // Kiểm tra cookie
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(login_controller.COOKIE_REMEMBER)) {
                    session = req.getSession(true);
                    session.setAttribute("account", cookie.getValue());
                    resp.sendRedirect(req.getContextPath() + "/waiting");
                    return;
                }
            }
        }

        // Hiển thị form đăng ký
        req.getRequestDispatcher(REGISTER).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        String username   = req.getParameter("username");
        String password   = req.getParameter("password");
        String repassword = req.getParameter("repassword");
        String email      = req.getParameter("email");
        String fullname   = req.getParameter("fullname");
        String phone      = req.getParameter("phone");

        UserService service = new UserServiceImpl();
        String alertMsg = "";

        // Kiểm tra mật khẩu xác nhận
        if (repassword != null && !repassword.trim().isEmpty() && !password.equals(repassword)) {
            alertMsg = "Mật khẩu xác nhận không khớp!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(REGISTER).forward(req, resp);
            return;
        }

        // Kiểm tra email đã tồn tại chưa
        if (service.checkExistEmail(email)) {
            alertMsg = "Email đã tồn tại trong hệ thống!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(REGISTER).forward(req, resp);
            return;
        }

        // Kiểm tra username đã tồn tại chưa
        if (service.checkExistUsername(username)) {
            alertMsg = "Tài khoản (username) đã tồn tại!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(REGISTER).forward(req, resp);
            return;
        }

        // ── BÀI 1: Sinh mã OTP ngẫu nhiên 6 số và gửi qua email ──
        String otp = EmailUtil.generateOtp();
        long expiryTime = System.currentTimeMillis() + (5 * 60 * 1000); // Hết hạn sau 5 phút

        // Lưu thông tin người dùng vào CSDL với status = 0 (chưa kích hoạt) và code = otp
        boolean isSuccess = service.registerWithOtp(username, password, email, fullname, phone, otp);

        if (isSuccess) {
            // Gửi OTP qua email (đồng thời log ra console server để test ngay)
            EmailUtil.sendOtpEmail(email, otp, "Mã OTP kích hoạt tài khoản của bạn");

            // Lưu thông tin xác thực vào session
            HttpSession session = req.getSession(true);
            session.setAttribute("verify_otp", otp);
            session.setAttribute("verify_email", email);
            session.setAttribute("verify_expiry", expiryTime);
            session.setAttribute("verify_type", "register");

            // Chuyển hướng sang trang nhập OTP
            String encodedEmail = URLEncoder.encode(email, StandardCharsets.UTF_8.toString());
            resp.sendRedirect(req.getContextPath() + "/verify-otp?email=" + encodedEmail);
        } else {
            alertMsg = "Đã xảy ra lỗi khi tạo tài khoản, vui lòng thử lại!";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher(REGISTER).forward(req, resp);
        }
    }
}
