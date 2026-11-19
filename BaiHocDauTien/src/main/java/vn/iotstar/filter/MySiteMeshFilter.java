package vn.iotstar.filter;

import jakarta.servlet.annotation.WebFilter;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

/**
 * Filter cấu hình Sitemesh 3 cho Jakarta EE (Tomcat 11)
 * Áp dụng decorator layout đồng nhất cho toàn hệ thống
 */
@WebFilter(filterName = "sitemesh", urlPatterns = "/*")
public class MySiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder
            // Các đường dẫn admin áp dụng layout admin
            .addDecoratorPath("/admin/*", "/decorators/admin.jsp")
            .addDecoratorPath("/admin", "/decorators/admin.jsp")
            
            // Layout chính Bootstrap cho toàn bộ trang public/user
            .addDecoratorPath("/*", "/decorators/web.jsp")
            
            // Loại trừ các tài nguyên tĩnh và servlet tải ảnh
            .addExcludedPath("/images/*")
            .addExcludedPath("/assets/*")
            .addExcludedPath("/image")
            .addExcludedPath("/image/*")
            .addExcludedPath("/css/*")
            .addExcludedPath("/js/*");
    }
}
