<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Võ Công Danh (24110010)</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #fff;
            color: #111;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            border-bottom: 2px solid #111;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header .logo {
            font-size: 1.1rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
        }

        header a {
            color: #111;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 600;
            opacity: 0.7;
        }

        header a:hover {
            opacity: 1;
        }

        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px 20px;
        }

        .form-wrap {
            width: 100%;
            max-width: 380px;
        }

        .form-wrap h2 {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 8px;
            letter-spacing: -1px;
        }

        .subtitle {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 26px;
            line-height: 1.5;
        }

        .alert-danger {
            background: #fff5f5;
            border-left: 3px solid #c0392b;
            padding: 12px 14px;
            font-size: 0.88rem;
            color: #c0392b;
            margin-bottom: 20px;
            border-radius: 2px;
        }

        .field {
            margin-bottom: 24px;
        }

        .field label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 8px;
            color: #555;
        }

        .field input {
            width: 100%;
            padding: 12px 0;
            border: none;
            border-bottom: 2px solid #ddd;
            font-size: 1rem;
            outline: none;
            background: transparent;
            color: #111;
            transition: border-color 0.2s;
        }

        .field input:focus {
            border-bottom-color: #111;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: #111;
            color: #fff;
            border: none;
            font-size: 0.85rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-submit:hover {
            background: #333;
        }

        .link-row {
            margin-top: 22px;
            text-align: center;
            font-size: 0.85rem;
            color: #888;
        }

        .link-row a {
            color: #111;
            font-weight: 700;
            text-decoration: none;
            border-bottom: 1px solid #111;
        }

        footer {
            border-top: 1px solid #ddd;
            padding: 16px 40px;
            text-align: center;
            font-size: 0.8rem;
            color: #999;
        }
    </style>
</head>

<body>

    <header>
        <span class="logo">Võ Công Danh - 24110010</span>
        <a href="${pageContext.request.contextPath}/login">← Đăng nhập</a>
    </header>

    <main>
        <div class="form-wrap">
            <h2>Quên Mật Khẩu</h2>
            <p class="subtitle">
                Nhập địa chỉ email đăng ký tài khoản của bạn. Hệ thống sẽ gửi mã OTP xác nhận để đặt lại mật khẩu.
            </p>

            <c:if test="${not empty alert}">
                <div class="alert-danger">${alert}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <div class="field">
                    <label for="email">Địa chỉ Email hoặc Tên đăng nhập</label>
                    <input type="text" id="email" name="email" value="${email}"
                           placeholder="Nhập email (vd: admin@gmail.com) hoặc username" required autofocus>
                    <small style="display:block; margin-top: 6px; color: #888; font-size: 0.8rem;">
                        * Mã OTP 6 số sẽ được gửi tới email và hiển thị tại console Server Tomcat.
                    </small>
                </div>

                <button type="submit" class="btn-submit">Gửi mã xác nhận OTP</button>
            </form>

            <div class="link-row">
                Bạn nhớ lại mật khẩu?
                <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
            </div>
        </div>
    </main>

    <footer>&copy; 2026 Võ Công Danh - MSSV: 24110010</footer>

</body>

</html>
