<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>

<%
    response.setHeader("Access-Control-Allow-Origin", "*");
    response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    response.setHeader("Access-Control-Allow-Headers", "Content-Type");

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Imprime todos los parámetros recibidos en la solicitud
    System.out.println("Debug: Petición recibida - " + request.getParameterMap());

    System.out.println("Debug: Username: " + username);
    System.out.println("Debug: Password: " + password);

    String responseMessage = "";
    boolean loginSuccess = false;
    Connection conn = null;

    try {
    conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/HotelRum", "postgres", "1");
    if (conn != null) {
        System.out.println("Debug: Conexión a la base de datos exitosa.");
    }

    PreparedStatement stmt = conn.prepareStatement("SELECT * FROM \"HotelRum\".\"usuarios\" WHERE usu_nombre = ? AND usu_contra = ?");
    stmt.setString(1, username);
    stmt.setString(2, password);
    
    System.out.println("Debug: Consulta preparada para el usuario: " + username);

    ResultSet rs = stmt.executeQuery();
    System.out.println("Debug: Resultados de la consulta:");
    
    if (rs.next()) {
        System.out.println("ID: " + rs.getInt("idusuarios") + ", Nombre: " + rs.getString("usu_nombre"));
        loginSuccess = true;
        responseMessage = "Login successful";
        System.out.println("Debug: Autenticación exitosa para el usuario: " + username);
    } else {
        responseMessage = "Invalid credentials";
        System.out.println("Debug: Credenciales inválidas para el usuario: " + username);
    }

    rs.close();
    stmt.close();
} catch (Exception e) {
    responseMessage = "Error: " + e.getMessage();
    System.out.println("Debug: Error durante la autenticación - " + e.getMessage());
} finally {
    if (conn != null) {
        try {
            conn.close();
            System.out.println("Debug: Conexión cerrada correctamente.");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Debug: Error al cerrar la conexión - " + e.getMessage());
        }
    }
}

// Creamos la respuesta en JSON
JSONObject jsonResponse = new JSONObject();
jsonResponse.put("success", loginSuccess);
jsonResponse.put("message", responseMessage);
out.print(jsonResponse.toString());

%>
