package Utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Tiện ích kết nối SQL Server
 * Tự động hỗ trợ cả chế độ mã hóa SSL (encrypt=true) và không mã hóa (encrypt=false)
 * để tương thích 100% với SQL Server 2019/2022 và đồng bộ với persistence.xml
 */
public class DBConnection {

    private static final String SERVER   = "localhost";
    private static final String PORT     = "1433";
    private static final String DATABASE = "webst2";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "1234567@a$";

    // URL 1: encrypt=true, trustServerCertificate=true (chuẩn đồng bộ với persistence.xml cho JPA/Hibernate)
    private static final String URL_ENCRYPT =
            "jdbc:sqlserver://" + SERVER + ":" + PORT + ";"
          + "databaseName=" + DATABASE + ";"
          + "encrypt=true;"
          + "trustServerCertificate=true;";

    // URL 2: encrypt=false, trustServerCertificate=true (dành cho các bản SQL Server cũ không bật SSL)
    private static final String URL_NO_ENCRYPT =
            "jdbc:sqlserver://" + SERVER + ":" + PORT + ";"
          + "databaseName=" + DATABASE + ";"
          + "encrypt=false;"
          + "trustServerCertificate=true;";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Không tìm thấy SQL Server JDBC Driver", e);
        }

        // Ưu tiên kết nối bảo mật trước (khớp với persistence.xml)
        try {
            return DriverManager.getConnection(URL_ENCRYPT, USERNAME, PASSWORD);
        } catch (SQLException e) {
            // Nếu lỗi mã hóa, thử lại với URL không bắt buộc mã hóa
            try {
                return DriverManager.getConnection(URL_NO_ENCRYPT, USERNAME, PASSWORD);
            } catch (SQLException ex) {
                System.err.println("[DBConnection ERROR] Kết nối CSDL thất bại cả 2 phương thức: " + ex.getMessage());
                throw ex;
            }
        }
    }
}
