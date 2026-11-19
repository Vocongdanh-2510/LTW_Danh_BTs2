<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Mục - Admin Panel</title>
</head>
<body>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2"><i class="fa-solid fa-folder-tree text-warning me-2"></i>Quản Lý Danh Mục</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="<c:url value='/admin/category/add'/>" class="btn btn-primary btn-sm">
                <i class="fa-solid fa-plus me-1"></i>Thêm Danh Mục Mới
            </a>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover table-striped align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th class="text-center" style="width: 60px;">STT</th>
                            <th style="width: 150px;">Hình ảnh</th>
                            <th>Tên danh mục</th>
                            <th class="text-center" style="width: 140px;">Trạng thái</th>
                            <th class="text-center" style="width: 180px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${listcate}" var="cate" varStatus="STT">
                            <tr>
                                <td class="text-center fw-bold text-muted">${STT.index + 1}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cate.images != null && (fn:startsWith(cate.images, 'http://') || fn:startsWith(cate.images, 'https://'))}">
                                            <c:url value="${cate.images}" var="imgUrl"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <img src="${imgUrl}" alt="${cate.categoryname}" class="img-thumbnail rounded" style="width: 110px; height: 70px; object-fit: cover;" onerror="this.src='https://placehold.co/110x70?text=No+Image'"/>
                                </td>
                                <td class="fw-semibold text-dark fs-6">${cate.categoryname}</td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${cate.status == 1}">
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-2 py-1">
                                                <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2 py-1">
                                                <i class="fa-solid fa-lock me-1"></i>Khóa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-center">
                                    <a class="btn btn-sm btn-outline-warning text-dark me-1" href="<c:url value='/admin/category/edit?id=${cate.categoryId}'/>" title="Chỉnh sửa">
                                        <i class="fa-solid fa-pen-to-square"></i> Sửa
                                    </a>
                                    <a class="btn btn-sm btn-outline-danger" href="<c:url value='/admin/category/delete?id=${cate.categoryId}'/>" onclick="return confirm('Bạn có chắc muốn xóa danh mục này?');" title="Xóa">
                                        <i class="fa-solid fa-trash-can"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty listcate}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">
                                    <i class="fa-regular fa-folder-open fs-2 d-block mb-2"></i>
                                    Chưa có danh mục nào trong hệ thống.
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
