<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="<c:url value='/home'/>">
                <i class="fa-solid fa-play-circle text-danger me-2"></i>WebVideo
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
                    aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="mainNavbar">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/home'/>">
                            <i class="fa-solid fa-house me-1"></i>Trang chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/video'/>">
                            <i class="fa-solid fa-film me-1"></i>Danh sách Video
                        </a>
                    </li>

                    <%-- Menu dành cho Quản trị viên (Role 1: Admin, Role 2: Manager) --%>
                    <c:if test="${not empty sessionScope.account && (sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2)}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-warning fw-semibold" href="#" id="adminDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid fa-shield-halved me-1"></i>Khu vực Quản trị
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="adminDropdown">
                                <li><a class="dropdown-item" href="<c:url value='/admin/videos'/>"><i class="fa-solid fa-video me-2"></i>Quản lý Videos</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/admin/categories'/>"><i class="fa-solid fa-folder-tree me-2"></i>Quản lý Danh mục</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="<c:url value='/admin/video/add'/>"><i class="fa-solid fa-plus me-2"></i>Thêm Video mới</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/admin/category/add'/>"><i class="fa-solid fa-plus me-2"></i>Thêm Danh mục mới</a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>

                <ul class="navbar-nav ms-auto align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center text-white" href="#" id="userMenu" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <span class="badge bg-primary rounded-circle p-2 me-2">
                                        <i class="fa-solid fa-user"></i>
                                    </span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.account.fullname}">${sessionScope.account.fullname}</c:when>
                                            <c:when test="${not empty sessionScope.account.username}">${sessionScope.account.username}</c:when>
                                            <c:otherwise>${sessionScope.account.userName}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userMenu">
                                    <li><h6 class="dropdown-header">Tài khoản cá nhân</h6></li>
                                    <li><a class="dropdown-item" href="<c:url value='/profile'/>"><i class="fa-solid fa-id-card me-2 text-primary"></i>Hồ sơ (Profile)</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-danger" href="<c:url value='/logout'/>"><i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="<c:url value='/login'/>">
                                    <i class="fa-solid fa-arrow-right-to-bracket me-1"></i>Đăng nhập
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="btn btn-outline-light btn-sm ms-2" href="<c:url value='/register'/>">
                                    <i class="fa-solid fa-user-plus me-1"></i>Đăng ký
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
</header>
