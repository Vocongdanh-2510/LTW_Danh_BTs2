-- =========================================================================================
-- DATABASE SETUP & SCRIPT CHO BÀI TẬP 03 (JPA 3.0 & JAKARTA EE 10)
-- Sinh viên thực hiện: Võ Công Danh - MSSV: 24110010
-- Bổ sung: Phần 4 - Bảng Videos (quan hệ 1-n với Users), CRUD Videos, Top 10 Home, Phân trang 6sp/trang /video
-- =========================================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'webst2')
BEGIN
    CREATE DATABASE webst2;
END
GO

USE webst2;
GO

-- 1. Bảng users (Bảo mật SHA-256, OTP kích hoạt & quên mật khẩu)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id          INT PRIMARY KEY IDENTITY(1,1),
        email       NVARCHAR(100),
        username    NVARCHAR(50)  NOT NULL UNIQUE,
        fullname    NVARCHAR(100),
        password    NVARCHAR(100) NOT NULL, -- SHA-256 Hash
        avatar      NVARCHAR(255),
        roleid      INT NOT NULL DEFAULT 5,  -- 1=admin, 5=user thường
        phone       NVARCHAR(20),
        createdDate DATE,
        status      INT NOT NULL DEFAULT 0,  -- 0=chưa kích hoạt, 1=đã kích hoạt
        code        NVARCHAR(20) NULL        -- Mã OTP
    );
END
ELSE
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'status')
        ALTER TABLE users ADD status INT NOT NULL DEFAULT 1;

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'code')
        ALTER TABLE users ADD code NVARCHAR(20) NULL;
END
GO

-- 2. Bảng categories (JPA Category Entity)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'categories')
BEGIN
    CREATE TABLE categories (
        categoryId   INT PRIMARY KEY IDENTITY(1,1),
        categoryname NVARCHAR(255) NOT NULL,
        images       NVARCHAR(500) NULL,
        status       INT NOT NULL DEFAULT 1
    );
END
GO

-- Bảng Category cũ (nếu có để tương thích)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Category')
BEGIN
    CREATE TABLE Category (
        cate_id   INT PRIMARY KEY IDENTITY(1,1),
        cate_name NVARCHAR(255) NOT NULL,
        icons     NVARCHAR(255) NULL
    );
END
GO

-- 3. BẢNG VIDEOS (YÊU CẦU 4: MỐI LIÊN HỆ 1 - N VỚI BẢNG USERS)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'videos')
BEGIN
    CREATE TABLE videos (
        videoId     VARCHAR(50) PRIMARY KEY,
        title       NVARCHAR(255) NOT NULL,
        poster      NVARCHAR(500) NULL,
        url         NVARCHAR(500) NULL,
        views       INT NOT NULL DEFAULT 0,
        description NVARCHAR(MAX) NULL,
        active      BIT NOT NULL DEFAULT 1,
        createdDate DATETIME NOT NULL DEFAULT GETDATE(),
        userId      INT NOT NULL,
        categoryId  INT NULL,
        CONSTRAINT FK_Videos_Users FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE,
        CONSTRAINT FK_Videos_Categories FOREIGN KEY (categoryId) REFERENCES categories(categoryId) ON DELETE SET NULL
    );
END
ELSE
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('videos') AND name = 'userId')
    BEGIN
        ALTER TABLE videos ADD userId INT NULL;
        ALTER TABLE videos ADD CONSTRAINT FK_Videos_Users FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE;
    END

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('videos') AND name = 'url')
        ALTER TABLE videos ADD url NVARCHAR(500) NULL;

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('videos') AND name = 'createdDate')
        ALTER TABLE videos ADD createdDate DATETIME NOT NULL DEFAULT GETDATE();
END
GO

-- =========================================================================================
-- DỮ LIỆU MẪU (SEED DATA)
-- =========================================================================================

-- Tài khoản mẫu (Mật khẩu SHA-256)
IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'admin')
BEGIN
    INSERT INTO users (email, username, fullname, password, avatar, roleid, phone, createdDate, status, code)
    VALUES
    (N'admin@gmail.com', N'admin', N'Quản trị viên', N'8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', NULL, 1, N'0123456789', GETDATE(), 1, NULL);
