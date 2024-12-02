<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.Date"%>
<%@ include file="conexion.jsp" %>

<%
    PreparedStatement pst = null;
    ResultSet rs = null;

    String user = request.getParameter("usuario");
    String password = request.getParameter("pswrd");

    HttpSession sesion = request.getSession();

    // Initialize login attempts and timestamp if not already done
    Integer loginAttempts = (Integer) sesion.getAttribute("loginAttempts");
    Long lastAttemptTime = (Long) sesion.getAttribute("lastAttemptTime");

    if (loginAttempts == null) {
        loginAttempts = 0;
        sesion.setAttribute("loginAttempts", loginAttempts);
    }

    // Check if the user has exceeded the allowed number of attempts
    if (loginAttempts >= 3) {
        // Check if one minute has passed since the last attempt
        if (lastAttemptTime != null && (new Date().getTime() - lastAttemptTime < 60000)) {
            out.println("<div class=\"alert alert-danger\" role=\"alert\">"
                        + "Demasiados intentos fallidos. Por favor, espere 1 minuto.</div>");
        } else {
            // Reset attempts if more than a minute has passed
            sesion.setAttribute("loginAttempts", 0);
            sesion.setAttribute("lastAttemptTime", null);
            loginAttempts = 0;
        }
    } else {
        try {
            // Prepare the SQL statement
            String sql = "SELECT u.idusuarios, u.usu_nombre, u.usu_contra, u.usu_estado, "
                       + "p.per_nombre, p.per_apellido, r.rol_descripcion "
                       + "FROM \"HotelRum\".usuarios u "
                       + "INNER JOIN \"HotelRum\".personales p ON u.personales_idpersonales = p.idpersonales "
                       + "INNER JOIN \"HotelRum\".roles r ON u.roles_idroles = r.idroles "
                       + "WHERE u.usu_nombre = ? AND u.usu_contra = ? AND u.usu_estado = 'Activo'";

            // Create a PreparedStatement
            pst = conn.prepareStatement(sql);
            pst.setString(1, user);
            pst.setString(2, password);

            // Execute the query
            rs = pst.executeQuery();

            if (rs.next()) {
                // Successful login
                sesion.setAttribute("logueado", "1");
                sesion.setAttribute("user", rs.getString("usu_nombre"));
                sesion.setAttribute("id", rs.getString("idusuarios"));
                sesion.setAttribute("rol", rs.getString("rol_descripcion"));
                sesion.setAttribute("personal_nombre", rs.getString("per_nombre"));
                sesion.setAttribute("personal_apellido", rs.getString("per_apellido"));

                // Reset login attempts on successful login
                sesion.setAttribute("loginAttempts", 0);
                sesion.setAttribute("lastAttemptTime", null); // Clear the last attempt time

                // Redirect to dashboard.jsp
%>
<script>
    location.href = 'dashboard.jsp';
</script>
<%
            } else {
                // Failed login
                loginAttempts++;
                sesion.setAttribute("loginAttempts", loginAttempts);
                sesion.setAttribute("lastAttemptTime", new Date().getTime()); // Update the last attempt time
                out.println("<div class=\"alert alert-danger\" role=\"alert\">Usuario no válido</div>");
            }
        } catch (SQLException e) {
            out.print(e.getMessage());
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pst != null) try { pst.close(); } catch (SQLException e) {}
        }
    }
%>