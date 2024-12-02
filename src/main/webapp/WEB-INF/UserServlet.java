import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException; // Cambiar a jakarta.servlet
import jakarta.servlet.annotation.WebServlet; // Cambiar a jakarta.servlet
import jakarta.servlet.http.HttpServlet; // Cambiar a jakarta.servlet
import jakarta.servlet.http.HttpServletRequest; // Cambiar a jakarta.servlet
import jakarta.servlet.http.HttpServletResponse; // Cambiar a jakarta.servlet

@WebServlet("/api/users")
public class UserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        StringBuilder jsonData = new StringBuilder("[");
        try {
            String url = "jdbc:postgresql://localhost:5432/HotelRum";
            String user = "postgres";
            String password = "1";

            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM \"HotelRum\".\"usuarios\"");

            while (rs.next()) {
                jsonData.append("{\"idusuarios\":").append(rs.getInt("idusuarios"))
                        .append(",\"usu_nombre\":\"").append(rs.getString("usu_nombre")).append("\"},");
            }

            if (jsonData.length() > 1) {
                jsonData.setLength(jsonData.length() - 1); // Eliminar la última coma
            }
            jsonData.append("]");
            response.getWriter().write(jsonData.toString());

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Error al conectar a la base de datos\"}");
        }
    }
}
