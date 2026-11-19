<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse shadow-sm">
    <div class="position-sticky pt-3 sidebar-sticky">
        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-2 mb-2 text-muted text-uppercase small">
            <span>Quản Lý Hệ Thống</span>
        </h6>
        <ul class="nav flex-column mb-3">
            <li class="nav-item">
                <a class="nav-link text-dark py-2" href="<c:url value='/admin/videos'/>">
                    <i class="fa-solid fa-video text-primary me-2"></i>Quản lý Videos
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-dark py-2" href="<c:url value='/admin/video/add'/>">
                    <i class="fa-solid fa-square-plus text-success me-2"></i>Thêm Video Mới
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-dark py-2" href="<c:url value='/admin/categories'/>">
                    <i class="fa-solid fa-folder-tree text-warning me-2"></i>Quản lý Danh mục
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-dark py-2" href="<c:url value='/admin/category/add'/>">
                    <i class="fa-solid fa-circle-plus text-info me-2"></i>Thêm Danh mục Mới
                </a>
            </li>
        </ul>

        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-2 text-muted text-uppercase small">
            <span>Người Dùng &amp; Bảo Mật</span>
        </h6>
        <ul class="nav flex-column mb-auto">
            <li class="nav-item">
                <a class="nav-link text-dark py-2" href="<c:url value='/profile'/>">
                    <i class="fa-solid fa-id-card text-secondary me-2"></i>Hồ sơ Admin
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-dark py-2" href="<c:url value='/home'/>">
                    <i class="fa-solid fa-arrow-left me-2"></i>Về Trang Chủ
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link text-danger py-2" href="<c:url value='/logout'/>">
                    <i class="fa-solid fa-arrow-right-from-bracket me-2"></i>Đăng xuất
                </a>
            </li>
        </ul>
    </div>
</nav>
