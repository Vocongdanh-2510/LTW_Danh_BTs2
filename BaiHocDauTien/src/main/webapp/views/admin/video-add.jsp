<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Video Mới - Admin | Võ Công Danh</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f4f6f9; color: #333; }
        .form-container { max-width: 680px; margin: 0 auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h2 { color: #2c3e50; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; }
        input[type="text"], select, textarea { width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 4px; box-sizing: border-box; font-family: inherit; }
        input[type="file"] { width: 100%; padding: 8px; border: 1px dashed #ced4da; border-radius: 4px; background: #fafafa; }
        .hint { font-size: 0.8rem; color: #6c757d; margin-top: 4px; }
        .radio-group { display: flex; align-items: center; gap: 15px; margin-top: 5px; }
        .radio-group label { font-weight: normal; margin-bottom: 0; cursor: pointer; }
        .btn-submit { background-color: #28a745; color: white; padding: 10px 22px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #218838; }
        .btn-back { display: inline-block; margin-left: 12px; color: #6c757d; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Thêm Video Mới (Multipart Upload &amp; JPA)</h2>
    <hr style="margin-bottom: 25px;">

    <form action="<c:url value='/admin/video/insert'/>" method="post" enctype="multipart/form-data">
        
        <div class="form-group">
            <label for="videoId">Mã Video (Video ID):</label>
            <input type="text" id="videoId" name="videoId" placeholder="VD: V01, VID01 (để trống sẽ tự sinh)...">
            <div class="hint">Khóa chính (Primary Key) của bảng Videos.</div>
        </div>

        <div class="form-group">
            <label for="title">Tiêu đề video (*):</label>
            <input type="text" id="title" name="title" required placeholder="Nhập tiêu đề video...">
        </div>

        <div class="form-group">
            <label for="categoryId">Danh mục (Category):</label>
            <select id="categoryId" name="categoryId">
                <option value="">-- Chọn danh mục (tùy chọn) --</option>
                <c:forEach items="${cateList}" var="c">
                    <option value="${c.categoryId}">${c.categoryname}</option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="userId">Người đăng (User - Quan hệ 1-n) (*):</label>
            <select id="userId" name="userId" required>
                <c:forEach items="${userList}" var="u">
                    <option value="${u.id}">${u.fullname != null ? u.fullname : u.username} (${u.username} - ID: ${u.id})</option>
                </c:forEach>
            </select>
            <div class="hint">Mối quan hệ 1-n: 1 User sở hữu nhiều Video trong CSDL.</div>
        </div>

        <div class="form-group">
            <label for="poster">Link ảnh Poster (URL):</label>
            <input type="text" id="poster" name="poster" placeholder="https://example.com/poster.jpg">
        </div>

        <div class="form-group">
            <label for="posterFile">Hoặc Upload ảnh Poster (từ máy tính - Multipart):</label>
            <input type="file" id="posterFile" name="posterFile" accept="image/*">
        </div>

        <div class="form-group">
            <label for="url">Link Video (YouTube hoặc MP4 trực tiếp):</label>
            <input type="text" id="url" name="url" placeholder="VD: https://www.youtube.com/watch?v=... hoặc link mp4">
            <div class="hint">Hỗ trợ tự động nhúng YouTube Player hoặc phát file MP4.</div>
        </div>

        <div class="form-group">
            <label for="videoFile">Hoặc Upload File Video MP4 (từ máy tính - Multipart):</label>
            <input type="file" id="videoFile" name="videoFile" accept="video/mp4,video/webm,video/*">
            <div class="hint">Tập tin sẽ được xử lý lưu trữ qua Servlet MultipartConfig theo giáo trình HCMUTE.</div>
        </div>

        <div class="form-group">
            <label for="description">Mô tả video:</label>
            <textarea id="description" name="description" rows="4" placeholder="Nhập mô tả chi tiết nội dung video..."></textarea>
        </div>

        <div class="form-group">
            <label>Trạng thái (Active):</label>
            <div class="radio-group">
                <label>
                    <input type="radio" name="active" value="1" checked> Hoạt động
                </label>
                <label>
                    <input type="radio" name="active" value="0"> Khóa
                </label>
            </div>
        </div>

        <div style="margin-top: 30px;">
            <input type="submit" class="btn-submit" value="Lưu Video">
            <a class="btn-back" href="<c:url value='/admin/videos'/>">← Quay lại danh sách</a>
        </div>
    </form>
</div>
</body>
</html>
