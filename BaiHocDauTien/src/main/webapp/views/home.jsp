<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang Chủ - Video Portal | Võ Công Danh (24110010)</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; color: #212529; }
        
        /* Navbar */
        .navbar { background: #1a2942; color: #fff; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .navbar .brand { font-size: 1.25rem; font-weight: 700; color: #fff; text-decoration: none; letter-spacing: 0.5px; }
        .navbar .nav-links { display: flex; align-items: center; gap: 20px; }
        .navbar .nav-links a { color: #e2e8f0; text-decoration: none; font-weight: 500; font-size: 0.95rem; transition: color 0.2s; }
        .navbar .nav-links a:hover, .navbar .nav-links a.active { color: #38bdf8; }
        .navbar .btn-auth { background: #38bdf8; color: #0f172a !important; padding: 7px 16px; border-radius: 6px; font-weight: 600 !important; }
        .navbar .btn-auth:hover { background: #7dd3fc; }

        .container { max-width: 1200px; margin: 30px auto; padding: 0 20px; }

        /* Video Player Section if playing */
        .player-box { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 40px; }
        .player-wrapper { position: relative; width: 100%; max-height: 540px; background: #000; border-radius: 8px; overflow: hidden; display: flex; justify-content: center; align-items: center; }
        .player-wrapper video { width: 100%; max-height: 540px; object-fit: contain; }
        .player-wrapper iframe { width: 100%; height: 500px; border: none; }
        .player-info { margin-top: 20px; }
        .player-title { font-size: 1.6rem; font-weight: 700; color: #1e293b; margin-bottom: 10px; }
        .player-meta { display: flex; align-items: center; gap: 20px; color: #64748b; font-size: 0.9rem; margin-bottom: 15px; }
        .player-desc { font-size: 0.95rem; line-height: 1.6; color: #475569; background: #f8fafc; padding: 15px; border-radius: 6px; }

        /* Section Heading */
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 10px; border-bottom: 2px solid #e2e8f0; }
        .section-title { font-size: 1.5rem; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
        .section-link { color: #0284c7; text-decoration: none; font-weight: 600; font-size: 0.95rem; }
        .section-link:hover { text-decoration: underline; }

        /* Video Grid (10 Videos) */
        .video-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; }
        .video-card { background: #fff; border-radius: 10px; overflow: hidden; box-shadow: 0 3px 12px rgba(0,0,0,0.06); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
        .video-card:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
        
        .thumb-wrapper { position: relative; width: 100%; padding-top: 56.25%; background: #000; overflow: hidden; }
        .thumb-wrapper img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; }
        .play-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.25); display: flex; justify-content: center; align-items: center; opacity: 0; transition: opacity 0.2s; }
        .video-card:hover .play-overlay { opacity: 1; }
        .play-btn-circle { width: 48px; height: 48px; background: rgba(239, 68, 68, 0.9); border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-size: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.3); }

        .video-body { padding: 15px; display: flex; flex-direction: column; flex: 1; }
        .video-title-link { font-size: 1rem; font-weight: 700; color: #1e293b; text-decoration: none; line-height: 1.4; margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; transition: color 0.2s; }
        .video-title-link:hover { color: #0284c7; }
        .video-author { font-size: 0.85rem; color: #64748b; margin-bottom: 6px; display: flex; align-items: center; gap: 6px; }
        .video-stats { margin-top: auto; font-size: 0.8rem; color: #94a3b8; display: flex; justify-content: space-between; align-items: center; padding-top: 8px; border-top: 1px solid #f1f5f9; }
        .badge-cat { background: #e0f2fe; color: #0369a1; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: 600; }

        footer { text-align: center; padding: 30px 20px; color: #64748b; font-size: 0.9rem; margin-top: 60px; border-top: 1px solid #e2e8f0; background: #fff; }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/home" class="brand">🎬 Video Portal | Võ Công Danh</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="active">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/video">Videos (/video)</a>
            
            <c:choose>
                <c:when test="${not empty sessionScope.account}">
                    <%-- Nếu là Admin (roleid = 1) hoặc Manager (roleid = 2) thì hiện menu quản trị --%>
                    <c:if test="${sessionScope.account.roleid == 1 || sessionScope.account.roleid == 2}">
                        <a href="${pageContext.request.contextPath}/admin/videos">QL Video (Admin)</a>
                        <a href="${pageContext.request.contextPath}/admin/categories">QL Danh Mục</a>
                    </c:if>

                    <%-- Nếu là User thường (roleid = 5) --%>
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
                    <a href="${pageContext.request.contextPath}/login" class="btn-auth">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <div class="container">

        <!-- YÊU CẦU 4.4: PHÁT VIDEO KHI BẤM CHUỘT VÀO TIÊU ĐỀ TRÊN TRANG CHỦ -->
        <c:if test="${not empty playingVideo}">
            <section class="player-box">
                <div style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;">
                    <span style="background: #ef4444; color: #fff; font-size: 0.75rem; font-weight: 700; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">Đang phát</span>
                    <a href="${pageContext.request.contextPath}/home" style="color: #64748b; text-decoration: none; font-size: 0.9rem;">✕ Đóng player</a>
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

        <!-- YÊU CẦU 4.2: HIỂN THỊ 10 VIDEO MỚI NHẤT LÊN TRANG CHỦ -->
        <div class="section-header">
            <h2 class="section-title">🔥 10 Video Mới Nhất</h2>
            <a href="${pageContext.request.contextPath}/video" class="section-link">Xem tất cả video (${top10Videos.size()}) →</a>
        </div>

        <div class="video-grid">
            <c:forEach items="${top10Videos}" var="v" varStatus="loop">
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
                        
                        <a href="${pageContext.request.contextPath}/home?id=${v.videoId}">
                            <img src="${thumbSrc}" alt="${v.title}" onerror="this.src='https://placehold.co/600x400?text=No+Poster'"/>
                            <div class="play-overlay">
                                <div class="play-btn-circle">▶</div>
                            </div>
                        </a>
                    </div>

                    <%-- Video Details --%>
                    <div class="video-body">
                        <%-- YÊU CẦU 4.4: Bấm chuột vào tiêu đề của video để play trên trang chủ --%>
                        <a href="${pageContext.request.contextPath}/home?id=${v.videoId}" class="video-title-link" title="${v.title}">
                            ${v.title}
                        </a>
                        
                        <div class="video-author">
                            <span>👤</span>
                            <span>${v.user != null ? (v.user.fullname != null ? v.user.fullname : v.user.username) : 'Admin'}</span>
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

            <c:if test="${empty top10Videos}">
                <div style="grid-column: 1 / -1; background: #fff; padding: 40px; text-align: center; border-radius: 8px; color: #64748b;">
                    Chưa có video nào trong hệ thống. Vui lòng vào trang <strong><a href="${pageContext.request.contextPath}/admin/video/add">Quản trị Video</a></strong> để thêm video mới!
                </div>
            </c:if>
        </div>

    </div>

    <footer>
        &copy; 2026 Võ Công Danh - MSSV: 24110010 - Bài Tập Lập Trình Web (JPA 3.0 &amp; Jakarta EE 10)
    </footer>

</body>
</html>
