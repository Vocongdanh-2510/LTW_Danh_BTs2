<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Danh Mục - JPA</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f4f6f9; color: #333; }
        .form-container { max-width: 600px; margin: 0 auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h2 { color: #2c3e50; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; }
        input[type="text"], input[type="file"] { width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 4px; box-sizing: border-box; }
        .preview-img { width: 200px; height: 140px; object-fit: cover; border-radius: 6px; border: 1px solid #ddd; margin: 10px 0; }
        .radio-group { display: flex; align-items: center; gap: 15px; margin-top: 5px; }
        .radio-group label { font-weight: normal; margin-bottom: 0; cursor: pointer; }
        .btn-submit { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #0056b3; }
        .btn-back { display: inline-block; margin-left: 10px; color: #6c757d; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Cập Nhật Danh Mục (JPA)</h2>
    <hr style="margin-bottom: 25px;">
    <form action="<c:url value="/admin/category/update"/>" method="post" enctype="multipart/form-data">
        <input type="hidden" name="categoryid" value="${cate.categoryId}">

        <div class="form-group">
            <label for="categoryname">Category name:</label>
            <input type="text" id="categoryname" name="categoryname" value="${cate.categoryname}" required>
        </div>

        <div class="form-group">
            <label for="images">Link images (URL):</label>
            <input type="text" id="images" name="images" value="${cate.images}">
        </div>

        <div class="form-group">
            <label>Hình ảnh hiện tại:</label>
            <c:choose>
                <c:when test="${cate.images != null && (fn:startsWith(cate.images, 'http://') || fn:startsWith(cate.images, 'https://'))}">
                    <c:url value="${cate.images}" var="imgUrl"/>
                </c:when>
                <c:otherwise>
                    <c:url value="/image?fname=${cate.images}" var="imgUrl"/>
                </c:otherwise>
            </c:choose>
            <img class="preview-img" src="${imgUrl}" alt="${cate.categoryname}" onerror="this.src='https://placehold.co/200x140?text=No+Image'"/><br>
        </div>

        <div class="form-group">
            <label for="images1">Upload images mới (nếu muốn thay đổi):</label>
            <input type="file" id="images1" name="images1" accept="image/*">
        </div>

        <div class="form-group">
            <label>Status:</label>
            <div class="radio-group">
                <label>
                    <input type="radio" id="ston" name="status" value="1" ${cate.status == 1 ? 'checked' : ''}> Hoạt động
                </label>
                <label>
                    <input type="radio" id="stoff" name="status" value="0" ${cate.status != 1 ? 'checked' : ''}> Khóa
                </label>
            </div>
        </div>

        <div style="margin-top: 25px;">
            <input type="submit" class="btn-submit" value="Update">
            <a class="btn-back" href="<c:url value="/admin/categories"/>">← Quay lại danh sách</a>
        </div>
    </form>
</div>
</body>
</html>
