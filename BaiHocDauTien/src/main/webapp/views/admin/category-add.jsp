<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Danh Mục - JPA</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f4f6f9; color: #333; }
        .form-container { max-width: 600px; margin: 0 auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h2 { color: #2c3e50; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; }
        input[type="text"], input[type="file"] { width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 4px; box-sizing: border-box; }
        .radio-group { display: flex; align-items: center; gap: 15px; margin-top: 5px; }
        .radio-group label { font-weight: normal; margin-bottom: 0; cursor: pointer; }
        .btn-submit { background-color: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #218838; }
        .btn-back { display: inline-block; margin-left: 10px; color: #6c757d; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Thêm Danh Mục Mới (JPA)</h2>
    <hr style="margin-bottom: 25px;">
    <form action="<c:url value="/admin/category/insert"/>" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="categoryname">Category name:</label>
            <input type="text" id="categoryname" name="categoryname" required placeholder="Nhập tên danh mục...">
        </div>

        <div class="form-group">
            <label for="images">Link images (URL):</label>
            <input type="text" id="images" name="images" placeholder="https://example.com/image.jpg">
        </div>

        <div class="form-group">
            <label for="images1">Upload images (từ máy tính):</label>
            <input type="file" id="images1" name="images1" accept="image/*">
        </div>

        <div class="form-group">
            <label>Status:</label>
            <div class="radio-group">
                <label>
                    <input type="radio" id="ston" name="status" value="1" checked> Hoạt động
                </label>
                <label>
                    <input type="radio" id="stoff" name="status" value="0"> Khóa
                </label>
            </div>
        </div>

        <div style="margin-top: 25px;">
            <input type="submit" class="btn-submit" value="Insert">
            <a class="btn-back" href="<c:url value="/admin/categories"/>">← Quay lại danh sách</a>
        </div>
    </form>
</div>
</body>
</html>
