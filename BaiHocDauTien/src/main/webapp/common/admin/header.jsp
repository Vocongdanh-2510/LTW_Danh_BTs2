<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-2 shadow">
    <a class="navbar-brand col-md-3 col-lg-2 me-0 px-3 fs-6 fw-bold text-warning" href="<c:url value='/admin/videos'/>">
        <i class="fa-solid fa-gauge-high me-2"></i>ADMIN PANEL
    </a>
    <button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-bs-toggle="collapse"
            data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="navbar-nav ms-auto flex-row align-items-center px-3">
        <span class="text-white small me-3 d-none d-sm-inline">
            <i class="fa-solid fa-user-shield text-info me-1"></i>
            Xin chào, <strong>${sessionScope.account.fullname != null ? sessionScope.account.fullname : sessionScope.account.username}</strong>
        </span>
        <a class="btn btn-outline-warning btn-sm me-2" href="<c:url value='/home'/>">
            <i class="fa-solid fa-globe me-1"></i>Xem Website
        </a>
        <a class="btn btn-danger btn-sm" href="<c:url value='/logout'/>">
            <i class="fa-solid fa-right-from-bracket me-1"></i>Thoát
        </a>
    </div>
</header>
