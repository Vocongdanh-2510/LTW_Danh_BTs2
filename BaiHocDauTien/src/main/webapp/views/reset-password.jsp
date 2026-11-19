<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu - WebVideo Hub</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4 p-sm-5">
                        <div class="text-center mb-4">
                            <div class="bg-primary bg-opacity-10 text-primary d-inline-flex p-3 rounded-circle mb-3">
                                <i class="fa-solid fa-lock-open fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Đặt Lại Mật Khẩu</h3>
                            <p class="text-muted small">Nhập mã OTP vừa nhận qua email và mật khẩu mới của bạn.</p>
                        </div>

                        <%-- Alert Thông báo thành công / gửi lại --%>
                        <c:if test="${not empty msg}">
                            <div class="alert alert-info d-flex align-items-center" role="alert">
                                <i class="fa-solid fa-circle-info me-2 fs-5"></i>
                                <div>${msg}</div>
                            </div>
                        </c:if>

                        <%-- Alert Thông báo lỗi tổng quát --%>
                        <c:if test="${not empty alert}">
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                                <div>${alert}</div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <%-- Form Đặt lại mật khẩu --%>
                        <form action="${pageContext.request.contextPath}/reset-password" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="email" value="${email}">

                            <div class="mb-3">
                                <label for="otp" class="form-label fw-semibold">
                                    <i class="fa-solid fa-shield-halved me-1 text-secondary"></i>Mã OTP (6 chữ số)
                                </label>
                                <input type="text"
                                       class="form-control text-center fs-5 fw-bold letter-spacing-2 ${not empty errorOtp ? 'is-invalid' : ''}"
                                       id="otp"
                                       name="otp"
                                       placeholder="------"
                                       maxlength="6"
                                       pattern="^[0-9]{6}$"
                                       required autofocus>
                                <c:choose>
                                    <c:when test="${not empty errorOtp}">
                                        <div class="invalid-feedback d-block">${errorOtp}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="invalid-feedback">Vui lòng nhập đúng 6 chữ số OTP.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mb-3">
                                <label for="newPassword" class="form-label fw-semibold">
                                    <i class="fa-solid fa-key me-1 text-secondary"></i>Mật khẩu mới
                                </label>
                                <input type="password"
                                       class="form-control ${not empty errorNewPassword ? 'is-invalid' : ''}"
                                       id="newPassword"
                                       name="newPassword"
                                       placeholder="Tối thiểu 6 ký tự"
                                       minlength="6"
                                       required>
                                <c:choose>
                                    <c:when test="${not empty errorNewPassword}">
                                        <div class="invalid-feedback d-block">${errorNewPassword}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="invalid-feedback">Mật khẩu mới phải có tối thiểu 6 ký tự.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mb-4">
                                <label for="rePassword" class="form-label fw-semibold">
                                    <i class="fa-solid fa-lock me-1 text-secondary"></i>Xác nhận mật khẩu mới
                                </label>
                                <input type="password"
                                       class="form-control ${not empty errorRePassword ? 'is-invalid' : ''}"
                                       id="rePassword"
                                       name="rePassword"
                                       placeholder="Nhập lại mật khẩu mới"
                                       minlength="6"
                                       required>
                                <c:choose>
                                    <c:when test="${not empty errorRePassword}">
                                        <div class="invalid-feedback d-block">${errorRePassword}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="invalid-feedback">Mật khẩu xác nhận không khớp.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm">
                                <i class="fa-solid fa-circle-check me-2"></i>Xác Nhận Đổi Mật Khẩu
                            </button>
                        </form>

                        <div class="d-flex justify-content-between align-items-center mt-4 pt-2 border-top">
                            <a href="${pageContext.request.contextPath}/resend-otp?email=${email}&type=forgot" class="text-decoration-none small text-primary">
                                <i class="fa-solid fa-rotate-right me-1"></i>Gửi lại mã OTP
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none small text-muted">
                                Đăng nhập
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Bootstrap validation script --%>
    <script>
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    var pass = document.getElementById('newPassword').value;
                    var repass = document.getElementById('rePassword').value;
                    if (pass && repass && pass !== repass) {
                        document.getElementById('rePassword').setCustomValidity('Mật khẩu không khớp');
                    } else {
                        document.getElementById('rePassword').setCustomValidity('');
                    }

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
