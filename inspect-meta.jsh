import java.sql.*;
String url = "jdbc:sqlserver://localhost:1433;databaseName=AgroPacayales;encrypt=true;trustServerCertificate=true";
String user = "sa";
String pass = "Admin12345!";
try (Connection conn = DriverManager.getConnection(url, user, pass)) {
    DatabaseMetaData md = conn.getMetaData();
    System.out.println("MetaData tables:");
    try (ResultSet rs = md.getTables(null, null, "%", new String[] {"TABLE"})) {
        while (rs.next()) {
            String schema = rs.getString("TABLE_SCHEM");
            String name = rs.getString("TABLE_NAME");
            System.out.println(schema + "." + name);
        }
    }
    System.out.println("Catalog: " + conn.getCatalog());
    System.out.println("Schema: " + conn.getSchema());
} catch (Exception e) {
    e.printStackTrace();
}
