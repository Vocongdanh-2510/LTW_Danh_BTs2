package Controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Model.User;
import Service.UserService;
import Service.impl.UserServiceImpl;

/**
 * GET  /login -> kiểm tra session/cookie -> hiện login.jsp
 * POST /login -> xử lý đăng nhập -> redirect /waiting
 */
@SuppressWarnings("serial")
@WebServlet(urlPatterns = "/login")
public class login_controller extends HttpServlet {

    // Session key lưu thông tin tài khoản
    public static final String SESSION_ACCOUNT  = "account";
    // Cookie key cho "nhớ tài khoản"
    public static final String COOKIE_REMEMBER  = "username";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Nếu đã đăng nhập (có session) -> vào waiting để phân quyền
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute(SESSION_ACCOUNT) != null) {
            resp.sendRedirect(req.getContextPath() + "/waiting");
            return;
        }

        // Kiểm tra cookie "nhớ tài khoản"
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(COOKIE_REMEMBER)) {
                    // Theo slide: lưu key "username" (không phải "account")
                    // WaitingController sẽ load User từ DB theo username này
                    session = req.getSession(true);
                    session.setAttribute("username", cookie.getValue());
                    resp.sendRedirect(req.getContextPath() + "/waiting");
                    return;
                }
            }
        }

        // Chưa đăng nhập -> hiển thị form
        req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("text/html");
        resp.setCharacterEncoding("UTF-8");
        req.setCharacterEncoding("UTF-8");

        String username    = req.getParameter("username");
        String password    = req.getParameter("password");
        String remember    = req.getParameter("remember");
        boolean isRememberMe = "on".equals(remember);
        String alertMsg    = "";

        if (username != null) username = username.trim();
        if (password != null) password = password.trim();

        req.setAttribute("username", username);

        // Validation phía Server cho Login Form
        boolean hasError = false;
        if (Utils.ValidationUtil.isEmpty(username)) {
            req.setAttribute("errorUsername", "Tên đăng nhập không được để trống!");
            hasError = true;
        } else if (username.length() < 3) {
            req.setAttribute("errorUsername", "Tên đăng nhập phải có ít nhất 3 ký tự!");
            hasError = true;
        }

        if (Utils.ValidationUtil.isEmpty(password)) {
            req.setAttribute("errorPassword", "Mật khẩu không được để trống!");
            hasError = true;
        } else if (!Utils.ValidationUtil.isValidPassword(password)) {
            req.setAttribute("errorPassword", "Mật khẩu phải có ít nhất 6 ký tự!");
            hasError = true;
        }

        if (hasError) {
            req.setAttribute("alert", "Vui lòng kiểm tra lại thông tin đăng nhập!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        // Gọi Service kiểm tra đăng nhập
        UserService service = new UserServiceImpl();
        User user = service.login(username, password);

        if (user != null) {
            // Kiểm tra trạng thái kích hoạt tài khoản bằng OTP (Bài 1)
            if (user.getStatus() == 0) {
                // Tài khoản chưa kích hoạt
                HttpSession session = req.getSession(true);
                session.setAttribute("verify_email", user.getEmail());
                session.setAttribute("verify_otp", user.getCode());
                session.setAttribute("verify_expiry", System.currentTimeMillis() + (5 * 60 * 1000));
                
                req.setAttribute("alert", "Tài khoản của bạn chưa được kích hoạt qua mã OTP! Vui lòng nhập mã OTP để kích hoạt.");
                req.setAttribute("email", user.getEmail());
                req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
                return;
            }

            // Đúng -> lưu session với key "account"
            HttpSession session = req.getSession(true);
            session.setAttribute(SESSION_ACCOUNT, user);

            // Nếu chọn "nhớ tài khoản" -> lưu cookie 30 phút
            if (isRememberMe) {
                saveRememberMe(resp, username);
            }

            // Chuyển đến WaitingController để phân quyền theo roleid
            resp.sendRedirect(req.getContextPath() + "/waiting");

        } else {
            // Sai -> quay lại form + hiện thông báo lỗi
            alertMsg = "Tài khoản hoặc mật khẩu không đúng";
            req.setAttribute("alert", alertMsg);
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }

    // Lưu cookie nhớ tài khoản - 30 phút
    private void saveRememberMe(HttpServletResponse response, String username) {
        Cookie cookie = new Cookie(COOKIE_REMEMBER, username);
        cookie.setMaxAge(30 * 60); // 30 phút
        response.addCookie(cookie);
    }
}
