<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Võ Công Danh (24110010)</title>
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
            padding: 50px 20px;
        }

        .form-wrap {
            width: 100%;
            max-width: 400px;
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
            margin-bottom: 24px;
            line-height: 1.5;
        }

        .email-badge {
            display: inline-block;
            background: #f1f3f5;
            color: #111;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.88rem;
            margin-bottom: 18px;
        }

        .alert-danger {
            background: #fff5f5;
            border-left: 3px solid #c0392b;
            padding: 12px 14px;
            font-size: 0.88rem;
            color: #c0392b;
            margin-bottom: 18px;
            border-radius: 2px;
        }

        .msg-success {
            background: #f5fff5;
            border-left: 3px solid #27ae60;
            padding: 12px 14px;
            font-size: 0.88rem;
            color: #27ae60;
            margin-bottom: 18px;
            border-radius: 2px;
        }

        .field {
            margin-bottom: 20px;
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

        .field input.otp-input {
            font-size: 1.4rem;
            font-weight: 700;
            letter-spacing: 6px;
            text-align: center;
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
            margin-top: 8px;
            transition: background 0.2s;
        }

        .btn-submit:hover {
            background: #333;
        }

        .resend-box {
            margin-top: 22px;
            text-align: center;
            font-size: 0.85rem;
            color: #888;
        }

        .resend-box a {
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
            <h2>Đặt Lại Mật Khẩu</h2>
            <p class="subtitle">
                Nhập mã OTP (6 số) đã được gửi đến email cùng mật khẩu mới của bạn.
            </p>

            <c:if test="${not empty email}">
                <div class="email-badge">📧 ${email}</div>
            </c:if>
            <c:if test="${empty email and not empty sessionScope.forgot_email}">
                <div class="email-badge">📧 ${sessionScope.forgot_email}</div>
            </c:if>

            <c:if test="${not empty alert}">
                <div class="alert-danger">${alert}</div>
            </c:if>

            <c:if test="${not empty msg}">
                <div class="msg-success">${msg}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/reset-password" method="post">
                <input type="hidden" name="email" value="${not empty email ? email : sessionScope.forgot_email}">

                <div class="field">
                    <label for="otp">Mã xác nhận OTP (6 chữ số)</label>
                    <input type="text" id="otp" name="otp" class="otp-input"
                           maxlength="6" placeholder="______" required autofocus autocomplete="off">
                </div>

                <div class="field">
                    <label for="newPassword">Mật khẩu mới</label>
                    <input type="password" id="newPassword" name="newPassword"
                           placeholder="Nhập mật khẩu mới" required>
                </div>

                <div class="field">
                    <label for="rePassword">Nhập lại mật khẩu mới</label>
                    <input type="password" id="rePassword" name="rePassword"
                           placeholder="Nhập lại mật khẩu mới" required>
                </div>

                <button type="submit" class="btn-submit">Cập nhật mật khẩu</button>
            </form>

            <div class="resend-box">
                Chưa nhận được mã OTP?
                <a href="${pageContext.request.contextPath}/resend-otp?email=${email}&type=forgot">
                    Gửi lại mã OTP
                </a>
            </div>
        </div>
    </main>

    <footer>&copy; 2026 Võ Công Danh - MSSV: 24110010</footer>

</body>

</html>
