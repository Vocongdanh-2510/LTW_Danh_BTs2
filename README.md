# BÀI TẬP 02: JPA 3.0 & JAKARTA EE 10 - XÁC THỰC OTP, HASH PASSWORD & CRUD CATEGORY

- **Sinh viên thực hiện**: Võ Công Danh
- **MSSV**: 24110010
- **Môn học**: Lập trình Web
- **Trường**: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)

---

## 1. Yêu cầu bài tập đã hoàn thành (3 Bài đầu tiên)

### 📌 Bài 1: Kích hoạt tài khoản bằng mã OTP gửi qua Email khi đăng ký
1. **Quy trình đăng ký & gửi mã OTP**:
   - Truy cập URL `/register`, điền thông tin đăng ký: username, fullname, email, phone, password, repassword.
   - Hệ thống tự động kiểm tra tính hợp lệ: mật khẩu khớp, kiểm tra email và username chưa tồn tại.
   - Mật khẩu được tự động băm bảo mật bằng thuật toán **SHA-256**.
   - Hệ thống sinh mã OTP ngẫu nhiên 6 chữ số có hiệu lực trong 5 phút.
   - Tài khoản được lưu vào CSDL với trạng thái `status = 0` (chưa kích hoạt) và `code = otp`.
   - Gửi mã OTP qua email (thư viện `jakarta.mail-api` & `angus-mail`), đồng thời in rõ ràng ra Server Console để kiểm thử trực tiếp.
   - Chuyển hướng người dùng sang trang `/verify-otp?email=...`.
2. **Xác thực OTP & Kích hoạt (`/verify-otp`)**:
   - Trang giao diện `views/verify-otp.jsp` cho phép người dùng nhập 6 chữ số OTP.
   - Hỗ trợ nút **"Gửi lại mã OTP"** (`/resend-otp?type=register`) nếu mã bị hết hạn hoặc thất lạc.
   - Khi nhập đúng mã OTP: hệ thống cập nhật `status = 1`, xóa mã `code` trong DB và session, chuyển sang `/login` kèm thông báo thành công.
   - Nếu đăng nhập bằng tài khoản chưa kích hoạt (`status = 0`), hệ thống sẽ từ chối và tự động điều hướng sang trang xác thực OTP.

---

### 📌 Bài 2: Đăng nhập với mật khẩu mã hóa (Hash Password) & Đăng xuất
1. **Cơ chế mã hóa băm mật khẩu (SHA-256)**:
   - Xây dựng lớp tiện ích `PasswordUtil.java` (`Utils.PasswordUtil` và `vn.iotstar.utils.PasswordUtil`) sử dụng `java.security.MessageDigest` với thuật toán **SHA-256** tạo chuỗi băm 64 ký tự Hex.
   - Mọi mật khẩu khi Đăng ký mới hoặc Đặt lại mật khẩu đều được băm bảo mật trước khi lưu vào CSDL.
   - Phương thức `checkPassword(plainPassword, storedPassword)` thông minh:
     - So khớp chuỗi băm SHA-256.
     - Tương thích ngược với các tài khoản thử nghiệm cũ (như `admin`/`admin`, `user`/`1234`).
2. **Đăng xuất (`/logout`)**:
   - `LogoutServlet.java`: Xóa toàn bộ Session (`session.invalidate()`), xóa Cookie ghi nhớ (`remember` / `username`), điều hướng an toàn về `/login`.
   - Nút đăng xuất được tích hợp trên thanh header ở trang chủ và dashboard.

---

### 📌 Bài 3: Quên mật khẩu gửi mã xác nhận OTP qua Email & Đặt lại mật khẩu
1. **Yêu cầu cấp lại mật khẩu (`/forgot-password`)**:
   - Tại trang `/login`, người dùng bấm vào liên kết **"Quên mật khẩu?"**.
   - Giao diện `views/forgot-password.jsp` yêu cầu người dùng nhập email đã đăng ký.
   - Hệ thống kiểm tra email tồn tại trong CSDL:
     - Nếu tồn tại: sinh mã OTP 6 số mới, cập nhật vào DB và session, gửi mã OTP đến email (và in ra Server Console).
     - Chuyển hướng người dùng sang `/reset-password?email=...`.
2. **Đặt lại mật khẩu mới (`/reset-password`)**:
   - Giao diện `views/reset-password.jsp` cho phép nhập: Mã OTP (6 số), Mật khẩu mới, Xác nhận mật khẩu mới.
   - Kiểm tra mã OTP còn hiệu lực (5 phút) và mật khẩu xác nhận khớp nhau.
   - Mã hóa mật khẩu mới bằng **SHA-256**, cập nhật vào CSDL, xóa mã OTP.
   - Chuyển hướng về `/login` với thông báo thành công: *"Đặt lại mật khẩu thành công! Vui lòng đăng nhập với mật khẩu mới."*

