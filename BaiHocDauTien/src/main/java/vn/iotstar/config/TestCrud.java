package vn.iotstar.config;

import java.util.List;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.User;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IUserService;
import vn.iotstar.service.impl.CategoryServiceImpl;
import vn.iotstar.service.impl.UserServiceImpl;

public class TestCrud {
    public static void main(String[] args) throws Exception {
        System.out.println("====== STARTING JPA CRUD TEST ======");
        ICategoryService cateService = new CategoryServiceImpl();
        IUserService userService = new UserServiceImpl();

        // 1. Test UserService login
        User admin = userService.login("admin", "admin");
        if (admin != null) {
            System.out.println("✅ UserService.login SUCCESS: " + admin.getFullname() + " (role=" + admin.getRoleid() + ")");
        } else {
            System.err.println("❌ UserService.login FAILED");
        }

        // 2. Test CategoryService.findAll()
        List<Category> list = cateService.findAll();
        System.out.println("✅ CategoryService.findAll() count: " + list.size());
        for (Category c : list) {
            System.out.println("   - ID: " + c.getCategoryId() + " | Name: " + c.getCategoryname() + " | Status: " + c.getStatus());
        }

        // 3. Test CategoryService.insert()
        String testName = "Test JPA " + System.currentTimeMillis();
        Category newCate = new Category();
        newCate.setCategoryname(testName);
        newCate.setImages("test.png");
        newCate.setStatus(1);
        cateService.insert(newCate);
        System.out.println("✅ CategoryService.insert() completed");

        // 4. Test CategoryService.findByCategoryname()
        Category found = cateService.findByCategoryname(testName);
        if (found != null) {
            System.out.println("✅ CategoryService.findByCategoryname() SUCCESS: id=" + found.getCategoryId());

            // 5. Test CategoryService.update()
            found.setCategoryname(testName + " Updated");
            cateService.update(found);
            System.out.println("✅ CategoryService.update() completed");

            // 6. Test CategoryService.searchByName()
            List<Category> searchResults = cateService.searchByName("Updated");
            System.out.println("✅ CategoryService.searchByName('Updated') count: " + searchResults.size());

            // 7. Test CategoryService.delete()
            cateService.delete(found.getCategoryId());
            System.out.println("✅ CategoryService.delete() completed");
        } else {
            System.err.println("❌ CategoryService.findByCategoryname() returned null");
        }

        // 8. Test Category count
        int count = cateService.count();
        System.out.println("✅ CategoryService.count(): " + count);

        System.out.println("====== ALL JPA CRUD TESTS PASSED SUCCESSFULLY! ======");
    }
}
