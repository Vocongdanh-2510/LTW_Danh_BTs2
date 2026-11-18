package vn.iotstar.dao.impl;

import java.util.List;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Query;
import jakarta.persistence.TypedQuery;
import vn.iotstar.config.JpaConfig;
import vn.iotstar.dao.IVideoDao;
import vn.iotstar.entity.Video;

public class VideoDao implements IVideoDao {

    @Override
    public void insert(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.persist(video);
            trans.commit();
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

    @Override
    public void update(Video video) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            enma.merge(video);
            trans.commit();
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

    @Override
    public void delete(String videoId) throws Exception {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Video video = enma.find(Video.class, videoId);
            if (video != null) {
                enma.remove(video);
            } else {
                throw new Exception("Không tìm thấy Video có ID: " + videoId);
            }
            trans.commit();
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

    @Override
    public Video findById(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            return enma.find(Video.class, videoId);
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findAll() {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.createdDate DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findAll(int page, int pagesize) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.createdDate DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setFirstResult(page * pagesize);
            query.setMaxResults(pagesize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public int count() {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT count(v) FROM Video v";
            Query query = enma.createQuery(jpql);
            return ((Long) query.getSingleResult()).intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findTop10Newest() {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.active = true ORDER BY v.createdDate DESC, v.videoId DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setFirstResult(0);
            query.setMaxResults(10);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> findByUserId(int userId, int page, int pagesize) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.user.id = :userId ORDER BY v.createdDate DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("userId", userId);
            query.setFirstResult(page * pagesize);
            query.setMaxResults(pagesize);
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public int countByUserId(int userId) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT count(v) FROM Video v WHERE v.user.id = :userId";
            TypedQuery<Long> query = enma.createQuery(jpql, Long.class);
            query.setParameter("userId", userId);
            return query.getSingleResult().intValue();
        } finally {
            enma.close();
        }
    }

    @Override
    public List<Video> searchByTitle(String keyword) {
        EntityManager enma = JpaConfig.getEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.title LIKE :keyword ORDER BY v.createdDate DESC";
            TypedQuery<Video> query = enma.createQuery(jpql, Video.class);
            query.setParameter("keyword", "%" + keyword + "%");
            return query.getResultList();
        } finally {
            enma.close();
        }
    }

    @Override
    public void incrementViews(String videoId) {
        EntityManager enma = JpaConfig.getEntityManager();
        EntityTransaction trans = enma.getTransaction();
        try {
            trans.begin();
            Video video = enma.find(Video.class, videoId);
            if (video != null) {
                video.setViews(video.getViews() + 1);
                enma.merge(video);
            }
            trans.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (trans.isActive()) {
                trans.rollback();
            }
        } finally {
            enma.close();
        }
    }
}
