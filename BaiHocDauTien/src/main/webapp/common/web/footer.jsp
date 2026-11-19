<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<footer class="bg-dark text-white pt-4 pb-3 mt-auto">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-5">
                <h5 class="fw-bold text-danger">
                    <i class="fa-solid fa-play-circle me-2"></i>WebVideo Hub
                </h5>
                <p class="text-secondary small mb-2">
                    Hệ thống quản lý Video &amp; Danh mục trực tuyến phát triển trên nền tảng Jakarta EE 10, Hibernate 6, SiteMesh 3 Decorator và Bootstrap 5.
                </p>
                <p class="text-secondary small mb-0">
                    <i class="fa-solid fa-graduation-cap me-1"></i> Sinh viên thực hiện: <strong>Võ Công Danh</strong> (MSSV: <strong>24110010</strong>)
                </p>
            </div>
            <div class="col-md-3">
                <h6 class="fw-semibold text-uppercase text-light mb-3">Liên kết nhanh</h6>
                <ul class="list-unstyled small">
                    <li class="mb-1"><a href="<c:url value='/home'/>" class="text-secondary text-decoration-none hover-white"><i class="fa-solid fa-chevron-right me-1 small"></i>Trang chủ</a></li>
                    <li class="mb-1"><a href="<c:url value='/video'/>" class="text-secondary text-decoration-none hover-white"><i class="fa-solid fa-chevron-right me-1 small"></i>Danh sách Video</a></li>
                    <li class="mb-1"><a href="<c:url value='/login'/>" class="text-secondary text-decoration-none hover-white"><i class="fa-solid fa-chevron-right me-1 small"></i>Đăng nhập</a></li>
                    <li class="mb-1"><a href="<c:url value='/register'/>" class="text-secondary text-decoration-none hover-white"><i class="fa-solid fa-chevron-right me-1 small"></i>Đăng ký tài khoản</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h6 class="fw-semibold text-uppercase text-light mb-3">Công nghệ sử dụng</h6>
                <div class="d-flex flex-wrap gap-2">
                    <span class="badge bg-secondary">SiteMesh Decorator 3</span>
                    <span class="badge bg-primary">Bootstrap 5.3</span>
                    <span class="badge bg-success">Tomcat 11</span>
                    <span class="badge bg-info text-dark">Jakarta EE 10</span>
                    <span class="badge bg-warning text-dark">SQL Server</span>
                </div>
            </div>
        </div>
        <hr class="border-secondary my-3">
        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center text-secondary small">
            <div>&copy; 2026 Võ Công Danh - 24110010. Lập trình Web - UTE.</div>
            <div class="mt-2 mt-sm-0">
                <span class="me-3"><i class="fa-solid fa-code me-1"></i>Sitemesh 3 Decorator</span>
                <span><i class="fa-solid fa-shield-halved me-1"></i>Form Validation</span>
            </div>
        </div>
    </div>
</footer>
