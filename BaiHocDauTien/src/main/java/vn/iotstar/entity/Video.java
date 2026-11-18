package vn.iotstar.entity;

import java.io.Serializable;
import jakarta.persistence.*;

@Entity
@Table(name = "videos")
@NamedQuery(name = "Video.findAll", query = "SELECT v FROM Video v")
public class Video implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "videoId")
    private String videoId;

    @Column(name = "active")
    private boolean active;

    @Column(name = "description", columnDefinition = "NVARCHAR(MAX) NULL")
    private String description;

    @Column(name = "poster", columnDefinition = "NVARCHAR(500) NULL")
    private String poster;

    @Column(name = "title", columnDefinition = "NVARCHAR(255) NULL")
    private String title;

    @Column(name = "url", columnDefinition = "NVARCHAR(500) NULL")
    private String url;

    @Column(name = "views")
    private int views;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "createdDate")
    private java.util.Date createdDate;

    // bi-directional many-to-one association to User (Quan hệ 1-n: 1 User có nhiều Video)
    @ManyToOne
    @JoinColumn(name = "userId")
    private User user;

    // bi-directional many-to-one association to Category
    @ManyToOne
    @JoinColumn(name = "categoryId")
    private Category category;

    public Video() {
    }

    public String getVideoId() {
        return this.videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId;
    }

    public boolean getActive() {
        return this.active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setActive(int active) {
        this.active = (active == 1);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getViews() {
        return this.views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public java.util.Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(java.util.Date createdDate) {
        this.createdDate = createdDate;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Category getCategory() {
        return this.category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    // Alias categories
    public Category getCategories() {
        return this.category;
    }

    public void setCategories(Category categories) {
        this.category = categories;
    }

    public boolean isYoutube() {
        if (url == null) return false;
        String lower = url.toLowerCase();
        return lower.contains("youtube.com") || lower.contains("youtu.be");
    }

    public String getYoutubeEmbedUrl() {
        if (url == null || url.trim().isEmpty()) return "";
        String trimmed = url.trim();
        if (trimmed.contains("embed/")) return trimmed;
        if (trimmed.contains("watch?v=")) {
            int idx = trimmed.indexOf("watch?v=") + 8;
            int amp = trimmed.indexOf('&', idx);
            String id = (amp != -1) ? trimmed.substring(idx, amp) : trimmed.substring(idx);
            return "https://www.youtube.com/embed/" + id;
        } else if (trimmed.contains("youtu.be/")) {
            int idx = trimmed.indexOf("youtu.be/") + 9;
            int q = trimmed.indexOf('?', idx);
            String id = (q != -1) ? trimmed.substring(idx, q) : trimmed.substring(idx);
            return "https://www.youtube.com/embed/" + id;
        }
        return trimmed;
    }
}