---

## 2. Danh sách các File & Controller mới bổ sung

| Tên File / Controller | Đường dẫn | Chức năng |
|-----------------------|-----------|-----------|
| `PasswordUtil.java` | `src/main/java/Utils/PasswordUtil.java` | Tiện ích băm SHA-256 và xác thực mật khẩu |
| `EmailUtil.java` | `src/main/java/Utils/EmailUtil.java` | Tiện ích sinh OTP, gửi mail SMTP và in log ra console |
| `register_controller.java` | `src/main/java/Controller/register_controller.java` | Đăng ký tài khoản, mã hóa pass, sinh OTP gửi email |
| `VerifyOtpController.java` | `src/main/java/Controller/VerifyOtpController.java` | Nhận mã OTP, kích hoạt tài khoản (`status = 1`) |
| `ResendOtpController.java` | `src/main/java/Controller/ResendOtpController.java` | Gửi lại mã OTP mới cho đăng ký / quên mật khẩu |
| `ForgotPasswordController.java` | `src/main/java/Controller/ForgotPasswordController.java` | Xử lý quên mật khẩu, gửi OTP xác nhận |
| `ResetPasswordController.java` | `src/main/java/Controller/ResetPasswordController.java` | Đặt mật khẩu mới bằng OTP, hash SHA-256 |
| `login_controller.java` | `src/main/java/Controller/login_controller.java` | Đăng nhập hash password, kiểm tra kích hoạt OTP |
| `LogoutServlet.java` | `src/main/java/Controller/LogoutServlet.java` | Đăng xuất, hủy session và cookie |
| `verify-otp.jsp` | `src/main/webapp/views/verify-otp.jsp` | Giao diện nhập mã OTP kích hoạt tài khoản |
| `forgot-password.jsp` | `src/main/webapp/views/forgot-password.jsp` | Giao diện nhập email yêu cầu cấp lại mật khẩu |
| `reset-password.jsp` | `src/main/webapp/views/reset-password.jsp` | Giao diện nhập mã OTP và đặt mật khẩu mới |
| `springtool.sql` | `springtool.sql` | Kịch bản SQL tạo bảng users có `status`, `code`, pass hash |

---

## 3. Hướng dẫn chạy và kiểm thử

### Cách 1: Chạy ứng dụng trên Tomcat 10.1 / Tomcat 11
1. Import project `BaiHocDauTien` vào **Eclipse / Spring Tool Suite (STS) / IntelliJ IDEA** (dạng Maven Project).
2. Chuột phải project -> **Run As** -> **Run on Server** (chọn Tomcat 10.1+ hoặc Tomcat 11).
3. Truy cập trình duyệt:
   - **Đăng ký (có OTP qua Email)**: `http://localhost:8080/BaiHocDauTien/register`
   - **Xác thực OTP**: `http://localhost:8080/BaiHocDauTien/verify-otp`
   - **Đăng nhập**: `http://localhost:8080/BaiHocDauTien/login`
   - **Quên mật khẩu**: `http://localhost:8080/BaiHocDauTien/forgot-password`
   - **Đăng xuất**: `http://localhost:8080/BaiHocDauTien/logout`
   - **Quản lý danh mục Category**: `http://localhost:8080/BaiHocDauTien/admin/categories`

> **Lưu ý kiểm thử OTP**: Khi thực hiện Đăng ký hoặc Quên mật khẩu, hệ thống sẽ gửi email đồng thời **luôn luôn in mã OTP trực tiếp ra Server Console** (nhật ký chạy server) dạng:
> ```
> ========================================================================
> [EMAIL NOTIFICATION - OTP SYSTEM]
>  -> Đến email:  user@gmail.com
>  -> Tiêu đề:   Mã OTP kích hoạt tài khoản của bạn
>  -> MÃ OTP:     >>> 583921 <<<
>  -> Thời hạn:   5 phút kể từ lúc gửi
> ========================================================================
> ```
> Giảng viên và người kiểm thử có thể xem ngay mã OTP trên màn hình console server để nhập và kiểm tra chức năng mà không phụ thuộc vào kết nối mạng bên ngoài.

---

## 4. Tài khoản kiểm thử
| Username | Password | Role | Trạng thái | Quyền hạn |
|----------|----------|------|------------|-----------|
| `admin`  | `admin`  | 1    | Đã kích hoạt (`status = 1`) | Quản trị viên (truy cập toàn quyền Category CRUD) |
| `user`   | `1234`   | 5    | Đã kích hoạt (`status = 1`) | Người dùng thường |
