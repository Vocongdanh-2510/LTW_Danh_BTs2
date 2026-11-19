<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Video - Admin Panel</title>
</head>
<body>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2"><i class="fa-solid fa-pen-to-square text-warning me-2"></i>Cập Nhật Video: ${video.videoId}</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="<c:url value='/admin/videos'/>" class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-9">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                            <div>${error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="<c:url value='/admin/video/update'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="videoId" class="form-label fw-semibold">
                                    Mã Video (Khóa chính - Không đổi)
                                </label>
                                <input type="text"
                                       class="form-control bg-light"
                                       id="videoId"
                                       name="videoId"
                                       value="${video.videoId}"
                                       readonly>
                            </div>

                            <div class="col-md-6">
                                <label for="title" class="form-label fw-semibold">
                                    Tiêu đề video (*)
                                </label>
                                <input type="text"
                                       class="form-control ${not empty error ? 'is-invalid' : ''}"
                                       id="title"
                                       name="title"
                                       value="${video.title}"
                                       minlength="3"
                                       maxlength="200"
                                       required autofocus>
                                <div class="invalid-feedback">
                                    Tiêu đề video không được để trống (từ 3 đến 200 ký tự).
                                </div>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="categoryId" class="form-label fw-semibold">Danh mục (Category)</label>
                                <select class="form-select" id="categoryId" name="categoryId">
                                    <option value="">-- Không phân loại --</option>
                                    <c:forEach items="${cateList}" var="c">
                                        <option value="${c.categoryId}" ${video.category != null && video.category.categoryId == c.categoryId ? 'selected' : ''}>
                                            ${c.categoryname}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label for="userId" class="form-label fw-semibold">Người đăng (User - Quan hệ 1-n) (*)</label>
                                <select class="form-select" id="userId" name="userId" required>
                                    <c:forEach items="${userList}" var="u">
                                        <option value="${u.id}" ${video.user != null && video.user.id == u.id ? 'selected' : ''}>
                                            ${u.fullname != null ? u.fullname : u.username} (${u.username} - ID: ${u.id})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="views" class="form-label fw-semibold">Lượt xem (Views)</label>
                                <input type="number" class="form-control" id="views" name="views" value="${video.views}" min="0">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold d-block">Trạng thái phát hành</label>
                                <div class="form-check form-check-inline mt-2">
                                    <input class="form-check-input" type="radio" id="activeOn" name="active" value="1" ${video.active ? 'checked' : ''}>
                                    <label class="form-check-label text-success fw-semibold" for="activeOn">
                                        <i class="fa-solid fa-circle-check me-1"></i>Công khai (Active)
                                    </label>
                                </div>
                                <div class="form-check form-check-inline mt-2">
                                    <input class="form-check-input" type="radio" id="activeOff" name="active" value="0" ${!video.active ? 'checked' : ''}>
                                    <label class="form-check-label text-secondary fw-semibold" for="activeOff">
                                        <i class="fa-solid fa-eye-slash me-1"></i>Ẩn (Private)
                                    </label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="description" class="form-label fw-semibold">Mô tả video</label>
                            <textarea class="form-control" id="description" name="description" rows="3">${video.description}</textarea>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="poster" class="form-label fw-semibold">Link ảnh Poster (URL)</label>
                                <input type="text" class="form-control" id="poster" name="poster" value="${video.poster}">
                                
                                <c:if test="${not empty video.poster}">
                                    <div class="mt-2">
                                        <label class="small text-muted d-block">Poster hiện tại:</label>
                                        <c:choose>
                                            <c:when test="${fn:startsWith(video.poster, 'http://') || fn:startsWith(video.poster, 'https://')}">
                                                <img src="${video.poster}" class="img-thumbnail" style="max-height: 100px;" onerror="this.src='https://placehold.co/120x80?text=No+Poster'">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/image?fname=${video.poster}" class="img-thumbnail" style="max-height: 100px;" onerror="this.src='https://placehold.co/120x80?text=No+Poster'">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:if>
                            </div>

                            <div class="col-md-6">
                                <label for="posterFile" class="form-label fw-semibold">Upload file ảnh Poster mới</label>
                                <input type="file" class="form-control" id="posterFile" name="posterFile" accept="image/*">
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-6">
                                <label for="url" class="form-label fw-semibold">Link Video (YouTube hoặc URL)</label>
                                <input type="text" class="form-control" id="url" name="url" value="${video.url}">
                            </div>
                            <div class="col-md-6">
                                <label for="videoFile" class="form-label fw-semibold">Upload file Video mới (mp4, mkv)</label>
                                <input type="file" class="form-control" id="videoFile" name="videoFile" accept="video/*">
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning px-4 fw-semibold text-dark">
                                <i class="fa-solid fa-pen-to-square me-1"></i>Cập Nhật Video (Update)
                            </button>
                            <a class="btn btn-light border px-4" href="<c:url value='/admin/videos'/>">
                                Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        (function () {
            'use strict';
            var forms = document.querySelectorAll('.needs-validation');
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
        })();
    </script>
</body>
</html>
