<%@ page import="java.sql.*" %>
<%@ include file="jsp/conexion.jsp" %>
<%
try {
    // Ejecutar la consulta para terminar las sesiones
    String sql = "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'HotelRum' AND pid <> pg_backend_pid();";
    Statement stmt = conn.createStatement();
    stmt.executeUpdate(sql);
    stmt.close();
    out.println("Sesiones terminadas correctamente.");
} catch (SQLException e) {
    e.printStackTrace();
    out.println("" + e.getMessage());
} finally {
    if (conn != null) {
        conn.close(); // Cerrar la conexión
    }
}
%>