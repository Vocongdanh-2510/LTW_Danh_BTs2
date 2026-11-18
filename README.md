# BÀI TẬP 03: JPA 3.0 & JAKARTA EE 10 - QUẢN LÝ VIDEOS, OTP, HASH PASSWORD & CRUD CATEGORY

- **Sinh viên thực hiện**: Võ Công Danh
- **MSSV**: 24110010
- **Môn học**: Lập trình Web
- **Trường**: Đại học Sư phạm Kỹ thuật TP.HCM (HCMUTE)

---

## 1. Danh sách yêu cầu bài tập đã hoàn thành đầy đủ

### 📌 Bài 1: Kích hoạt tài khoản bằng mã OTP gửi qua Email khi đăng ký
1. **Quy trình đăng ký & gửi mã OTP**:
   - Truy cập URL `/register`, điền thông tin đăng ký: username, fullname, email, phone, password, repassword.
   - Hệ thống tự động kiểm tra tính hợp lệ: mật khẩu khớp, kiểm tra email và username chưa tồn tại.
   - Mật khẩu được tự động băm bảo mật bằng thuật toán **SHA-256**.
   - Hệ thống sinh mã OTP ngẫu nhiên 6 chữ số có hiệu lực trong 5 phút.
   - Tài khoản được lưu vào CSDL với trạng thái `status = 0` (chưa kích hoạt) và `code = otp`.
   - Gửi mã OTP qua email (`jakarta.mail-api` & `angus-mail`), đồng thời in rõ ràng ra Server Console để kiểm thử trực tiếp.
   - Chuyển hướng người dùng sang trang `/verify-otp?email=...`.
2. **Xác thực OTP & Kích hoạt (`/verify-otp`)**:
   - Trang giao diện `views/verify-otp.jsp` cho phép người dùng nhập 6 chữ số OTP.
   - Hỗ trợ nút **"Gửi lại mã OTP"** (`/resend-otp?type=register`) nếu mã bị hết hạn hoặc thất lạc.
   - Khi nhập đúng mã OTP: hệ thống cập nhật `status = 1`, xóa mã `code` trong DB và session, chuyển sang `/login` kèm thông báo thành công.
   - Nếu đăng nhập bằng tài khoản chưa kích hoạt (`status = 0`), hệ thống sẽ từ chối và tự động điều hướng sang trang xác thực OTP.

---

### 📌 Bài 2: Đăng nhập với mật khẩu mã hóa (Hash Password) & Đăng xuất
1. **Cơ chế mã hóa băm mật khẩu (SHA-256)**:
   - Xây dựng lớp tiện ích `PasswordUtil.java` (`vn.iotstar.utils.PasswordUtil`) sử dụng `java.security.MessageDigest` với thuật toán **SHA-256** tạo chuỗi băm 64 ký tự Hex.
   - Mọi mật khẩu khi Đăng ký mới hoặc Đặt lại mật khẩu đều được băm bảo mật trước khi lưu vào CSDL.
   - Phương thức `checkPassword(plainPassword, storedPassword)` tương thích cả mã băm SHA-256 và mật khẩu plaintext cũ.
2. **Đăng xuất (`/logout`)**:
   - `LogoutServlet.java`: Xóa toàn bộ Session (`session.invalidate()`), xóa Cookie ghi nhớ (`remember` / `username`), điều hướng an toàn về `/login`.

---

### 📌 Bài 3: Quên mật khẩu gửi mã xác nhận OTP qua Email & Đặt lại mật khẩu
1. **Yêu cầu cấp lại mật khẩu (`/forgot-password`)**:
   - Tại trang `/login`, người dùng bấm vào liên kết **"Quên mật khẩu?"**.
   - Giao diện `views/forgot-password.jsp` yêu cầu người dùng nhập email đã đăng ký.
   - Hệ thống kiểm tra email tồn tại trong CSDL, sinh mã OTP 6 số mới, cập nhật vào DB/session, gửi mã OTP đến email và in ra Server Console.
2. **Đặt lại mật khẩu mới (`/reset-password`)**:
   - Nhập OTP (6 số), mật khẩu mới và xác nhận mật khẩu.
   - Mã hóa mật khẩu mới bằng **SHA-256**, cập nhật vào CSDL, xóa mã OTP và chuyển hướng về `/login`.

---

