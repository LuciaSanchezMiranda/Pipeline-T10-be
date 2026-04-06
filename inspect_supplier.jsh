import java.sql.DriverManager;
var url = "jdbc:sqlserver://localhost:1433;databaseName=AgroPacayales;encrypt=true;trustServerCertificate=true";
var user = "sa";
var pass = "Admin12345!";
var conn = DriverManager.getConnection(url, user, pass);
var stmt = conn.createStatement();
var rs = stmt.executeQuery("SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='supplier' ORDER BY ORDINAL_POSITION");
while (rs.next()) {
    System.out.println(rs.getString(1) + "\t" + rs.getString(2));
}
rs.close();
stmt.close();
conn.close();
