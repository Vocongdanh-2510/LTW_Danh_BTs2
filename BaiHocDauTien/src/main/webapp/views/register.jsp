<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản - WebVideo Hub</title>
</head>
<body>
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm border-0 rounded-3">
                    <div class="card-body p-4 p-sm-5">
                        <div class="text-center mb-4">
                            <div class="bg-success bg-opacity-10 text-success d-inline-flex p-3 rounded-circle mb-3">
                                <i class="fa-solid fa-user-plus fs-3"></i>
                            </div>
                            <h3 class="fw-bold text-dark">Tạo Tài Khoản Mới</h3>
                            <p class="text-muted small">Điền các thông tin dưới đây để đăng ký và nhận mã kích hoạt OTP qua Email.</p>
                        </div>

                        <%-- Alert Thông báo lỗi tổng quát --%>
                        <c:if test="${not empty alert}">
                            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-2 fs-5"></i>
                                <div>${alert}</div>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <%-- Form Đăng ký có Bootstrap & Server-side Validation --%>
                        <form action="${pageContext.request.contextPath}/register" method="post" class="needs-validation" novalidate>
                            
                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label for="username" class="form-label fw-semibold">
                                        <i class="fa-solid fa-at me-1 text-secondary"></i>Tên đăng nhập (*)
                                    </label>
                                    <input type="text"
                                           class="form-control ${not empty errorUsername ? 'is-invalid' : ''}"
                                           id="username"
                                           name="username"
                                           value="${username}"
                                           placeholder="vd: nguyenvana"
                                           minlength="3"
                                           maxlength="50"
                                           pattern="^[a-zA-Z0-9_]{3,50}$"
                                           required>
                                    <c:choose>
                                        <c:when test="${not empty errorUsername}">
                                            <div class="invalid-feedback d-block">${errorUsername}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="invalid-feedback">3 - 50 ký tự, chữ cái, số hoặc gạch dưới.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="col-sm-6">
                                    <label for="fullname" class="form-label fw-semibold">
                                        <i class="fa-solid fa-id-badge me-1 text-secondary"></i>Họ và tên (*)
                                    </label>
                                    <input type="text"
                                           class="form-control ${not empty errorFullname ? 'is-invalid' : ''}"
                                           id="fullname"
                                           name="fullname"
                                           value="${fullname}"
                                           placeholder="Nguyễn Văn A"
                                           minlength="2"
                                           required>
                                    <c:choose>
                                        <c:when test="${not empty errorFullname}">
                                            <div class="invalid-feedback d-block">${errorFullname}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="invalid-feedback">Vui lòng nhập họ và tên của bạn.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="row g-3 mb-3">
                                <div class="col-sm-6">
                                    <label for="email" class="form-label fw-semibold">
                                        <i class="fa-solid fa-envelope me-1 text-secondary"></i>Email nhận OTP (*)
                                    </label>
                                    <input type="email"
                                           class="form-control ${not empty errorEmail ? 'is-invalid' : ''}"
                                           id="email"
                                           name="email"
                                           value="${email}"
                                           placeholder="user@example.com"
                                           required>
                                    <c:choose>
                                        <c:when test="${not empty errorEmail}">
                                            <div class="invalid-feedback d-block">${errorEmail}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="invalid-feedback">Email không đúng định dạng.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="col-sm-6">
                                    <label for="phone" class="form-label fw-semibold">
                                        <i class="fa-solid fa-phone me-1 text-secondary"></i>Số điện thoại (*)
                                    </label>
                                    <input type="tel"
                                           class="form-control ${not empty errorPhone ? 'is-invalid' : ''}"
                                           id="phone"
                                           name="phone"
                                           value="${phone}"
                                           placeholder="0912345678"
                                           pattern="^(0|\\+84)(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-9]|9[0-9])[0-9]{7}$"
                                           required>
                                    <c:choose>
                                        <c:when test="${not empty errorPhone}">
                                            <div class="invalid-feedback d-block">${errorPhone}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="invalid-feedback">Số điện thoại 10 số (bắt đầu bằng 03, 05, 07, 08, 09).</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="row g-3 mb-4">
                                <div class="col-sm-6">
                                    <label for="password" class="form-label fw-semibold">
                                        <i class="fa-solid fa-key me-1 text-secondary"></i>Mật khẩu (*)
                                    </label>
                                    <input type="password"
                                           class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                           id="password"
                                           name="password"
                                           placeholder="Tối thiểu 6 ký tự"
                                           minlength="6"
                                           required>
                                    <c:choose>
                                        <c:when test="${not empty errorPassword}">
                                            <div class="invalid-feedback d-block">${errorPassword}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="invalid-feedback">Mật khẩu phải từ 6 ký tự trở lên.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="col-sm-6">
                                    <label for="repassword" class="form-label fw-semibold">
                                        <i class="fa-solid fa-lock me-1 text-secondary"></i>Xác nhận mật khẩu (*)
                                    </label>
                                    <input type="password"
                                           class="form-control ${not empty errorRepassword ? 'is-invalid' : ''}"
                                           id="repassword"
                                           name="repassword"
                                           placeholder="Nhập lại mật khẩu"
                                           minlength="6"
                                           required>
                                    <c:choose>
                                        <c:when test="${not empty errorRepassword}">
                                            <div class="invalid-feedback d-block">${errorRepassword}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="invalid-feedback">Vui lòng xác nhận lại mật khẩu.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-success w-100 py-2 fw-semibold shadow-sm">
                                <i class="fa-solid fa-paper-plane me-2"></i>Đăng Ký &amp; Gửi Mã OTP
                            </button>
                        </form>

                        <div class="text-center mt-4">
                            <span class="text-muted small">Đã có tài khoản?</span>
                            <a href="${pageContext.request.contextPath}/login" class="fw-bold text-decoration-none ms-1">
                                Đăng nhập ngay
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
                    var pass = document.getElementById('password').value;
                    var repass = document.getElementById('repassword').value;
                    if (pass && repass && pass !== repass) {
                        document.getElementById('repassword').setCustomValidity('Mật khẩu không khớp');
                    } else {
                        document.getElementById('repassword').setCustomValidity('');
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