### 📌 Bài 4: Bảng Videos (quan hệ 1 - n với Users), CRUD Videos, Top 10 Trang chủ & Phân trang 6sp/trang
1. **Thêm bảng `videos` vào database với mối liên hệ 1 - n với bảng `users`**:
   - CSDL tạo bảng `videos` chứa khóa ngoại `userId INT NOT NULL`, thiết lập `CONSTRAINT FK_Videos_Users FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE`.
   - Trong Entity `vn.iotstar.entity.Video`:
     - `@ManyToOne @JoinColumn(name = "userId") private User user;`
   - Trong Entity `vn.iotstar.entity.User`:
     - `@OneToMany(mappedBy = "user", cascade = CascadeType.ALL, fetch = FetchType.LAZY) private List<Video> videos = new ArrayList<>();`
2. **Thực hiện CRUD cho bảng Videos (`/admin/videos`)**:
   - `VideoAdminController.java`:
     - **Xem danh sách**: `/admin/videos` hiển thị toàn bộ video với poster, mã video, tiêu đề, người đăng (user), danh mục, lượt xem, trạng thái.
     - **Thêm mới**: `/admin/video/add` và `/admin/video/insert` cho phép nhập thông tin, chọn user đăng video, danh mục.
     - **Sửa video**: `/admin/video/edit` và `/admin/video/update` chỉnh sửa tiêu đề, mô tả, lượt xem, trạng thái, cập nhật file.
     - **Xóa video**: `/admin/video/delete?id=...` xóa video khỏi hệ thống.
3. **Hiển thị 10 video mới nhất lên trang chủ (`/home`)**:
   - Controller `HomeController.java` (`urlPatterns = { "/home", "/trang-chu" }`) truy vấn `videoService.findTop10Newest()` (lấy 10 video có `active = true` sắp xếp theo ngày đăng mới nhất).
   - Hiển thị lưới thẻ video (Grid cards) gồm ảnh poster, tiêu đề, tác giả, lượt xem, hiệu ứng play overlay.
4. **Hiển thị tất cả videos của user và phân trang 6sp/trang trên URL `/video`**:
   - Controller `VideoUserController.java` (`urlPatterns = { "/video" }`):
     - Phân trang đúng **6 video/trang** (`pageSize = 6`).
     - Hỗ trợ xem tất cả video hoặc lọc video theo User (`/video?userId=...` hoặc nút "Video của tôi" nếu đã đăng nhập).
     - Thanh điều hướng phân trang đầy đủ: Nút Trước, các số trang [1], [2], ..., Nút Sau.
5. **Hiển thị chi tiết và play 01 video khi bấm chuột vào tiêu đề trên trang chủ `/home` và trên trang `/video`**:
   - Khi bấm chuột vào tiêu đề của video trên trang chủ `/home`: chuyển hướng tới `/home?id=...` hoặc `/video/detail?id=...`, tự động bật khung trình phát Video Player trên đầu trang và tự động tăng lượt xem (`views + 1`).
   - Khi bấm chuột vào tiêu đề của video trên trang `/video`: chuyển hướng tới `/video?id=...` hoặc `/video/detail?id=...`, phát video ngay trên trang hoặc chuyển sang trang chi tiết đầy đủ `views/video-detail.jsp`.
   - Trình phát video thông minh:
     - Nhận diện link YouTube tự động trích xuất Video ID và phát qua thẻ `<iframe>` chuẩn nhúng YouTube.
     - Nhận diện file video MP4/WebM upload từ máy tính và phát qua thẻ HTML5 `<video controls autoplay>`.
6. **Xử lý upload file bằng Multipart (theo tài liệu `10_UploadFile_servlet_jakarta.pdf`)**:
   - Sử dụng `@MultipartConfig` trong `VideoAdminController.java`.
   - Tiếp nhận file poster ảnh qua `request.getPart("posterFile")` và file video qua `request.getPart("videoFile")`.
   - File upload được lưu vào thư mục `constants.DIR` (`C:/upload`) và được phục vụ trực tiếp qua Servlet stream `ImageController` (`/image?fname=...` và `/video/stream?fname=...`).

---

## 2. Danh sách các File & Controller đã thực hiện

