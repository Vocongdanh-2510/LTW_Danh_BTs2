package vn.iotstar.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.iotstar.utils.constants;

@WebServlet(urlPatterns = { "/image", "/img" })
public class ImageController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fileName = req.getParameter("fname");
        if (fileName == null || fileName.isEmpty()) {
            fileName = req.getParameter("name");
        }
        if (fileName == null || fileName.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 1. Tìm ảnh trong thư mục constants.DIR (C:/upload)
        File file = new File(constants.DIR + File.separator + fileName);

        // 2. Nếu không có, tìm trong thư mục images của ứng dụng web
        if (!file.exists()) {
            String deployImages = req.getServletContext().getRealPath("") 
                                + File.separator + "images" 
                                + File.separator + fileName;
            file = new File(deployImages);
        }

        // 3. Nếu vẫn không có, tìm trong classpath resource
        if (!file.exists()) {
            try {
                String srcImages = getClass().getClassLoader()
                        .getResource("").getPath()
                        .replace("/WEB-INF/classes/", "/images/" + fileName);
                file = new File(srcImages);
            } catch (Exception ignored) {
            }
        }

        if (!file.exists()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Image not found: " + fileName);
            return;
        }

        // Set Content-Type theo đuôi file
        String ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        switch (ext) {
            case "png"  -> resp.setContentType("image/png");
            case "jpg", "jpeg" -> resp.setContentType("image/jpeg");
            case "svg"  -> resp.setContentType("image/svg+xml");
            case "gif"  -> resp.setContentType("image/gif");
            case "webp" -> resp.setContentType("image/webp");
            default     -> resp.setContentType("application/octet-stream");
        }

        resp.setContentLengthLong(file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