END
ELSE
BEGIN
    UPDATE users SET status = 1 WHERE username = 'admin';
END

IF NOT EXISTS (SELECT 1 FROM users WHERE username = 'user')
BEGIN
    INSERT INTO users (email, username, fullname, password, avatar, roleid, phone, createdDate, status, code)
    VALUES
    (N'user@gmail.com',  N'user',  N'Võ Công Danh',   N'03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', NULL, 5, N'0987654321', GETDATE(), 1, NULL);
END
ELSE
BEGIN
    UPDATE users SET status = 1 WHERE username = 'user';
END
GO

-- Danh mục mẫu
IF NOT EXISTS (SELECT 1 FROM categories)
BEGIN
    INSERT INTO categories (categoryname, images, status) VALUES
    (N'Công Nghệ & Lập Trình', N'https://images.unsplash.com/photo-1518770660439-4636190af475?w=500', 1),
    (N'Âm Nhạc & Giải Trí',   N'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=500', 1),
    (N'Giáo Dục & Bài Giảng',  N'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=500', 1),
    (N'Đời Sống & Du Lịch',    N'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=500', 1);
END
GO

-- CẬP NHẬT HOẶC THÊM 12 VIDEO CHUẨN XEM ĐƯỢC 100%
DECLARE @AdminId INT = (SELECT TOP 1 id FROM users WHERE username = 'admin');
DECLARE @UserId  INT = (SELECT TOP 1 id FROM users WHERE username = 'user');
DECLARE @Cat1    INT = (SELECT TOP 1 categoryId FROM categories WHERE categoryname LIKE N'%Công Nghệ%');
DECLARE @Cat2    INT = (SELECT TOP 1 categoryId FROM categories WHERE categoryname LIKE N'%Âm Nhạc%');
DECLARE @Cat3    INT = (SELECT TOP 1 categoryId FROM categories WHERE categoryname LIKE N'%Giáo Dục%');
DECLARE @Cat4    INT = (SELECT TOP 1 categoryId FROM categories WHERE categoryname LIKE N'%Đời Sống%');

IF @Cat1 IS NULL SET @Cat1 = (SELECT TOP 1 categoryId FROM categories);
IF @Cat2 IS NULL SET @Cat2 = @Cat1;
IF @Cat3 IS NULL SET @Cat3 = @Cat1;
IF @Cat4 IS NULL SET @Cat4 = @Cat1;

-- Xóa dữ liệu video cũ để cập nhật mới đồng bộ
DELETE FROM videos WHERE videoId IN ('VID01','VID02','VID03','VID04','VID05','VID06','VID07','VID08','VID09','VID10','VID11','VID12');

INSERT INTO videos (videoId, title, poster, url, views, description, active, createdDate, userId, categoryId)
VALUES
('VID01', N'Lập Trình Web Java Với Jakarta EE & Hibernate JPA - Bài Giảng Cơ Bản', 
 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800', 
 'https://www.youtube.com/watch?v=aqz-KE-bpKQ', 1850, 
 N'Video hướng dẫn cấu trúc MVC trong Jakarta EE 10, cấu hình kết nối SQL Server và viết CRUD chuyên nghiệp.', 1, DATEADD(minute, -1, GETDATE()), @AdminId, @Cat1),

('VID02', N'Big Buck Bunny - Phim Hoạt Hình 3D Đồ Họa Đỉnh Cao (HTML5 MP4)', 
 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800', 
 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 2460, 
 N'Phim hoạt hình 3D mã nguồn mở tuyệt đẹp của Blender Foundation, phát mượt mà trên thẻ video HTML5.', 1, DATEADD(minute, -2, GETDATE()), @UserId, @Cat2),

('VID03', N'Giới Thiệu Nền Tảng YouTube Developers & Các Dịch Vụ API', 
 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=800', 
 'https://www.youtube.com/watch?v=M7lc1UVf-VE', 1120, 
 N'Tổng quan về kiến trúc YouTube API, kỹ thuật nhúng trình phát đa phương tiện trên website hiện đại.', 1, DATEADD(minute, -3, GETDATE()), @AdminId, @Cat1),

