<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Videos - Admin Panel</title>
</head>
<body>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2"><i class="fa-solid fa-video text-primary me-2"></i>Quản Lý Videos</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="<c:url value='/admin/video/add'/>" class="btn btn-success btn-sm">
                <i class="fa-solid fa-plus me-1"></i>Thêm Video Mới
            </a>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="text-center" style="width: 50px;">STT</th>
                            <th style="width: 130px;">Poster</th>
                            <th style="width: 100px;">Mã Video</th>
                            <th>Tiêu đề video</th>
                            <th style="width: 140px;">Người đăng</th>
                            <th style="width: 130px;">Danh mục</th>
                            <th class="text-center" style="width: 90px;">Lượt xem</th>
                            <th class="text-center" style="width: 110px;">Trạng thái</th>
                            <th class="text-center" style="width: 180px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${videoList}" var="v" varStatus="STT">
                            <tr>
                                <td class="text-center fw-bold text-muted">${STT.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.poster != null && (fn:startsWith(v.poster, 'http://') || fn:startsWith(v.poster, 'https://'))}">
                                            <c:url value="${v.poster}" var="posterImg"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="/image?fname=${v.poster}" var="posterImg"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${posterImg}" alt="${v.title}" class="img-thumbnail rounded" style="width: 110px; height: 70px; object-fit: cover;" onerror="this.src='https://placehold.co/110x70?text=No+Poster'"/>
                                </td>
                                <td><code>${v.videoId}</code></td>
                                <td class="fw-semibold text-dark">
                                    <a href="<c:url value='/video/detail?id=${v.videoId}'/>" class="text-decoration-none text-dark" target="_blank" title="Xem video">
                                        ${v.title} <i class="fa-solid fa-arrow-up-right-from-square small text-muted"></i>
                                    </a>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">
                                        <i class="fa-solid fa-user me-1"></i>
                                        <c:choose>
                                            <c:when test="${not empty v.user.fullname}">${v.user.fullname}</c:when>
                                            <c:otherwise>${v.user.username}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-secondary">
                                        ${v.category != null ? v.category.categoryname : 'Chưa phân loại'}
                                    </span>
                                </td>
                                <td class="text-center fw-semibold text-muted">
                                    <i class="fa-solid fa-eye me-1 small"></i>${v.views}
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${v.active}">
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                                <i class="fa-solid fa-circle-check me-1"></i>Công khai
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary px-2 py-1">
                                                <i class="fa-solid fa-lock me-1"></i>Ẩn
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a class="btn btn-sm btn-outline-warning text-dark me-1" href="<c:url value='/admin/video/edit?id=${v.videoId}'/>" title="Sửa video">
                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                    </a>
                                    <a class="btn btn-sm btn-outline-danger" href="<c:url value='/admin/video/delete?id=${v.videoId}'/>" onclick="return confirm('Bạn có chắc chắn muốn xóa video này?');" title="Xóa video">
                                        <i class="fa-solid fa-trash-can"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty videoList}">
                            <tr>
                                <td colspan="9" class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-video-slash fs-2 d-block mb-2"></i>
                                    Chưa có video nào trong hệ thống.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
