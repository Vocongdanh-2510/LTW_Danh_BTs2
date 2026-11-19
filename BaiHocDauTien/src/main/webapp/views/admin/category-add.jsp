<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Danh Mục Mới - Admin Panel</title>
</head>
<body>
    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1 class="h2"><i class="fa-solid fa-folder-plus text-primary me-2"></i>Thêm Danh Mục Mới</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
            <a href="<c:url value='/admin/categories'/>" class="btn btn-outline-secondary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i>Quay lại danh sách
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
                            <i class="fa-solid fa-triangle-exclamation me-2 fs-5"></i>
                            <div>${error}</div>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <form action="<c:url value='/admin/category/insert'/>" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
                        
                        <div class="mb-3">
                            <label for="categoryname" class="form-label fw-semibold">
                                Tên danh mục (Category Name) (*)
                            </label>
                            <input type="text"
                                   class="form-control ${not empty error ? 'is-invalid' : ''}"
                                   id="categoryname"
                                   name="categoryname"
                                   value="${categoryname}"
                                   placeholder="VD: Phim hành động, Khoa học, Hài kịch..."
                                   minlength="2"
                                   maxlength="100"
                                   required autofocus>
                            <div class="invalid-feedback">
                                Tên danh mục bắt buộc từ 2 đến 100 ký tự.
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="images" class="form-label fw-semibold">
                                Đường dẫn hình ảnh (URL tùy chọn)
                            </label>
                            <input type="text" class="form-control" id="images" name="images" placeholder="https://example.com/cover.jpg">
                            <div class="form-text">Nhập URL trực tiếp hoặc upload file từ máy tính bên dưới.</div>
                        </div>

                        <div class="mb-3">
                            <label for="images1" class="form-label fw-semibold">
                                Upload hình ảnh biểu tượng từ máy tính
                            </label>
                            <input type="file" class="form-control" id="images1" name="images1" accept="image/*">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold d-block">Trạng thái (Status)</label>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="ston" name="status" value="1" checked>
                                <label class="form-check-label text-success fw-semibold" for="ston">
                                    <i class="fa-solid fa-circle-check me-1"></i>Hoạt động
                                </label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" id="stoff" name="status" value="0">
                                <label class="form-check-label text-danger fw-semibold" for="stoff">
                                    <i class="fa-solid fa-circle-xmark me-1"></i>Khóa
                                </label>
                            </div>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4 fw-semibold">
                                <i class="fa-solid fa-floppy-disk me-1"></i>Lưu Danh Mục (Insert)
                            </button>
                            <a class="btn btn-light border px-4" href="<c:url value='/admin/categories'/>">
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
