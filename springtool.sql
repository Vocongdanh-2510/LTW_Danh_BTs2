CREATE DATABASE ltws3;
GO

USE ltws3;
GO

-- Bảng Category (theo slide CRUD)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Category')
BEGIN
    CREATE TABLE Category (
        cate_id   INT PRIMARY KEY IDENTITY(1,1),
        cate_name NVARCHAR(255) NOT NULL,
        icons     NVARCHAR(255) NULL
    );
END
GO

-- Bảng users (đầy đủ các trường phục vụ OTP kích hoạt, hash password, quên mật khẩu)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'users')
BEGIN
    CREATE TABLE users (
        id          INT PRIMARY KEY IDENTITY(1,1),
        email       NVARCHAR(100),
        username    NVARCHAR(50)  NOT NULL UNIQUE,
        fullname    NVARCHAR(100),
        password    NVARCHAR(100) NOT NULL, -- Mật khẩu được mã hóa SHA-256
        avatar      NVARCHAR(255),           -- ảnh đại diện
        roleid      INT NOT NULL DEFAULT 5,  -- 1=admin, 5=user thường
        phone       NVARCHAR(20),
        createdDate DATE,
        status      INT NOT NULL DEFAULT 0,  -- 0=chưa kích hoạt OTP, 1=đã kích hoạt
        code        NVARCHAR(20) NULL        -- Mã OTP xác thực email / quên mật khẩu
    );
END
ELSE
BEGIN
    -- Thêm cột nếu bảng đã tồn tại từ bài trước
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'status')
        ALTER TABLE users ADD status INT NOT NULL DEFAULT 1;

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('users') AND name = 'code')
        ALTER TABLE users ADD code NVARCHAR(20) NULL;
END
GO

-- Tài khoản mẫu (mật khẩu đã mã hóa băm SHA-256, status = 1 đã kích hoạt)
-- admin: admin -> 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
-- user: 1234   -> 03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4
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
    (N'user@gmail.com',  N'user',  N'Người dùng',    N'03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', NULL, 5, N'0987654321', GETDATE(), 1, NULL);
END
ELSE
BEGIN
    UPDATE users SET status = 1 WHERE username = 'user';
END
GO

-- Dữ liệu Category mẫu
IF NOT EXISTS (SELECT 1 FROM Category)
BEGIN
    INSERT INTO Category (cate_name, icons) VALUES
    (N'Áo Nam',   N'images/ao-nam.png'),
    (N'Áo Nữ',   N'images/ao-nu.png'),
    (N'Quần Nam', N'images/quan-nam.png'),
    (N'Phụ Kiện', N'images/phu-kien.svg');
END
GO

-- Kiểm tra kết quả
SELECT id, email, username, fullname, password, roleid, phone, status, code FROM users;
SELECT * FROM Category;
GO
