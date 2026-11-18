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
 * Hiển thị 10 video mới nhất lên trang chủ theo yêu cầu 4.2
 * Và hiển thị chi tiết, phát video khi bấm chuột vào tiêu đề theo yêu cầu 4.4
 * URL: /home hoặc /trang-chu
 */
@WebServlet(urlPatterns = { "/home", "/trang-chu" })
public class HomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService videoService = new VideoServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Kiểm tra nếu có id video được bấm chọn để play ngay trên trang chủ (Yêu cầu 4.4)
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

        // 2. Lấy 10 video mới nhất hiển thị lên trang chủ (Yêu cầu 4.2)
        List<Video> top10 = videoService.findTop10Newest();
        req.setAttribute("top10Videos", top10);
        req.setAttribute("videoList", top10);

        // Chuyển tiếp tới giao diện trang chủ
        req.getRequestDispatcher("/views/home.jsp").forward(req, resp);
    }
}
