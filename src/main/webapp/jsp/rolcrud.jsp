<%@ include file="conexion.jsp" %>

<%
String accion = request.getParameter("listar");
if (accion != null) {
    try {
        Statement st = conn.createStatement();

        if (accion.equals("listar")) {
            ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"roles\" ORDER BY idroles ASC;");
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idroles") %></td>
    <td><%= rs.getString("rol_descripcion") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarRol('<%= rs.getString("idroles") %>', '<%= rs.getString("rol_descripcion") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarRolModal" onclick="$('#idrol_e').val('<%= rs.getString("idroles") %>')"></i>
        <a href="reporteVistaIndividual/reporteRol.jsp?rol_GET=<%= rs.getString("idroles") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } else if (accion.equals("cargar")) {
            String descripcion = request.getParameter("rol_descripcion").trim();
            if (!descripcion.isEmpty() && descripcion.matches("^[a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_]+)*$")) {
                // Convertir a minúsculas para la comparación
                String descripcionLower = descripcion.toLowerCase();

                ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"roles\" WHERE LOWER(rol_descripcion) = '" + descripcionLower + "'");
                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("rol_existe");
                } else {
                    // Insertar sin cambiar la descripción original
                    st.executeUpdate("INSERT INTO \"HotelRum\".\"roles\" (rol_descripcion) VALUES('" + descripcion + "')");
                    out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
                }
            } else {
                out.println("<div class='alert alert-danger' role='alert'>Descripción inválida. Asegúrese de que no contiene caracteres especiales.</div>");
            }
        } else if (accion.equals("modificar")) {
            String descripcion = request.getParameter("rol_descripcion").trim();
            String id = request.getParameter("idrol");

            // Convertir la descripción a minúsculas para la comparación
            String descripcionLower = descripcion.toLowerCase();

            ResultSet rs = st.executeQuery("SELECT rol_descripcion FROM \"HotelRum\".\"roles\" WHERE idroles='" + id + "'");
            rs.next();
            String descripcionOriginal = rs.getString("rol_descripcion");
            String descripcionOriginalLower = descripcionOriginal.toLowerCase();

            if (descripcionLower.equals(descripcionOriginalLower)) {
                // Si la descripción no ha cambiado, actualiza directamente
                st.executeUpdate("UPDATE \"HotelRum\".\"roles\" SET rol_descripcion='" + descripcion + "' WHERE idroles='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
            } else {
                // Si la descripción ha cambiado, verifica si el nuevo nombre ya existe
                ResultSet rsCheck = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"roles\" WHERE LOWER(rol_descripcion) = '" + descripcionLower + "'");
                rsCheck.next();
                int count = rsCheck.getInt("count");

                if (count > 0) {
                    out.println("rol_existe");
                } else {
                    st.executeUpdate("UPDATE \"HotelRum\".\"roles\" SET rol_descripcion='" + descripcion + "' WHERE idroles='" + id + "'");
                    out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
                }
            }
        } else if (accion.equals("eliminar")) {
            String pk = request.getParameter("idpk");
            st.executeUpdate("DELETE FROM \"HotelRum\".\"roles\" WHERE idroles=" + pk);
            out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con éxito!</div>");
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }finally {
        conn.close();
    }
}
%>
