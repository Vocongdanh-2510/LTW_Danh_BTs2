<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Danh Mục - JPA</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f4f6f9; color: #333; }
        .container { max-width: 1100px; margin: 0 auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .header-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        h2 { margin: 0; color: #2c3e50; }
        .btn-add { background-color: #007bff; color: white; padding: 10px 18px; text-decoration: none; border-radius: 5px; font-weight: 600; display: inline-block; transition: 0.2s; }
        .btn-add:hover { background-color: #0056b3; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #dee2e6; padding: 12px; text-align: center; vertical-align: middle; }
        th { background-color: #343a40; color: #fff; font-weight: 600; }
        tr:hover { background-color: #f8f9fa; }
        .cate-img { width: 160px; height: 110px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; }
        .badge { padding: 5px 10px; border-radius: 12px; font-size: 13px; font-weight: 600; }
        .badge-active { background-color: #d4edda; color: #155724; }
        .badge-locked { background-color: #f8d7da; color: #721c24; }
        .action-link { padding: 6px 12px; border-radius: 4px; text-decoration: none; font-weight: 500; font-size: 14px; margin: 0 3px; display: inline-block; }
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
        <a class="nav-link" href="<c:url value='/admin/dashboard'/>">← Dashboard</a>
        <a class="nav-link" href="<c:url value='/user/home'/>">User Home</a>
        <a class="nav-link" href="<c:url value='/logout'/>" style="color: #dc3545;">Đăng xuất</a>
    </div>

    <div class="header-bar">
        <h2>Quản Lý Danh Mục (JPA 3.0 &amp; Jakarta EE)</h2>
        <a class="btn-add" href="<c:url value="/admin/category/add"/>">+ Thêm Category mới</a>
    </div>
    <hr>
    <table>
        <thead>
            <tr>
                <th style="width: 50px;">STT</th>
                <th style="width: 180px;">Hình ảnh</th>
                <th>Tên danh mục</th>
                <th style="width: 140px;">Trạng thái</th>
                <th style="width: 160px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${listcate}" var="cate" varStatus="STT">
                <tr>
                    <td>${STT.index + 1}</td>
                    <td>
                        <c:choose>
                            <c:when test="${cate.images != null && (fn:startsWith(cate.images, 'http://') || fn:startsWith(cate.images, 'https://'))}">
                                <c:url value="${cate.images}" var="imgUrl"/>
                            </c:when>
                            <c:otherwise>
                                <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                            </c:otherwise>
                        </c:choose>
                        <img class="cate-img" src="${imgUrl}" alt="${cate.categoryname}" onerror="this.src='https://placehold.co/160x110?text=No+Image'"/>
                    </td>
                    <td><strong>${cate.categoryname}</strong></td>
                    <td>
                        <c:if test="${cate.status == 1}">
                            <span class="badge badge-active">Hoạt động</span>
                        </c:if>
                        <c:if test="${cate.status != 1}">
                            <span class="badge badge-locked">Khóa</span>
                        </c:if>
                    </td>
                    <td>
                        <a class="action-link link-edit" href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>">Sửa</a>
                        <a class="action-link link-delete" href="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>" onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty listcate}">
                <tr>
                    <td colspan="5" style="padding: 20px; color: #888;">Chưa có danh mục nào. Hãy nhấn Thêm Category mới!</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
