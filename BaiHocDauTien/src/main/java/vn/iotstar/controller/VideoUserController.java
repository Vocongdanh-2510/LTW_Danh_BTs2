package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

/**
 * Yêu cầu 4.3: Hiển thị tất cả videos của user và được phân trang 6sp/trang hiển thị trên trang có URL là /video
 * Yêu cầu 4.4: Hiển thị chi tiết và play 01 videos khi bấm chuột vào tiêu đề của video đó trên trang /video
 */
@WebServlet(urlPatterns = { "/video" })
public class VideoUserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final int PAGE_SIZE = 6; // Yêu cầu: 6 sản phẩm (video) trên 1 trang

    private IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Kiểm tra nếu có id video được chọn để xem chi tiết và phát ngay trên trang /video (Yêu cầu 4.4)
        String videoId = req.getParameter("id");
        if (videoId == null || videoId.isEmpty()) {
            videoId = req.getParameter("videoId");
        }

        if (videoId != null && !videoId.trim().isEmpty()) {
            Video playingVideo = videoService.findById(videoId.trim());
            if (playingVideo != null) {
                videoService.incrementViews(videoId.trim());
                req.setAttribute("playingVideo", playingVideo);
            }
        }

        // 2. Xử lý phân trang
        int page = 1;
        String pageStr = req.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageStr.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 3. Xử lý lọc theo User (nếu có userId hoặc user chọn xem video của mình)
        String userIdStr = req.getParameter("userId");
        String myVideos = req.getParameter("my");
        Integer targetUserId = null;

        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                targetUserId = Integer.parseInt(userIdStr.trim());
            } catch (Exception ignored) {
            }
        } else if ("true".equalsIgnoreCase(myVideos)) {
            // Lấy ID user từ session
            HttpSession session = req.getSession(false);
            if (session != null) {
                Object acc = session.getAttribute("account");
                if (acc != null) {
                    if (acc instanceof Model.User) {
                        targetUserId = ((Model.User) acc).getId();
                    } else if (acc instanceof vn.iotstar.entity.User) {
                        targetUserId = ((vn.iotstar.entity.User) acc).getId();
                    }
                }
            }
        }

        List<Video> videoList;
        int totalCount;

        if (targetUserId != null) {
            // Lấy danh sách video của user chỉ định (phân trang 6 sp/trang)
            videoList = videoService.findByUserId(targetUserId, page - 1, PAGE_SIZE);
            totalCount = videoService.countByUserId(targetUserId);
            req.setAttribute("filterUserId", targetUserId);
        } else {
            // Lấy tất cả video của các user trong hệ thống (phân trang 6 sp/trang)
            videoList = videoService.findAll(page - 1, PAGE_SIZE);
            totalCount = videoService.count();
        }

        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        req.setAttribute("videoList", videoList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);
        req.setAttribute("pageSize", PAGE_SIZE);

        req.getRequestDispatcher("/views/video-list.jsp").forward(req, resp);
    }
}
