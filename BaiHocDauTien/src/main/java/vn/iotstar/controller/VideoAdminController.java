package vn.iotstar.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.entity.Video;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.IVideoService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;
import vn.iotstar.service.impl.VideoServiceImpl;
import vn.iotstar.utils.constants;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 100,      // 100MB cho video
    maxRequestSize = 1024 * 1024 * 200    // 200MB
)
@WebServlet(urlPatterns = {
    "/admin/videos",
    "/admin/video/list",
    "/admin/video/add",
    "/admin/video/insert",
    "/admin/video/edit",
    "/admin/video/update",
    "/admin/video/delete"
})
public class VideoAdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IVideoService videoService = new VideoServiceImpl();
    private ICategoryService cateService = new CategoryServiceImpl();
    private IUserService userService = new UserServiceImpl();

    private boolean checkAdminOrManager(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        Object acc = session.getAttribute("account");
        int roleid = -1;
        if (acc instanceof Model.User) {
            roleid = ((Model.User) acc).getRoleid();
        } else if (acc instanceof vn.iotstar.entity.User) {
            roleid = ((vn.iotstar.entity.User) acc).getRoleid();
        }
        if (roleid != 1 && roleid != 2) {
            resp.sendRedirect(req.getContextPath() + "/home?error=access_denied");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!checkAdminOrManager(req, resp)) {
            return;
        }

        String uri = req.getRequestURI();

        if (uri.contains("/admin/videos") || uri.contains("/admin/video/list")) {
            List<Video> list = videoService.findAll();
            req.setAttribute("videoList", list);
            req.getRequestDispatcher("/views/admin/video-list.jsp").forward(req, resp);

        } else if (uri.contains("/admin/video/add")) {
            List<Category> cateList = cateService.findAll();
            List<User> userList = userService.findAll();
            req.setAttribute("cateList", cateList);
            req.setAttribute("userList", userList);
            req.getRequestDispatcher("/views/admin/video-add.jsp").forward(req, resp);

        } else if (uri.contains("/admin/video/edit")) {
            String id = req.getParameter("id");
            if (id == null || id.isEmpty()) {
                id = req.getParameter("videoId");
            }
            Video video = videoService.findById(id);
            List<Category> cateList = cateService.findAll();
            List<User> userList = userService.findAll();
            req.setAttribute("video", video);
            req.setAttribute("cateList", cateList);
            req.setAttribute("userList", userList);
            req.getRequestDispatcher("/views/admin/video-edit.jsp").forward(req, resp);

        } else if (uri.contains("/admin/video/delete")) {
            String id = req.getParameter("id");
            if (id == null || id.isEmpty()) {
                id = req.getParameter("videoId");
            }
            try {
                videoService.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!checkAdminOrManager(req, resp)) {
            return;
        }

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.contains("/admin/video/insert")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String activeStr = req.getParameter("active");
            boolean active = ("1".equals(activeStr) || "true".equalsIgnoreCase(activeStr) || "on".equalsIgnoreCase(activeStr));
            String posterUrl = req.getParameter("poster");
            String videoUrl = req.getParameter("url");
            String categoryIdStr = req.getParameter("categoryId");
            String userIdStr = req.getParameter("userId");

            if (videoId == null || videoId.trim().isEmpty()) {
                videoId = "VID" + System.currentTimeMillis();
            } else {
                videoId = videoId.trim();
            }

            Video video = new Video();
            video.setVideoId(videoId);
            video.setTitle(title != null ? title.trim() : "");
            video.setDescription(description != null ? description.trim() : "");
            video.setActive(active);
            video.setViews(0);
            video.setCreatedDate(new Date());

            // User upload (1-n)
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                try {
                    int uid = Integer.parseInt(userIdStr.trim());
                    User u = userService.findById(uid);
                    video.setUser(u);
                } catch (Exception ignored) {
                }
            }
            if (video.getUser() == null) {
                // Fallback default admin or first user
                List<User> users = userService.findAll();
                if (!users.isEmpty()) {
                    video.setUser(users.get(0));
                }
            }

            // Category
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int cid = Integer.parseInt(categoryIdStr.trim());
                    Category c = cateService.findById(cid);
                    video.setCategory(c);
                } catch (Exception ignored) {
                }
            }

            // Handle file upload
            String uploadPath = constants.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 1. Poster upload (Part)
            try {
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0 && posterPart.getSubmittedFileName() != null && !posterPart.getSubmittedFileName().isEmpty()) {
                    String filename = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                    int dot = filename.lastIndexOf(".");
                    String ext = (dot != -1) ? filename.substring(dot + 1) : "jpg";
                    String fname = "poster_" + System.currentTimeMillis() + "." + ext;
                    posterPart.write(uploadPath + File.separator + fname);
                    video.setPoster(fname);
                } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                    video.setPoster(posterUrl.trim());
                } else {
                    video.setPoster("https://placehold.co/600x400?text=No+Poster");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 2. Video file upload (Part) or URL
            try {
                Part videoPart = req.getPart("videoFile");
                if (videoPart != null && videoPart.getSize() > 0 && videoPart.getSubmittedFileName() != null && !videoPart.getSubmittedFileName().isEmpty()) {
                    String filename = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                    int dot = filename.lastIndexOf(".");
                    String ext = (dot != -1) ? filename.substring(dot + 1) : "mp4";
                    String fname = "vid_" + System.currentTimeMillis() + "." + ext;
                    videoPart.write(uploadPath + File.separator + fname);
                    video.setUrl(fname);
                } else if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                    video.setUrl(videoUrl.trim());
                } else {
                    video.setUrl("");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            videoService.insert(video);
            resp.sendRedirect(req.getContextPath() + "/admin/videos");

        } else if (uri.contains("/admin/video/update")) {
            String videoId = req.getParameter("videoId");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String activeStr = req.getParameter("active");
            boolean active = ("1".equals(activeStr) || "true".equalsIgnoreCase(activeStr) || "on".equalsIgnoreCase(activeStr));
            String posterUrl = req.getParameter("poster");
            String videoUrl = req.getParameter("url");
            String viewsStr = req.getParameter("views");
            String categoryIdStr = req.getParameter("categoryId");
            String userIdStr = req.getParameter("userId");

            Video video = videoService.findById(videoId);
            if (video == null) {
                video = new Video();
                video.setVideoId(videoId);
                video.setCreatedDate(new Date());
            }

            video.setTitle(title != null ? title.trim() : "");
            video.setDescription(description != null ? description.trim() : "");
            video.setActive(active);
            if (viewsStr != null && !viewsStr.trim().isEmpty()) {
                try {
                    video.setViews(Integer.parseInt(viewsStr.trim()));
                } catch (Exception ignored) {
                }
            }

            // User upload (1-n)
            if (userIdStr != null && !userIdStr.trim().isEmpty()) {
                try {
                    int uid = Integer.parseInt(userIdStr.trim());
                    User u = userService.findById(uid);
                    video.setUser(u);
                } catch (Exception ignored) {
                }
            }

            // Category
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    int cid = Integer.parseInt(categoryIdStr.trim());
                    Category c = cateService.findById(cid);
                    video.setCategory(c);
                } catch (Exception ignored) {
                }
            } else {
                video.setCategory(null);
            }

            String uploadPath = constants.DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 1. Poster upload update
            try {
                Part posterPart = req.getPart("posterFile");
                if (posterPart != null && posterPart.getSize() > 0 && posterPart.getSubmittedFileName() != null && !posterPart.getSubmittedFileName().isEmpty()) {
                    String filename = Paths.get(posterPart.getSubmittedFileName()).getFileName().toString();
                    int dot = filename.lastIndexOf(".");
                    String ext = (dot != -1) ? filename.substring(dot + 1) : "jpg";
                    String fname = "poster_" + System.currentTimeMillis() + "." + ext;
                    posterPart.write(uploadPath + File.separator + fname);
                    video.setPoster(fname);
                } else if (posterUrl != null && !posterUrl.trim().isEmpty()) {
                    video.setPoster(posterUrl.trim());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 2. Video upload update
            try {
                Part videoPart = req.getPart("videoFile");
                if (videoPart != null && videoPart.getSize() > 0 && videoPart.getSubmittedFileName() != null && !videoPart.getSubmittedFileName().isEmpty()) {
                    String filename = Paths.get(videoPart.getSubmittedFileName()).getFileName().toString();
                    int dot = filename.lastIndexOf(".");
                    String ext = (dot != -1) ? filename.substring(dot + 1) : "mp4";
                    String fname = "vid_" + System.currentTimeMillis() + "." + ext;
                    videoPart.write(uploadPath + File.separator + fname);
                    video.setUrl(fname);
                } else if (videoUrl != null && !videoUrl.trim().isEmpty()) {
                    video.setUrl(videoUrl.trim());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            videoService.update(video);
            resp.sendRedirect(req.getContextPath() + "/admin/videos");
        }
    }
}
