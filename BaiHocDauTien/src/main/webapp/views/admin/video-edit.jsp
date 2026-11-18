<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Video - Admin | Võ Công Danh</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 30px; background-color: #f4f6f9; color: #333; }
        .form-container { max-width: 680px; margin: 0 auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h2 { color: #2c3e50; margin-top: 0; }
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; }
        input[type="text"], input[type="number"], select, textarea { width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 4px; box-sizing: border-box; font-family: inherit; }
        input[type="file"] { width: 100%; padding: 8px; border: 1px dashed #ced4da; border-radius: 4px; background: #fafafa; }
        .hint { font-size: 0.8rem; color: #6c757d; margin-top: 4px; }
        .radio-group { display: flex; align-items: center; gap: 15px; margin-top: 5px; }
        .radio-group label { font-weight: normal; margin-bottom: 0; cursor: pointer; }
        .btn-submit { background-color: #ffc107; color: #212529; padding: 10px 22px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #e0a800; }
        .btn-back { display: inline-block; margin-left: 12px; color: #6c757d; text-decoration: none; }
        .btn-back:hover { text-decoration: underline; }
        .preview-img { max-width: 200px; height: auto; border-radius: 4px; margin-top: 8px; border: 1px solid #ddd; }
    </style>
</head>
<body>
<div class="form-container">
    <h2>Cập Nhật Video: ${video.videoId}</h2>
    <hr style="margin-bottom: 25px;">

    <form action="<c:url value='/admin/video/update'/>" method="post" enctype="multipart/form-data">
        
        <div class="form-group">
            <label for="videoId">Mã Video (Khóa chính - Không đổi):</label>
            <input type="text" id="videoId" name="videoId" value="${video.videoId}" readonly style="background-color: #e9ecef;">
        </div>

        <div class="form-group">
            <label for="title">Tiêu đề video (*):</label>
            <input type="text" id="title" name="title" value="${video.title}" required placeholder="Nhập tiêu đề video...">
        </div>

        <div class="form-group">
            <label for="categoryId">Danh mục (Category):</label>
            <select id="categoryId" name="categoryId">
                <option value="">-- Không phân loại --</option>
                <c:forEach items="${cateList}" var="c">
                    <option value="${c.categoryId}" ${video.category != null && video.category.categoryId == c.categoryId ? 'selected' : ''}>
                        ${c.categoryname}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="userId">Người đăng (User - Quan hệ 1-n) (*):</label>
            <select id="userId" name="userId" required>
                <c:forEach items="${userList}" var="u">
                    <option value="${u.id}" ${video.user != null && video.user.id == u.id ? 'selected' : ''}>
                        ${u.fullname != null ? u.fullname : u.username} (${u.username} - ID: ${u.id})
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="poster">Link ảnh Poster (URL):</label>
            <input type="text" id="poster" name="poster" value="${video.poster}" placeholder="https://example.com/poster.jpg">
            <c:if test="${not empty video.poster}">
                <div style="margin-top: 8px;">
                    <span style="font-size: 0.8rem; color: #666;">Poster hiện tại:</span><br>
                    <c:choose>
                        <c:when test="${fn:startsWith(video.poster, 'http://') || fn:startsWith(video.poster, 'https://')}">
                            <img class="preview-img" src="${video.poster}" alt="Poster" />
                        </c:when>
                        <c:otherwise>
                            <img class="preview-img" src="${pageContext.request.contextPath}/image?fname=${video.poster}" alt="Poster" />
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>

        <div class="form-group">
            <label for="posterFile">Hoặc Đổi ảnh Poster mới (Upload Multipart):</label>
            <input type="file" id="posterFile" name="posterFile" accept="image/*">
            <div class="hint">Để trống nếu muốn giữ nguyên poster hiện tại.</div>
        </div>

        <div class="form-group">
            <label for="url">Link Video (YouTube hoặc MP4 trực tiếp):</label>
            <input type="text" id="url" name="url" value="${video.url}" placeholder="VD: https://www.youtube.com/watch?v=... hoặc file mp4">
            <div class="hint">URL / Tên file video hiện tại: <code>${video.url}</code></div>
        </div>

        <div class="form-group">
            <label for="videoFile">Hoặc Đổi File Video MP4 mới (Upload Multipart):</label>
            <input type="file" id="videoFile" name="videoFile" accept="video/mp4,video/webm,video/*">
            <div class="hint">Để trống nếu muốn giữ nguyên file video hiện tại.</div>
        </div>

        <div class="form-group">
            <label for="views">Lượt xem (Views):</label>
            <input type="number" id="views" name="views" value="${video.views}" min="0">
        </div>

        <div class="form-group">
            <label for="description">Mô tả video:</label>
            <textarea id="description" name="description" rows="4">${video.description}</textarea>
        </div>

        <div class="form-group">
            <label>Trạng thái (Active):</label>
            <div class="radio-group">
                <label>
                    <input type="radio" name="active" value="1" ${video.active ? 'checked' : ''}> Hoạt động
                </label>
                <label>
                    <input type="radio" name="active" value="0" ${!video.active ? 'checked' : ''}> Khóa
                </label>
            </div>
        </div>

        <div style="margin-top: 30px;">
            <input type="submit" class="btn-submit" value="Cập Nhật Video">
            <a class="btn-back" href="<c:url value='/admin/videos'/>">← Quay lại danh sách</a>
        </div>
    </form>
</div>
</body>
</html>
