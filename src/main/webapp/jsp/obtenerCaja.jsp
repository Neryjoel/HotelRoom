<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ include file="conexion.jsp" %> <!-- Asegúrate de que este archivo establece la conexión -->

<%
    HttpSession sesion = request.getSession();
    String userId = sesion.getAttribute("id").toString(); // Obtener ID del usuario logueado
    String userRole = sesion.getAttribute("rol").toString(); // Obtener rol del usuario logueado

    Statement st = null; // Declarar la variable Statement aquí
    ResultSet rs = null; // Declarar la variable ResultSet aquí

    if ("buscarcaja".equals(request.getParameter("listar"))) {
        try {
            // Asegúrate de que conn esté inicializada en el archivo conexion.jsp
            st = conn.createStatement(); // Asignar la conexión a la variable
            
            String query;
            if ("Administrador".equals(userRole)) {
                // Si el usuario es Administrador, cargar todas las cajas
                query = "SELECT idcajas, caja_nombre FROM \"HotelRum\".cajas ORDER BY idcajas ASC;";
%>
<option value="">Seleccionar</option> <!-- Solo se muestra si es Administrador -->
<%
            } else {
                // Si no es Administrador, cargar solo las cajas vinculadas al usuario
                query = "SELECT c.idcajas, c.caja_nombre " +
                        "FROM \"HotelRum\".cajas c " +
                        "INNER JOIN \"HotelRum\".usuarios u ON c.idcajas = u.cajas_idcajas " +
                        "WHERE u.idusuarios = " + userId + " " +
                        "ORDER BY c.idcajas ASC;";
            }
            
            rs = st.executeQuery(query); // Asignar el resultado a la variable

            while (rs.next()) {
%>
<option value="<%= rs.getString("idcajas") %>"><%= rs.getString("caja_nombre") %></option>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        } finally {
            // Cerrar el ResultSet y Statement si están abiertos
            try {
                if (rs != null) rs.close(); // Cerrar el ResultSet
                if (st != null) st.close(); // Cerrar el Statement
            } catch (Exception e) {
                out.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
    } else if ("buscarusuario".equals(request.getParameter("listar"))) {
        try {
%>
<option value="<%= userId %>"><%= sesion.getAttribute("user") %></option>
<%
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>