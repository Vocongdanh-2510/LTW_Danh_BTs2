package Model;

import java.io.Serializable;
import java.sql.Date;

/**
 * TẦNG 1 - MODEL
 * Tương ứng bảng [users] trong database
 */
@SuppressWarnings("serial")
public class User implements Serializable {

    private int    id;
    private String email;
    private String userName;    // tên đăng nhập
    private String fullName;
    private String passWord;
    private String avatar;
    private int    roleid;      // 1=admin, 2=manager, 5=user thường
    private String phone;
    private Date   createdDate;
    private int    status = 1;  // 0 = chưa kích hoạt, 1 = đã kích hoạt
    private String code;        // Mã OTP xác thực (kích hoạt hoặc quên mật khẩu)

    // Constructor rỗng
    public User() {}

    // Constructor dùng khi đăng ký
    public User(String email, String userName, String fullName,
                String passWord, String avatar, int roleid,
                String phone, Date createdDate) {
        this.email       = email;
        this.userName    = userName;
        this.fullName    = fullName;
        this.passWord    = passWord;
        this.avatar      = avatar;
        this.roleid      = roleid;
        this.phone       = phone;
        this.createdDate = createdDate;
        this.status      = 1;
    }

    // Constructor đầy đủ cả status và code
    public User(String email, String userName, String fullName,
                String passWord, String avatar, int roleid,
                String phone, Date createdDate, int status, String code) {
        this.email       = email;
        this.userName    = userName;
        this.fullName    = fullName;
        this.passWord    = passWord;
        this.avatar      = avatar;
        this.roleid      = roleid;
        this.phone       = phone;
        this.createdDate = createdDate;
        this.status      = status;
        this.code        = code;
    }

    // ── Getter / Setter ──────────────────────────────────────
    public int    getId()                      { return id; }
    public void   setId(int id)                { this.id = id; }

    public String getEmail()                   { return email; }
    public void   setEmail(String email)       { this.email = email; }

    public String getUserName()                { return userName; }
    public void   setUserName(String userName) { this.userName = userName; }

    // Alias cho JPA/JSP
    public String getUsername()                { return userName; }
    public void   setUsername(String username) { this.userName = username; }

    public String getFullName()                { return fullName; }
    public void   setFullName(String fullName) { this.fullName = fullName; }

    // Alias cho JSP
    public String getFullname()                { return fullName; }
    public void   setFullname(String fullname) { this.fullName = fullname; }

    public String getPassWord()                { return passWord; }
    public void   setPassWord(String passWord) { this.passWord = passWord; }

    public String getPassword()                { return passWord; }
    public void   setPassword(String password) { this.passWord = password; }

    public String getAvatar()                  { return avatar; }
    public void   setAvatar(String avatar)     { this.avatar = avatar; }

    public int    getRoleid()                  { return roleid; }
    public void   setRoleid(int roleid)        { this.roleid = roleid; }

    public String getPhone()                   { return phone; }
    public void   setPhone(String phone)       { this.phone = phone; }

    public Date   getCreatedDate()                 { return createdDate; }
    public void   setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public int    getStatus()                  { return status; }
    public void   setStatus(int status)        { this.status = status; }

    public String getCode()                    { return code; }
    public void   setCode(String code)         { this.code = code; }
}
