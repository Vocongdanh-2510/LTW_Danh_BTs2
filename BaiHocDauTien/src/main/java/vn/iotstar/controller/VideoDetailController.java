package vn.iotstar.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.entity.Video;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.VideoServiceImpl;

/**
 * Yêu cầu 4.4: Hiển thị chi tiết và play 01 video khi bấm chuột vào tiêu đề của video đó
 * URL: /video/detail
 */
@WebServlet(urlPatterns = { "/video/detail" })
public class VideoDetailController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String videoId = req.getParameter("id");
        if (videoId == null || videoId.isEmpty()) {
            videoId = req.getParameter("videoId");
        }

        if (videoId == null || videoId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/video");
            return;
        }

        Video video = videoService.findById(videoId.trim());
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/video");
            return;
        }

        // Tự động tăng lượt xem (view count)
        videoService.incrementViews(videoId.trim());
        video.setViews(video.getViews() + 1);

        // Lấy danh sách video gợi ý
        List<Video> relatedVideos = videoService.findTop10Newest();

        req.setAttribute("video", video);
        req.setAttribute("relatedVideos", relatedVideos);
        req.getRequestDispatcher("/views/video-detail.jsp").forward(req, resp);
    }
}
