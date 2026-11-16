package vn.iotstar.config;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Video;
import vn.iotstar.entity.User;

public class Test {
    public static void main(String[] args) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();

        try {
            trans.begin();

            Category cate = new Category();
            cate.setCategoryname("Iphone");
            cate.setImages("abc.jpg");
            cate.setStatus(1);
            enma.persist(cate);

            Video video = enma.find(Video.class, "v01");
            if (video == null) {
                video = new Video();
                video.setVideoId("v01");
                video.setTitle("test");
                video.setCategory(cate);
                enma.persist(video);
            }

            // Khởi tạo tài khoản mẫu cho bài tập 01 dùng JPA
            Long countAdmin = (Long) enma.createQuery("SELECT count(u) FROM User u WHERE u.username = 'admin'").getSingleResult();
            if (countAdmin == 0) {
                User admin = new User();
                admin.setUsername("admin");
                admin.setPassword("admin");
                admin.setFullname("Quản trị viên");
                admin.setEmail("admin@gmail.com");
                admin.setPhone("0123456789");
                admin.setRoleid(1);
                admin.setStatus(1);
                admin.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
                enma.persist(admin);
            }

            Long countUser = (Long) enma.createQuery("SELECT count(u) FROM User u WHERE u.username = 'user'").getSingleResult();
            if (countUser == 0) {
                User normalUser = new User();
                normalUser.setUsername("user");
                normalUser.setPassword("1234");
                normalUser.setFullname("Người dùng");
                normalUser.setEmail("user@gmail.com");
                normalUser.setPhone("0987654321");
                normalUser.setRoleid(5);
                normalUser.setStatus(1);
                normalUser.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
                enma.persist(normalUser);
            }

            trans.commit();
            System.out.println("=================================================");
            System.out.println(">>> JPA Test & Database Initialization SUCCESS! <<<");
            System.out.println("=================================================");
        } catch (Exception e) {
            e.printStackTrace();
            if (trans.isActive()) {
                trans.rollback();
            }
            throw e;
        } finally {
            enma.close();
        }
    }
}
