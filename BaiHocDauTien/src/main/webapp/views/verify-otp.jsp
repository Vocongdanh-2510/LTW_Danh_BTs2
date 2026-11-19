<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực mã OTP - WebVideo Hub</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4 p-sm-5 text-center">
                        <div class="bg-success bg-opacity-10 text-success d-inline-flex p-3 rounded-circle mb-3">
                            <i class="fa-solid fa-envelope-circle-check fs-3"></i>
                        </div>
                        <h3 class="fw-bold text-dark mb-1">Xác Thực Mã OTP</h3>
                        <p class="text-muted small mb-4">
                            Mã OTP 6 số đã được gửi tới email: <br>
                            <strong class="text-primary">${email}</strong>
                        </p>

                        <c:if test="${not empty msg}">
                            <div class="alert alert-info text-start small mb-3">
                                <i class="fa-solid fa-circle-info me-1"></i>${msg}
                            </div>
                        </c:if>

                        <c:if test="${not empty alert}">
                            <div class="alert alert-danger text-start small mb-3">
                                <i class="fa-solid fa-triangle-exclamation me-1"></i>${alert}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/verify-otp" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="email" value="${email}">

                            <div class="mb-4">
                                <label for="otp" class="form-label fw-semibold text-start w-100">
                                    Nhập mã OTP 6 số:
                                </label>
                                <input type="text"
                                       class="form-control text-center fs-3 fw-bold tracking-widest ${not empty errorOtp ? 'is-invalid' : ''}"
                                       id="otp"
                                       name="otp"
                                       placeholder="------"
                                       maxlength="6"
                                       pattern="^[0-9]{6}$"
                                       required autofocus>
                                <div class="invalid-feedback">
                                    Vui lòng nhập chính xác 6 chữ số OTP.
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success w-100 py-2 fw-semibold shadow-sm mb-3">
                                <i class="fa-solid fa-check me-2"></i>Kích Hoạt Tài Khoản
                            </button>
                        </form>

                        <div class="d-flex justify-content-between align-items-center pt-3 border-top small">
                            <a href="${pageContext.request.contextPath}/resend-otp?email=${email}&type=register" class="text-decoration-none text-primary">
                                <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-muted">
                                Quay lại Đăng nhập
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
