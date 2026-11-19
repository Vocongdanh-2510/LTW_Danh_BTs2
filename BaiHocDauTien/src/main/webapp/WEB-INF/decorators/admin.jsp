<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/></title>

    <!-- Bootstrap 5.3.3 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome 6 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            font-size: .875rem;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f4f6f9;
        }
        .sidebar {
            position: fixed;
            top: 48px;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 48px 0 0;
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
        }
        .sidebar-sticky {
            height: calc(100vh - 48px);
            overflow-x: hidden;
            overflow-y: auto;
        }
        .sidebar .nav-link {
            font-weight: 500;
            color: #333;
            border-radius: 4px;
            margin: 2px 8px;
        }
        .sidebar .nav-link:hover {
            background-color: #e9ecef;
            color: #0d6efd;
        }
        .main-admin-content {
            flex: 1;
        }
    </style>

    <sitemesh:write property='head'/>
</head>
<body>
    <!-- Admin Header -->
    <%@ include file="/common/admin/header.jsp" %>

    <div class="container-fluid flex-grow-1">
        <div class="row min-vh-100">
            <!-- Admin Sidebar -->
            <%@ include file="/common/admin/sidebar.jsp" %>

            <!-- Admin Body Content injected by Sitemesh Decorator 3 -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4 main-admin-content">
                <sitemesh:write property='body'/>
            </main>
        </div>
    </div>

    <!-- Admin Footer -->
    <%@ include file="/common/admin/footer.jsp" %>

    <!-- Bootstrap 5.3.3 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
