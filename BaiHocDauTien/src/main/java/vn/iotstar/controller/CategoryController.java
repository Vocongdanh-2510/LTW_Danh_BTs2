package vn.iotstar.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.utils.constants;

@MultipartConfig()
@WebServlet(urlPatterns = { "/admin/categories", "/admin/category/add", "/admin/category/insert",
        "/admin/category/edit", "/admin/category/update", "/admin/category/delete", "/admin/category/list" })
public class CategoryController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    public ICategoryService cateService = new CategoryServiceImpl();

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
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdminOrManager(req, resp)) {
            return;
        }
        String url = req.getRequestURI();
        if (url.contains("/admin/categories") || url.contains("/admin/category/list")) {
            List<Category> list = cateService.findAll();
            req.setAttribute("listcate", list);
            req.setAttribute("cateList", list);
            req.getRequestDispatcher("/views/admin/category-list.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/add")) {
            req.getRequestDispatcher("/views/admin/category-add.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            Category category = cateService.findById(id);
            req.setAttribute("cate", category);
            req.getRequestDispatcher("/views/admin/category-edit.jsp").forward(req, resp);
        } else if (url.contains("/admin/category/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            try {
                cateService.delete(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            // chuyển trang
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!checkAdminOrManager(req, resp)) {
            return;
        }
        String url = req.getRequestURI();
        if (url.contains("/admin/category/insert")) {
            // lấy dữ liệu từ form
            String categoryname = req.getParameter("categoryname");
            String statusStr = req.getParameter("status");
            int status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : 1;
            String images = req.getParameter("images");

            // đưa dữ liệu vào model
            Category category = new Category();
            category.setCategoryname(categoryname);
            category.setStatus(status);

            String fname = "";
            String uploadPath = constants.DIR; // upload vào thư mục bất kỳ
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = (index != -1) ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages("avatar.png");
                }
            } catch (FileNotFoundException fne) {
                fne.printStackTrace();
            }

            // đưa model vào phương thức insert
            cateService.insert(category);

            // chuyển trang
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        } else if (url.contains("/admin/category/update")) {
            // lấy dữ liệu từ form
            int categoryid = Integer.parseInt(req.getParameter("categoryid"));
            String categoryname = req.getParameter("categoryname");
            String statusStr = req.getParameter("status");
            int status = (statusStr != null && !statusStr.isEmpty()) ? Integer.parseInt(statusStr) : 1;
            String images = req.getParameter("images");

            // đưa dữ liệu vào model
            Category category = cateService.findById(categoryid);
            if (category == null) {
                category = new Category();
                category.setCategoryId(categoryid);
            }
            String fileold = category.getImages();
            category.setCategoryname(categoryname);
            category.setStatus(status);

            String fname = "";
            String uploadPath = constants.DIR; // upload vào thư mục bất kỳ
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try {
                Part part = req.getPart("images1");
                if (part != null && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    // xóa file cũ trên thư mục
                    if (fileold != null && !fileold.startsWith("http")) {
                        deleteFile(uploadPath + File.separator + fileold);
                    }
                    String filename = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                    int index = filename.lastIndexOf(".");
                    String ext = (index != -1) ? filename.substring(index + 1) : "png";
                    fname = System.currentTimeMillis() + "." + ext;
                    part.write(uploadPath + File.separator + fname);
                    category.setImages(fname);
                } else if (images != null && !images.trim().isEmpty()) {
                    category.setImages(images.trim());
                } else {
                    category.setImages(fileold != null ? fileold : "avatar.png");
                }
            } catch (FileNotFoundException fne) {
                fne.printStackTrace();
            }

            // đưa model vào phương thức update
            cateService.update(category);

            // chuyển trang
            resp.sendRedirect(req.getContextPath() + "/admin/categories");
        }
    }

    public static void deleteFile(String filePath) throws IOException {
        Path path = Paths.get(filePath);
        if (Files.exists(path)) {
            Files.delete(path);
        }
    }
}
