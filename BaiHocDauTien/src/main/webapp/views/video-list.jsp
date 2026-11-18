<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Video (/video) - Phân Trang 6 Video/Trang | Võ Công Danh</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; color: #212529; }
        
        .navbar { background: #1a2942; color: #fff; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .navbar .brand { font-size: 1.25rem; font-weight: 700; color: #fff; text-decoration: none; }
        .navbar .nav-links { display: flex; align-items: center; gap: 20px; }
        .navbar .nav-links a { color: #e2e8f0; text-decoration: none; font-weight: 500; font-size: 0.95rem; }
        .navbar .nav-links a:hover, .navbar .nav-links a.active { color: #38bdf8; }
        
        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }

        /* Video Player Section if playing */
        .player-box { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 40px; }
        .player-wrapper { position: relative; width: 100%; max-height: 520px; background: #000; border-radius: 8px; overflow: hidden; display: flex; justify-content: center; align-items: center; }
        .player-wrapper video { width: 100%; max-height: 520px; object-fit: contain; }
        .player-wrapper iframe { width: 100%; height: 480px; border: none; }
        .player-info { margin-top: 20px; }
        .player-title { font-size: 1.5rem; font-weight: 700; color: #1e293b; margin-bottom: 8px; }
        .player-meta { display: flex; align-items: center; gap: 20px; color: #64748b; font-size: 0.9rem; margin-bottom: 12px; }
        .player-desc { font-size: 0.95rem; line-height: 1.6; color: #475569; background: #f8fafc; padding: 15px; border-radius: 6px; }

        /* Top control bar */
        .control-bar { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 18px 24px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); margin-bottom: 25px; }
        .control-bar h2 { font-size: 1.35rem; color: #0f172a; font-weight: 700; }
        .filters { display: flex; gap: 12px; align-items: center; }
        .filter-btn { padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 0.85rem; font-weight: 600; border: 1px solid #cbd5e1; color: #475569; transition: all 0.2s; }
        .filter-btn.active, .filter-btn:hover { background: #0284c7; color: #fff; border-color: #0284c7; }

        /* 6 Video Cards Grid */
        .video-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        @media (max-width: 900px) { .video-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 600px) { .video-grid { grid-template-columns: 1fr; } }

        .video-card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 3px 12px rgba(0,0,0,0.06); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
        .video-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
        
        .thumb-wrapper { position: relative; width: 100%; padding-top: 56.25%; background: #000; overflow: hidden; }
        .thumb-wrapper img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; }
        .play-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.25); display: flex; justify-content: center; align-items: center; opacity: 0; transition: opacity 0.2s; }
        .video-card:hover .play-overlay { opacity: 1; }
        .play-btn-circle { width: 48px; height: 48px; background: rgba(239, 68, 68, 0.9); border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-size: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }

        .video-body { padding: 18px; display: flex; flex-direction: column; flex: 1; }
        .video-title-link { font-size: 1.05rem; font-weight: 700; color: #1e293b; text-decoration: none; line-height: 1.4; margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; transition: color 0.2s; }
        .video-title-link:hover { color: #0284c7; }
        .video-author { font-size: 0.85rem; color: #64748b; margin-bottom: 10px; display: flex; align-items: center; gap: 6px; }
        .video-stats { margin-top: auto; font-size: 0.85rem; color: #94a3b8; display: flex; justify-content: space-between; align-items: center; padding-top: 10px; border-top: 1px solid #f1f5f9; }
        .badge-cat { background: #e0f2fe; color: #0369a1; padding: 3px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; }

        /* Pagination bar */
        .pagination-container { display: flex; justify-content: space-between; align-items: center; margin-top: 40px; background: #fff; padding: 16px 24px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .pagination-info { font-size: 0.9rem; color: #64748b; }
        .pagination-links { display: flex; gap: 6px; align-items: center; }
        .page-item { padding: 8px 14px; border-radius: 6px; text-decoration: none; font-size: 0.9rem; font-weight: 600; border: 1px solid #cbd5e1; color: #334155; transition: all 0.2s; }
        .page-item:hover { background: #f1f5f9; }
        .page-item.active { background: #0284c7; color: #fff; border-color: #0284c7; }
        .page-item.disabled { color: #cbd5e1; pointer-events: none; border-color: #e2e8f0; }

        footer { text-align: center; padding: 30px 20px; color: #64748b; font-size: 0.9rem; margin-top: 60px; border-top: 1px solid #e2e8f0; background: #fff; }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/home" class="brand">🎬 Video Portal | Võ Công Danh</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/video" class="active">Videos (/video)</a>
            
            <c:choose>
                <c:when test="${not empty sessionScope.account}">
                    <c:if test="${sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2}">
                        <a href="${pageContext.request.contextPath}/admin/videos">QL Video (Admin)</a>
                        <a href="${pageContext.request.contextPath}/admin/categories">QL Danh Mục</a>
                    </c:if>
                    <c:if test="${sessionScope.account.roleid != 1 && sessionScope.account.roleid != 2}">
                        <a href="${pageContext.request.contextPath}/video?my=true">Video Của Tôi</a>
                        <a href="${pageContext.request.contextPath}/user/home">Trang Cá Nhân</a>
                    </c:if>
                    <span style="color: #cbd5e1; font-size: 0.9rem;">
                        Chào, <strong>${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}</strong>
                        <span style="background: ${sessionScope.account.roleid == 1 ? '#ef4444' : (sessionScope.account.roleid == 2 ? '#f59e0b' : '#3b82f6')}; color: #fff; font-size: 0.72rem; padding: 2px 6px; border-radius: 4px; font-weight: 700; text-transform: uppercase;">
                            ${sessionScope.account.roleid == 1 ? 'Admin' : (sessionScope.account.roleid == 2 ? 'Manager' : 'User')}
                        </span>
                    </span>
                    <a href="${pageContext.request.contextPath}/logout" style="color: #f87171;">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" style="background:#38bdf8; color:#0f172a; padding:6px 14px; border-radius:4px; font-weight:600;">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" style="color:#e2e8f0;">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <div class="container">

        <!-- YÊU CẦU 4.4: PHÁT VIDEO KHI BẤM VÀO TIÊU ĐỀ TRÊN TRANG /video -->
        <c:if test="${not empty playingVideo}">
            <section class="player-box">
                <div style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;">
                    <span style="background: #ef4444; color: #fff; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">Đang phát</span>
                    <a href="${pageContext.request.contextPath}/video?page=${currentPage}" style="color: #64748b; text-decoration: none; font-size: 0.9rem;">✕ Đóng player</a>
                </div>

                <div class="player-wrapper">
                    <c:choose>
                        <%-- YouTube Video --%>
                        <c:when test="${playingVideo.isYoutube()}">
                            <iframe src="${playingVideo.getYoutubeEmbedUrl()}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                        </c:when>
                        <%-- File MP4 Upload qua Multipart hoặc đường dẫn video trực tiếp --%>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${fn:startsWith(playingVideo.url, 'http://') || fn:startsWith(playingVideo.url, 'https://')}">
                                    <c:set var="videoSource" value="${playingVideo.url}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="videoSource" value="${pageContext.request.contextPath}/video/stream?fname=${playingVideo.url}" />
                                </c:otherwise>
                            </c:choose>

                            <c:choose>
                                <c:when test="${fn:startsWith(playingVideo.poster, 'http://') || fn:startsWith(playingVideo.poster, 'https://')}">
                                    <c:set var="playerPoster" value="${playingVideo.poster}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="playerPoster" value="${pageContext.request.contextPath}/image?fname=${playingVideo.poster}" />
                                </c:otherwise>
                            </c:choose>

                            <video controls autoplay poster="${playerPoster}">
                                <source src="${videoSource}" type="video/mp4">
                                Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                            </video>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="player-info">
                    <h1 class="player-title">${playingVideo.title}</h1>
                    <div class="player-meta">
                        <span>👁️ <strong>${playingVideo.views}</strong> lượt xem</span>
                        <span>👤 Đăng bởi: <strong>${playingVideo.user != null ? (playingVideo.user.fullname != null ? playingVideo.user.fullname : playingVideo.user.username) : 'Quản trị viên'}</strong></span>
                        <c:if test="${not empty playingVideo.category}">
                            <span class="badge-cat">📁 ${playingVideo.category.categoryname}</span>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/video/detail?id=${playingVideo.videoId}" style="margin-left: auto; color: #0284c7; text-decoration: none; font-weight: 600;">Xem trang chi tiết đầy đủ →</a>
                    </div>
                    <div class="player-desc">
                        <strong>Mô tả:</strong><br>
                        ${not empty playingVideo.description ? playingVideo.description : 'Không có mô tả cho video này.'}
                    </div>
                </div>
            </section>
        </c:if>

        <!-- YÊU CẦU 4.3: HIỂN THỊ TẤT CẢ VIDEOS CỦA USER VÀ PHÂN TRANG 6sp/trang -->
        <div class="control-bar">
            <div>
                <h2>Tất Cả Videos Của User (6 video / trang)</h2>
                <span style="font-size: 0.85rem; color: #64748b;">Tổng cộng <strong>${totalCount}</strong> video được tìm thấy</span>
            </div>
            <div class="filters">
                <a href="${pageContext.request.contextPath}/video" class="filter-btn ${empty filterUserId ? 'active' : ''}">Tất cả video</a>
                <c:if test="${not empty sessionScope.account}">
                    <a href="${pageContext.request.contextPath}/video?my=true" class="filter-btn ${not empty filterUserId ? 'active' : ''}">Video của tôi</a>
                </c:if>
            </div>
        </div>

        <!-- 6 Video Grid -->
        <div class="video-grid">
            <c:forEach items="${videoList}" var="v">
                <div class="video-card">
                    <%-- Poster Thumbnail --%>
                    <div class="thumb-wrapper">
                        <c:choose>
                            <c:when test="${v.poster != null && (fn:startsWith(v.poster, 'http://') || fn:startsWith(v.poster, 'https://'))}">
                                <c:set var="thumbSrc" value="${v.poster}" />
                            </c:when>
                            <c:when test="${not empty v.poster}">
                                <c:set var="thumbSrc" value="${pageContext.request.contextPath}/image?fname=${v.poster}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="thumbSrc" value="https://placehold.co/600x400?text=No+Poster" />
                            </c:otherwise>
                        </c:choose>
                        
                        <a href="${pageContext.request.contextPath}/video?id=${v.videoId}&page=${currentPage}${not empty filterUserId ? '&userId='.concat(filterUserId) : ''}">
                            <img src="${thumbSrc}" alt="${v.title}" onerror="this.src='https://placehold.co/600x400?text=No+Poster'"/>
                            <div class="play-overlay">
                                <div class="play-btn-circle">▶</div>
                            </div>
                        </a>
                    </div>

                    <%-- Video Content --%>
                    <div class="video-body">
                        <%-- YÊU CẦU 4.4: Bấm chuột vào tiêu đề của video để play trên trang /video --%>
                        <a href="${pageContext.request.contextPath}/video?id=${v.videoId}&page=${currentPage}${not empty filterUserId ? '&userId='.concat(filterUserId) : ''}" class="video-title-link" title="${v.title}">
                            ${v.title}
                        </a>

                        <div class="video-author">
                            <span>👤</span>
                            <span><strong>${v.user != null ? (v.user.fullname != null ? v.user.fullname : v.user.username) : 'Admin'}</strong></span>
                        </div>

                        <div class="video-stats">
                            <span>👁️ ${v.views} views</span>
                            <c:if test="${not empty v.category}">
                                <span class="badge-cat">${v.category.categoryname}</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty videoList}">
                <div style="grid-column: 1 / -1; background: #fff; padding: 40px; text-align: center; border-radius: 8px; color: #64748b;">
                    Chưa có video nào trong trang này.
                </div>
            </c:if>
        </div>

        <!-- YÊU CẦU 4.3: THANH PHÂN TRANG (PAGINATION 6 SP/TRANG) -->
        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <div class="pagination-info">
                    Đang xem trang <strong>${currentPage}</strong> trên tổng số <strong>${totalPages}</strong> trang (6 video/trang)
                </div>

                <div class="pagination-links">
                    <%-- Nút Previous --%>
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/video?page=${currentPage - 1}${not empty filterUserId ? '&userId='.concat(filterUserId) : ''}" class="page-item">« Trước</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-item disabled">« Trước</span>
                        </c:otherwise>
                    </c:choose>

                    <%-- Các nút số trang --%>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="page-item active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/video?page=${i}${not empty filterUserId ? '&userId='.concat(filterUserId) : ''}" class="page-item">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Nút Next --%>
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/video?page=${currentPage + 1}${not empty filterUserId ? '&userId='.concat(filterUserId) : ''}" class="page-item">Sau »</a>
                        </c:when>
                        <c:otherwise>
                            <span class="page-item disabled">Sau »</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>

    </div>

    <footer>
        &copy; 2026 Võ Công Danh - MSSV: 24110010 - Phân trang 6 video/trang (/video)
    </footer>

</body>
</html>
