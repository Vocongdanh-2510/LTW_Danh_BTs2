package vn.iotstar.service;

import java.util.List;
import vn.iotstar.entity.Video;

public interface IVideoService {
    void insert(Video video);
    void update(Video video);
    void delete(String videoId) throws Exception;
    Video findById(String videoId);
    List<Video> findAll();
    List<Video> findAll(int page, int pagesize);
    int count();
    List<Video> findTop10Newest();
    List<Video> findByUserId(int userId, int page, int pagesize);
    int countByUserId(int userId);
    List<Video> searchByTitle(String keyword);
    void incrementViews(String videoId);
}
