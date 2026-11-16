package Model;

/**
 * TẦNG 1 - MODEL
 * Đại diện cho 1 bản ghi trong bảng Category của database
 * Các field phải khớp với cột trong bảng:
 *   cate_id   -> id
 *   cate_name -> name
 *   icons     -> icon
 */
public class Category {

    private int    id;
    private String name;
    private String icon;

    // Constructor rỗng
    public Category() {}

    // Constructor đầy đủ
    public Category(String name, String icon) {
        this.name = name;
        this.icon = icon;
    }

    // Getter / Setter
    public int    getId()              { return id; }
    public void   setId(int id)        { this.id = id; }

    public String getName()            { return name; }
    public void   setName(String name) { this.name = name; }

    public String getIcon()            { return icon; }
    public void   setIcon(String icon) { this.icon = icon; }
}