| Tên File / Controller | Đường dẫn | Chức năng |
|-----------------------|-----------|-----------|
| `Video.java` | `src/main/java/vn/iotstar/entity/Video.java` | Entity JPA Video (quan hệ `@ManyToOne` với `User` và `Category`, helper YouTube) |
| `User.java` | `src/main/java/vn/iotstar/entity/User.java` | Entity JPA User (quan hệ `@OneToMany` với `Video`) |
| `IVideoDao.java` | `src/main/java/vn/iotstar/dao/IVideoDao.java` | Interface DAO thao tác dữ liệu Video (CRUD, Top 10, phân trang 6sp/trang) |
| `VideoDao.java` | `src/main/java/vn/iotstar/dao/impl/VideoDao.java` | Triển khai JPA JPQL cho Video |
| `IVideoService.java` | `src/main/java/vn/iotstar/service/IVideoService.java` | Interface tầng Service xử lý nghiệp vụ Video |
| `VideoServiceImpl.java` | `src/main/java/vn/iotstar/service/impl/VideoServiceImpl.java` | Triển khai Service Video |
| `VideoAdminController.java` | `src/main/java/vn/iotstar/controller/VideoAdminController.java` | Servlet Quản lý CRUD Video, upload file Multipart |
| `HomeController.java` | `src/main/java/vn/iotstar/controller/HomeController.java` | Servlet Trang chủ `/home`, lấy 10 video mới nhất, phát video khi bấm tiêu đề |
| `VideoUserController.java` | `src/main/java/vn/iotstar/controller/VideoUserController.java` | Servlet URL `/video`, phân trang 6 video/trang, phát video khi bấm tiêu đề |
| `VideoDetailController.java` | `src/main/java/vn/iotstar/controller/VideoDetailController.java` | Servlet URL `/video/detail`, xem chi tiết và phát video, tăng view count |
| `ImageController.java` | `src/main/java/vn/iotstar/controller/ImageController.java` | Phục vụ xem ảnh và stream video MP4 (`/image`, `/video/stream`) |
| `home.jsp` | `src/main/webapp/views/home.jsp` | Giao diện Trang chủ: hiển thị 10 video mới nhất, trình phát video khi bấm chọn |
| `video-list.jsp` | `src/main/webapp/views/video-list.jsp` | Giao diện URL `/video`: phân trang 6sp/trang, bộ lọc, player phát video |
| `video-detail.jsp` | `src/main/webapp/views/video-detail.jsp` | Giao diện chi tiết video, trình phát YouTube / HTML5 MP4, video liên quan |
| `video-list.jsp` (admin) | `src/main/webapp/views/admin/video-list.jsp` | Giao diện quản lý CRUD danh sách Video của Admin |
| `video-add.jsp` (admin) | `src/main/webapp/views/admin/video-add.jsp` | Giao diện form thêm video mới kèm upload Multipart |
| `video-edit.jsp` (admin) | `src/main/webapp/views/admin/video-edit.jsp` | Giao diện form chỉnh sửa video |
| `springtool.sql` | `springtool.sql` | Kịch bản SQL tạo bảng users, categories, videos (FK userId) & 12 video mẫu |

---

## 3. Hướng dẫn chạy và kiểm thử

### Cách chạy ứng dụng trên Tomcat 10.1 / Tomcat 11
1. Chạy kịch bản `springtool.sql` trong SQL Server Management Studio (SSMS) để tạo database `webst2` và chèn dữ liệu mẫu 12 video.
2. Import project `BaiHocDauTien` vào **Eclipse / Spring Tool Suite (STS) / IntelliJ IDEA** (dạng Maven Project).
3. Chuột phải project -> **Run As** -> **Run on Server** (Tomcat 10.1+ hoặc Tomcat 11). Hoặc chạy file `run.ps1` / `run.bat`.
4. Truy cập trình duyệt kiểm thử các tính năng:
   - **Trang chủ (10 Video mới nhất)**: `http://localhost:8080/BaiHocDauTien/home`
   - **Trang Video (Phân trang 6 sp/trang)**: `http://localhost:8080/BaiHocDauTien/video`
   - **Phát video khi bấm tiêu đề**: Bấm vào bất kỳ tiêu đề video nào trên `/home` hoặc `/video` để phát video.
   - **Quản lý CRUD Video (Admin)**: `http://localhost:8080/BaiHocDauTien/admin/videos`
   - **Quản lý Danh mục (Admin)**: `http://localhost:8080/BaiHocDauTien/admin/categories`
   - **Đăng ký (có OTP qua Email)**: `http://localhost:8080/BaiHocDauTien/register`
   - **Đăng nhập**: `http://localhost:8080/BaiHocDauTien/login`
   - **Quên mật khẩu**: `http://localhost:8080/BaiHocDauTien/forgot-password`

---

## 4. Tài khoản kiểm thử
| Username | Password | Role | Trạng thái | Quyền hạn |
|----------|----------|------|------------|-----------|
| `admin`  | `admin`  | 1    | Đã kích hoạt (`status = 1`) | Quản trị viên (truy cập Category & Video CRUD) |
| `user`   | `1234`   | 5    | Đã kích hoạt (`status = 1`) | Người dùng thường |
