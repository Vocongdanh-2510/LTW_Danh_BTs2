<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${video.title} - Chi Tiết Video | Võ Công Danh</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f8f9fa; color: #212529; }
        
        .navbar { background: #1a2942; color: #fff; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .navbar .brand { font-size: 1.25rem; font-weight: 700; color: #fff; text-decoration: none; }
        .navbar .nav-links { display: flex; align-items: center; gap: 20px; }
        .navbar .nav-links a { color: #e2e8f0; text-decoration: none; font-weight: 500; font-size: 0.95rem; }
        .navbar .nav-links a:hover { color: #38bdf8; }

        .container { max-width: 1260px; margin: 30px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 360px; gap: 30px; }
        @media (max-width: 960px) { .container { grid-template-columns: 1fr; } }

        /* Left Column: Player & Info */
        .main-player-col { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 4px 16px rgba(0,0,0,0.06); }
        
        .player-wrapper { position: relative; width: 100%; max-height: 540px; background: #000; border-radius: 8px; overflow: hidden; display: flex; justify-content: center; align-items: center; }
        .player-wrapper video { width: 100%; max-height: 540px; object-fit: contain; }
        .player-wrapper iframe { width: 100%; height: 500px; border: none; }

        .video-header { margin-top: 20px; }
        .video-title { font-size: 1.65rem; font-weight: 700; color: #0f172a; margin-bottom: 12px; line-height: 1.35; }
        
        .meta-bar { display: flex; justify-content: space-between; align-items: center; padding-bottom: 16px; border-bottom: 1px solid #e2e8f0; margin-bottom: 20px; }
        .author-box { display: flex; align-items: center; gap: 12px; }
        .author-avatar { width: 44px; height: 44px; border-radius: 50%; background: #0284c7; color: #fff; display: flex; justify-content: center; align-items: center; font-weight: 700; font-size: 1.1rem; }
        .author-info h4 { font-size: 1rem; color: #1e293b; margin-bottom: 2px; }
        .author-info span { font-size: 0.8rem; color: #64748b; }

        .stats-box { display: flex; gap: 20px; font-size: 0.95rem; color: #475569; font-weight: 600; }
        .stats-box span { display: flex; align-items: center; gap: 5px; }

        .desc-box { background: #f8fafc; padding: 20px; border-radius: 8px; font-size: 0.95rem; line-height: 1.6; color: #334155; }
        .desc-box h4 { margin-bottom: 8px; color: #0f172a; font-size: 1rem; }

        /* Right Column: Related Videos */
        .related-col { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 4px 16px rgba(0,0,0,0.06); height: fit-content; }
        .related-title { font-size: 1.2rem; font-weight: 700; color: #0f172a; margin-bottom: 18px; padding-bottom: 10px; border-bottom: 2px solid #e2e8f0; }
        
        .related-list { display: flex; flex-direction: column; gap: 16px; }
        .related-item { display: flex; gap: 12px; text-decoration: none; color: inherit; transition: opacity 0.2s; }
        .related-item:hover { opacity: 0.8; }
        
        .related-thumb { width: 120px; height: 75px; border-radius: 6px; overflow: hidden; background: #000; flex-shrink: 0; }
        .related-thumb img { width: 100%; height: 100%; object-fit: cover; }
        
        .related-info { display: flex; flex-direction: column; justify-content: center; }
        .related-item-title { font-size: 0.88rem; font-weight: 700; color: #1e293b; line-height: 1.3; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .related-item-author { font-size: 0.78rem; color: #64748b; margin-bottom: 2px; }
        .related-item-views { font-size: 0.75rem; color: #94a3b8; }

        footer { text-align: center; padding: 30px 20px; color: #64748b; font-size: 0.9rem; margin-top: 60px; border-top: 1px solid #e2e8f0; background: #fff; }
    </style>
</head>
<body>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="${pageContext.request.contextPath}/home" class="brand">🎬 Video Portal | Võ Công Danh</a>
        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home">Trang Chủ</a>
            <a href="${pageContext.request.contextPath}/video">Videos (/video)</a>
            
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
        
        <!-- CỘT TRÁI: VIDEO PLAYER & THÔNG TIN CHI TIẾT (Yêu cầu 4.4) -->
        <div class="main-player-col">
            <div style="margin-bottom: 15px;">
                <a href="${pageContext.request.contextPath}/video" style="color: #64748b; text-decoration: none; font-size: 0.9rem; font-weight: 600;">← Quay lại danh sách video</a>
            </div>

            <div class="player-wrapper">
                <c:choose>
                    <%-- 1. Video YouTube --%>
                    <c:when test="${video.isYoutube()}">
                        <iframe src="${video.getYoutubeEmbedUrl()}" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </c:when>
                    <%-- 2. File Video Upload Multipart (MP4, WebM) --%>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${fn:startsWith(video.url, 'http://') || fn:startsWith(video.url, 'https://')}">
                                <c:set var="vSrc" value="${video.url}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="vSrc" value="${pageContext.request.contextPath}/video/stream?fname=${video.url}" />
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${fn:startsWith(video.poster, 'http://') || fn:startsWith(video.poster, 'https://')}">
                                <c:set var="pPoster" value="${video.poster}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="pPoster" value="${pageContext.request.contextPath}/image?fname=${video.poster}" />
                            </c:otherwise>
                        </c:choose>

                        <video controls autoplay poster="${pPoster}">
                            <source src="${vSrc}" type="video/mp4">
                            Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                        </video>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="video-header">
                <h1 class="video-title">${video.title}</h1>
                
                <div class="meta-bar">
                    <div class="author-box">
                        <div class="author-avatar">
                            ${fn:toUpperCase(fn:substring(video.user != null ? video.user.username : 'A', 0, 1))}
                        </div>
                        <div class="author-info">
                            <h4>${video.user != null ? (video.user.fullname != null ? video.user.fullname : video.user.username) : 'Quản trị viên'}</h4>
                            <span>Người đăng video</span>
                        </div>
                    </div>

                    <div class="stats-box">
                        <span>👁️ ${video.views} lượt xem</span>
                        <c:if test="${not empty video.category}">
                            <span style="background: #e0f2fe; color: #0369a1; padding: 4px 10px; border-radius: 4px; font-size: 0.85rem;">📁 ${video.category.categoryname}</span>
                        </c:if>
                    </div>
                </div>

                <div class="desc-box">
                    <h4>Mô tả nội dung:</h4>
                    <p>${not empty video.description ? video.description : 'Không có mô tả chi tiết cho video này.'}</p>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: VIDEO GỢI Ý / LIÊN QUAN -->
        <div class="related-col">
            <h3 class="related-title">Video liên quan</h3>
            
            <div class="related-list">
                <c:forEach items="${relatedVideos}" var="rel">
                    <c:if test="${rel.videoId != video.videoId}">
                        <a href="${pageContext.request.contextPath}/video/detail?id=${rel.videoId}" class="related-item">
                            <div class="related-thumb">
                                <c:choose>
                                    <c:when test="${rel.poster != null && (fn:startsWith(rel.poster, 'http://') || fn:startsWith(rel.poster, 'https://'))}">
                                        <c:set var="relThumb" value="${rel.poster}" />
                                    </c:when>
                                    <c:when test="${not empty rel.poster}">
                                        <c:set var="relThumb" value="${pageContext.request.contextPath}/image?fname=${rel.poster}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="relThumb" value="https://placehold.co/120x75?text=Video" />
                                    </c:otherwise>
                                </c:choose>
                                <img src="${relThumb}" alt="${rel.title}" onerror="this.src='https://placehold.co/120x75?text=Video'"/>
                            </div>
                            
                            <div class="related-info">
                                <div class="related-item-title">${rel.title}</div>
                                <div class="related-item-author">${rel.user != null ? rel.user.fullname : 'Admin'}</div>
                                <div class="related-item-views">👁️ ${rel.views} views</div>
                            </div>
                        </a>
                    </c:if>
                </c:forEach>
            </div>
        </div>

    </div>

    <footer>
        &copy; 2026 Võ Công Danh - MSSV: 24110010 - Chi tiết và phát Video
    </footer>

</body>
</html>
