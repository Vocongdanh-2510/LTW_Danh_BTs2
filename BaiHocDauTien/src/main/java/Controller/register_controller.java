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

        if (username != null) username = username.trim();
        if (email != null) email = email.trim();
        if (fullname != null) fullname = fullname.trim();
        if (phone != null) phone = phone.trim();

        // Lưu lại dữ liệu người dùng đã nhập
        req.setAttribute("username", username);
        req.setAttribute("email", email);
        req.setAttribute("fullname", fullname);
        req.setAttribute("phone", phone);

        UserService service = new UserServiceImpl();
        boolean hasError = false;

        // 1. Validate username
        if (Utils.ValidationUtil.isEmpty(username)) {
            req.setAttribute("errorUsername", "Tên đăng nhập không được để trống!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidUsername(username)) {
            req.setAttribute("errorUsername", "Tên đăng nhập từ 3 - 50 ký tự, không chứa khoảng trắng hay ký tự đặc biệt!");
            hasError = true;
        } else if (service.checkExistUsername(username)) {
            req.setAttribute("errorUsername", "Tên đăng nhập này đã tồn tại trong hệ thống!");
            hasError = true;
        }

        // 2. Validate fullname
        if (Utils.ValidationUtil.isEmpty(fullname)) {
            req.setAttribute("errorFullname", "Họ và tên không được để trống!");
            hasError = true;
        } else if (fullname.length() < 2) {
            req.setAttribute("errorFullname", "Họ và tên phải có ít nhất 2 ký tự!");
            hasError = true;
        }

        // 3. Validate email
        if (Utils.ValidationUtil.isEmpty(email)) {
            req.setAttribute("errorEmail", "Địa chỉ email không được để trống!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorEmail", "Định dạng email không hợp lệ (Ví dụ: user@example.com)!");
            hasError = true;
        } else if (service.checkExistEmail(email)) {
            req.setAttribute("errorEmail", "Email này đã được sử dụng bởi tài khoản khác!");
            hasError = true;
        }

        // 4. Validate phone
        if (Utils.ValidationUtil.isEmpty(phone)) {
            req.setAttribute("errorPhone", "Số điện thoại không được để trống!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidPhone(phone)) {
            req.setAttribute("errorPhone", "Số điện thoại không hợp lệ (gồm 10 số, bắt đầu bằng 03, 05, 07, 08, 09)!");
            hasError = true;
        }

        // 5. Validate password
        if (Utils.ValidationUtil.isEmpty(password)) {
            req.setAttribute("errorPassword", "Mật khẩu không được để trống!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidPassword(password)) {
            req.setAttribute("errorPassword", "Mật khẩu phải có tối thiểu 6 ký tự!");
            hasError = true;
        }

        // 6. Validate repassword
        if (Utils.ValidationUtil.isEmpty(repassword)) {
            req.setAttribute("errorRepassword", "Vui lòng nhập lại mật khẩu xác nhận!");
            hasError = true;
        } else if (!password.equals(repassword)) {
            req.setAttribute("errorRepassword", "Mật khẩu xác nhận không khớp!");
            hasError = true;
        }

        if (hasError) {
            req.setAttribute("alert", "Vui lòng kiểm tra lại các trường thông tin đăng ký bên dưới!");
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
            req.setAttribute("alert", "Đã xảy ra lỗi khi tạo tài khoản, vui lòng thử lại!");
            req.getRequestDispatcher(REGISTER).forward(req, resp);
        }
    }
}
