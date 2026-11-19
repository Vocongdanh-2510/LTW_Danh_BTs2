<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - WebVideo Hub</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4 p-sm-5">
                        <div class="text-center mb-4">
                            <div class="bg-primary bg-opacity-10 text-primary d-inline-flex p-3 rounded-circle mb-3">
                                <i class="fa-solid fa-right-to-bracket fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Đăng Nhập</h3>
                            <p class="text-muted small">Chào mừng bạn trở lại! Nhập thông tin để tiếp tục.</p>
                        </div>

                        <%-- Alert Thông báo lỗi tổng quát --%>
                        <c:if test="${not empty alert}">
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                                <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                                <div>${alert}</div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <%-- Thông báo đăng ký thành công nếu có --%>
                        <c:if test="${not empty sessionScope.registerSuccess}">
                            <div class="alert alert-success d-flex align-items-center" role="alert">
                                <i class="fa-solid fa-circle-check me-2 fs-5"></i>
                                <div>${sessionScope.registerSuccess}</div>
                            </div>
                            <c:remove var="registerSuccess" scope="session" />
                        </c:if>

                        <%-- Form Đăng nhập có Bootstrap & Server-side Validation --%>
                        <form action="${pageContext.request.contextPath}/login" method="post" class="needs-validation" novalidate>
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">
                                    <i class="fa-solid fa-user me-1 text-secondary"></i>Tên đăng nhập
                                </label>
                                <input type="text"
                                       class="form-control ${not empty errorUsername ? 'is-invalid' : ''}"
                                       id="username"
                                       name="username"
                                       value="${username}"
                                       placeholder="Nhập username của bạn"
                                       minlength="3"
                                       required autofocus>
                                <c:choose>
                                    <c:when test="${not empty errorUsername}">
                                        <div class="invalid-feedback d-block">${errorUsername}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="invalid-feedback">Vui lòng nhập tên đăng nhập (tối thiểu 3 ký tự).</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold">
                                    <i class="fa-solid fa-lock me-1 text-secondary"></i>Mật khẩu
                                </label>
                                <input type="password"
                                       class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                       id="password"
                                       name="password"
                                       placeholder="Nhập mật khẩu"
                                       minlength="6"
                                       required>
                                <c:choose>
                                    <c:when test="${not empty errorPassword}">
                                        <div class="invalid-feedback d-block">${errorPassword}</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="invalid-feedback">Mật khẩu phải có tối thiểu 6 ký tự.</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="remember" id="remember">
                                    <label class="form-check-label text-muted small" for="remember">
                                        Ghi nhớ tài khoản
                                    </label>
                                </div>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none small text-primary fw-semibold">
                                    Quên mật khẩu?
                                </a>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm">
                                <i class="fa-solid fa-arrow-right-to-bracket me-2"></i>Đăng Nhập
                            </button>
                        </form>

                        <div class="text-center mt-4">
                            <span class="text-muted small">Chưa có tài khoản?</span>
                            <a href="${pageContext.request.contextPath}/register" class="fw-bold text-decoration-none ms-1">
                                Đăng ký ngay
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Client-side Bootstrap validation script --%>
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
