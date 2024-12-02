import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/api/huespedes")
public class HuespedServlet extends HttpServlet {

    private final String url = "jdbc:postgresql://localhost:5432/HotelRum";
    private final String user = "postgres";
    private final String password = "1";

    private void setCORSHeaders(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setCORSHeaders(response);
        response.setStatus(HttpServletResponse.SC_OK); // 200 OK
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setCORSHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JSONArray jsonData = new JSONArray();
        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM \"HotelRum\".\"huespedes\"")) {

            while (rs.next()) {
                JSONObject huesped = new JSONObject();
                huesped.put("idhuespedes", rs.getInt("idhuespedes"));
                huesped.put("hues_nombre", rs.getString("hues_nombre"));
                huesped.put("hues_apellido", rs.getString("hues_apellido"));
                huesped.put("hues_ci", rs.getString("hues_ci"));
                huesped.put("hues_telefono", rs.getString("hues_telefono"));
                jsonData.put(huesped);
            }

            response.getWriter().write(jsonData.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Error al conectar a la base de datos\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setCORSHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String jsonBody = request.getReader().lines().reduce("", String::concat);

        try {
            JSONObject jsonObject = new JSONObject(jsonBody);

            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement pstmt = conn.prepareStatement("INSERT INTO \"HotelRum\".\"huespedes\" (hues_nombre, hues_apellido, hues_ci, hues_telefono) VALUES (?, ?, ?, ?)")) {

                pstmt.setString(1, jsonObject.getString("hues_nombre"));
                pstmt.setString(2, jsonObject.getString("hues_apellido"));
                pstmt.setString(3, jsonObject.getString("hues_ci"));
                pstmt.setString(4, jsonObject.getString("hues_telefono"));

                pstmt.executeUpdate();
                response.setStatus(HttpServletResponse.SC_CREATED); // 201 Created
                response.getWriter().write("{\"message\":\"Huésped agregado exitosamente\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Error al agregar huésped\"}");
        }
    }


    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setCORSHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String jsonBody = request.getReader().lines().reduce("", String::concat);

        try {
            JSONObject jsonObject = new JSONObject(jsonBody);
            int id = jsonObject.getInt("idhuespedes"); // Obtener el ID del huésped a actualizar

            try (Connection conn = DriverManager.getConnection(url, user, password);
                 PreparedStatement pstmt = conn.prepareStatement("UPDATE \"HotelRum\".\"huespedes\" SET hues_nombre = ?, hues_apellido = ?, hues_ci = ?, hues_telefono = ? WHERE idhuespedes = ?")) {

                pstmt.setString(1, jsonObject.getString("hues_nombre"));
                pstmt.setString(2, jsonObject.getString("hues_apellido"));
                pstmt.setString(3, jsonObject.getString("hues_ci"));
                pstmt.setString(4, jsonObject.getString("hues_telefono"));
                pstmt.setInt(5, id); // Establecer el ID del huésped a actualizar

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.getWriter().write("{\"message\":\"Huésped actualizado exitosamente\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 404 Not Found
                    response.getWriter().write("{\"error\":\"Huésped no encontrado\"}");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Error al actualizar huésped\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        setCORSHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idString = request.getPathInfo(); // Obtener el ID del huésped de la URL
        if (idString == null || idString.length() < 2) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            response.getWriter().write("{\"error\":\"ID de huésped no proporcionado\"}");
            return;
        }

        int id = Integer.parseInt(idString.substring(1)); // Extraer el ID del huésped

        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM \"HotelRum\".\"huespedes\" WHERE idhuespedes = ?")) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204 No Content
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 404 Not Found
                response.getWriter().write("{\"error\":\"Huésped no encontrado\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Error al eliminar huésped\"}");
        }
    }
}