import java.sql.*;
String url = "jdbc:sqlserver://localhost:1433;databaseName=AgroPacayales;encrypt=true;trustServerCertificate=true";
String user = "sa";
String pass = "Admin12345!";
try (Connection conn = DriverManager.getConnection(url, user, pass);
     Statement stmt = conn.createStatement()) {
    System.out.println("Connected");
    ResultSet rs = stmt.executeQuery("SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME IN ('customer','supplier') ORDER BY TABLE_SCHEMA, TABLE_NAME");
    while (rs.next()) {
       System.out.println(rs.getString(1)+"."+rs.getString(2)+" -> "+rs.getString(3));
    }
    System.out.println("---SUPPLIER COLUMNS---");
    rs = stmt.executeQuery("SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='supplier' ORDER BY ORDINAL_POSITION");
    while (rs.next()) {
       System.out.println(rs.getString(1)+" " + rs.getString(2) + " len=" + rs.getString(3) + " nullable=" + rs.getString(4));
    }
} catch (Exception e) {
    e.printStackTrace();
}
