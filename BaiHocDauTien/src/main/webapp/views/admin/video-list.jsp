<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Videos (CRUD) - Admin | Võ Công Danh</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f4f6f9; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        h2 { margin: 0; color: #2c3e50; }
        .btn-add { background-color: #007bff; color: white; padding: 10px 18px; text-decoration: none; border-radius: 5px; font-weight: 600; display: inline-block; transition: 0.2s; }
        .btn-add:hover { background-color: #0056b3; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #dee2e6; padding: 12px; text-align: center; vertical-align: middle; }
        th { background-color: #343a40; color: #fff; font-weight: 600; }
        tr:hover { background-color: #f8f9fa; }
        .video-img { width: 120px; height: 75px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; }
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 13px; font-weight: 600; }
        .badge-active { background-color: #d4edda; color: #155724; }
        .badge-locked { background-color: #f8d7da; color: #721c24; }
        .action-link { padding: 6px 12px; border-radius: 4px; text-decoration: none; font-weight: 500; font-size: 14px; margin: 0 3px; display: inline-block; }
        .link-view { background-color: #17a2b8; color: white; }
        .link-view:hover { background-color: #138496; }
        .link-edit { background-color: #ffc107; color: #212529; }
        .link-edit:hover { background-color: #e0a800; }
        .link-delete { background-color: #dc3545; color: white; }
        .link-delete:hover { background-color: #c82333; }
        .nav-link { margin-right: 15px; color: #555; text-decoration: none; font-weight: 500; }
        .nav-link:hover { color: #007bff; }
    </style>
</head>
<body>
<div class="container">
    <div style="margin-bottom: 15px;">
        <a class="nav-link" href="<c:url value='/home'/>">← Trang chủ (/home)</a>
        <a class="nav-link" href="<c:url value='/video'/>">Xem Videos (/video)</a>
        <a class="nav-link" href="<c:url value='/admin/categories'/>">Quản lý Danh mục</a>
        <a class="nav-link" href="<c:url value='/logout'/>" style="color: #dc3545;">Đăng xuất</a>
    </div>

    <div class="header-bar">
        <h2>Quản Lý Videos (CRUD - JPA 3.0 &amp; Multipart Upload)</h2>
        <a class="btn-add" href="<c:url value='/admin/video/add'/>">+ Thêm Video mới</a>
    </div>
    <hr>
    
    <table>
        <thead>
            <tr>
                <th style="width: 45px;">STT</th>
                <th style="width: 130px;">Poster</th>
                <th style="width: 90px;">Mã Video</th>
                <th>Tiêu đề video</th>
                <th style="width: 130px;">Người đăng</th>
                <th style="width: 120px;">Danh mục</th>
                <th style="width: 80px;">Lượt xem</th>
                <th style="width: 100px;">Trạng thái</th>
                <th style="width: 170px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${videoList}" var="v" varStatus="STT">
                <tr>
                    <td>${STT.index + 1}</td>
                    <td>
                        <c:choose>
                            <c:when test="${v.poster != null && (fn:startsWith(v.poster, 'http://') || fn:startsWith(v.poster, 'https://'))}">
                                <c:set var="vPoster" value="${v.poster}" />
                            </c:when>
                            <c:when test="${not empty v.poster}">
                                <c:set var="vPoster" value="${pageContext.request.contextPath}/image?fname=${v.poster}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="vPoster" value="https://placehold.co/120x75?text=No+Poster" />
                            </c:otherwise>
                        </c:choose>
                        <img class="video-img" src="${vPoster}" alt="${v.title}" onerror="this.src='https://placehold.co/120x75?text=No+Poster'"/>
                    </td>
                    <td><code>${v.videoId}</code></td>
                    <td style="text-align: left; font-weight: 600;">
                        <a href="<c:url value='/video/detail?id=${v.videoId}'/>" target="_blank" style="color: #007bff; text-decoration: none;">
                            ${v.title}
                        </a>
                    </td>
                    <td>
                        ${v.user != null ? (v.user.fullname != null ? v.user.fullname : v.user.username) : 'Admin'}
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty v.category}">
                                <span style="background: #e2e8f0; padding: 3px 8px; border-radius: 4px; font-size: 13px;">${v.category.categoryname}</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #999;">—</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><strong>${v.views}</strong></td>
                    <td>
                        <c:if test="${v.active}">
                            <span class="badge badge-active">Hoạt động</span>
                        </c:if>
                        <c:if test="${!v.active}">
                            <span class="badge badge-locked">Khóa</span>
                        </c:if>
                    </td>
                    <td>
                        <a class="action-link link-view" href="<c:url value='/video/detail?id=${v.videoId}'/>" target="_blank">Xem</a>
                        <a class="action-link link-edit" href="<c:url value='/admin/video/edit?id=${v.videoId}'/>">Sửa</a>
                        <a class="action-link link-delete" href="<c:url value='/admin/video/delete?id=${v.videoId}'/>" onclick="return confirm('Bạn có chắc chắn muốn xóa video này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty videoList}">
                <tr>
                    <td colspan="9" style="padding: 25px; color: #888;">Chưa có video nào. Nhấn "+ Thêm Video mới" để bắt đầu!</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
