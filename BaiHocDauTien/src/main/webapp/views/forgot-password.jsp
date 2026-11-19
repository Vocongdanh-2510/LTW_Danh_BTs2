<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu - WebVideo Hub</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4 p-sm-5">
                        <div class="text-center mb-4">
                            <div class="bg-warning bg-opacity-10 text-warning d-inline-flex p-3 rounded-circle mb-3">
                                <i class="fa-solid fa-key fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Quên Mật Khẩu</h3>
                            <p class="text-muted small">Nhập email tài khoản của bạn để nhận mã xác nhận OTP đặt lại mật khẩu.</p>
                        </div>

                        <%-- Alert Thông báo lỗi tổng quát --%>
                        <c:if test="${not empty alert}">
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                                <div>${alert}</div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <%-- Form Quên mật khẩu --%>
                        <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="needs-validation" novalidate>
                            <div class="mb-4">
                                <label for="email" class="form-label fw-semibold">
                                    <i class="fa-solid fa-envelope me-1 text-secondary"></i>Địa chỉ Email đăng ký
                                </label>
                                <input type="email"
                                       class="form-control ${not empty errorEmail ? 'is-invalid' : ''}"
                                       id="email"
                                       name="email"
                                       value="${email}"
                                       placeholder="vd: yourname@gmail.com"
                                       required autofocus>
                                <c:choose>
                                    <c:when test="${not empty errorEmail}">
                                        <div class="invalid-feedback d-block">${errorEmail}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="invalid-feedback">Vui lòng nhập email hợp lệ để nhận mã OTP.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <button type="submit" class="btn btn-warning w-100 py-2 fw-semibold shadow-sm text-dark">
                                <i class="fa-solid fa-paper-plane me-2"></i>Gửi Mã Xác Nhận OTP
                            </button>
                        </form>

                        <div class="text-center mt-4">
                            <a href="${pageContext.request.contextPath}/login" class="text-decoration-none small text-muted">
                                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại trang Đăng nhập
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