('VID04', N'Elephants Dream - Hành Trình Khoa Học Viễn Tưởng (HTML5 MP4)', 
 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800', 
 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4', 1580, 
 N'Tác phẩm viễn tưởng mở đầu trào lưu phim 3D mã nguồn mở với âm thanh vòm sống động.', 1, DATEADD(minute, -4, GETDATE()), @UserId, @Cat2),

('VID05', N'Me at the zoo - Video Đầu Tiên Trong Lịch Sử Của YouTube', 
 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800', 
 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 3200, 
 N'Khoảnh khắc lịch sử đánh dấu sự ra đời của mạng chia sẻ video lớn nhất hành tinh ngày 23/04/2005.', 1, DATEADD(minute, -5, GETDATE()), @AdminId, @Cat4),

('VID06', N'For Bigger Blazes - Video Đua Xe Thể Thao Tốc Độ (HTML5 MP4)', 
 'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=800', 
 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', 970, 
 N'Trải nghiệm tốc độ đỉnh cao, phục vụ kiểm thử phân trang 6 sản phẩm/trang và phát video đa luồng.', 1, DATEADD(minute, -6, GETDATE()), @UserId, @Cat4),

('VID07', N'Hòa Nhạc Giao Hưởng Bohemian Rhapsody Tuyệt Phẩm', 
 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800', 
 'https://www.youtube.com/watch?v=fJ9rUzIMcZQ', 4500, 
 N'Tác phẩm âm nhạc bất hủ của ban nhạc huyền thoại Queen, chạm mốc hàng tỷ lượt nghe toàn cầu.', 1, DATEADD(minute, -7, GETDATE()), @AdminId, @Cat2),

('VID08', N'Tears of Steel - Phim Viễn Tưởng Kỹ Xảo Điện Ảnh VFX (HTML5 MP4)', 
 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=800', 
 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4', 1340, 
 N'Bộ phim kỹ xảo điện ảnh đỉnh cao bối cảnh tương lai hậu tận thế quay tại thủ đô Amsterdam.', 1, DATEADD(minute, -8, GETDATE()), @UserId, @Cat1),

('VID09', N'Hướng Dẫn Tối Ưu Hóa Giao Diện Web Với CSS Grid & Flexbox', 
 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?w=800', 
 'https://www.youtube.com/watch?v=aqz-KE-bpKQ', 890, 
 N'Bí quyết dàn trang giao diện responsive chuẩn hiện đại, thích ứng hoàn hảo trên mọi kích thước màn hình.', 1, DATEADD(minute, -9, GETDATE()), @AdminId, @Cat3),

('VID10', N'Sintel - Chuyến Phiêu Lưu Hoạt Hình Cảm Động (HTML5 MP4)', 
 'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=800', 
 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4', 2150, 
 N'Câu chuyện cảm động về tình bạn giữa cô gái Sintel dũng cảm và chú rồng con Scales dễ thương.', 1, DATEADD(minute, -10, GETDATE()), @UserId, @Cat2),

('VID11', N'Khám Phá Thiên Nhiên Hoang Dã 4K Siêu Nét', 
 'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800', 
 'https://www.youtube.com/watch?v=jNQXAC9IVRw', 1780, 
 N'Hành trình thưởng ngoạn những phong cảnh thiên nhiên kỳ vĩ cùng hệ sinh thái muôn loài tuyệt đẹp.', 1, DATEADD(minute, -11, GETDATE()), @AdminId, @Cat4),

('VID12', N'For Bigger Escape - Trải Nghiệm Thư Giãn Thiên Nhiên (HTML5 MP4)', 
 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800', 
 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', 1620, 
 N'Khung cảnh thư giãn tuyệt đối giúp nạp lại năng lượng sau những giờ học tập và làm việc căng thẳng.', 1, DATEADD(minute, -12, GETDATE()), @UserId, @Cat4);
GO

-- =========================================================================================
-- KIỂM TRA DỮ LIỆU
-- =========================================================================================
SELECT videoId, title, views, active, userId, categoryId, createdDate FROM videos ORDER BY createdDate DESC;
GO
