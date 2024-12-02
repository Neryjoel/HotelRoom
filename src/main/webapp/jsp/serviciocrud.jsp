<%@ include file="conexion.jsp" %>

<%
if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"servicios\" ORDER BY idservicios ASC;");
        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idservicios") %></td>
    <td><%= rs.getString("serv_descripcion") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarServicio('<%= rs.getString("idservicios") %>', '<%= rs.getString("serv_descripcion") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarServicioModal" onclick="$('#idservicio_e').val('<%= rs.getString("idservicios") %>')"></i>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("cargar")) {
    String descripcion = request.getParameter("serv_descripcion").trim();
    if (!descripcion.isEmpty() && descripcion.matches("^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]+)*$")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"servicios\" WHERE serv_descripcion = '" + descripcion + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("servicio_existe");
            } else {
                st.executeUpdate("INSERT INTO \"HotelRum\".\"servicios\" (serv_descripcion) VALUES('" + descripcion + "')");
                out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        }
    } else {
        out.println("<div class='alert alert-danger' role='alert'>Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</div>");
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String descripcion = request.getParameter("serv_descripcion").trim();
    String id = request.getParameter("idservicios");

    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT serv_descripcion FROM \"HotelRum\".\"servicios\" WHERE idservicios='" + id + "'");
        rs.next();
        String descripcionOriginal = rs.getString("serv_descripcion");

        if (descripcion.equals(descripcionOriginal)) {
            // Si la descripción no ha cambiado, simplemente actualiza la base de datos
            st.executeUpdate("UPDATE \"HotelRum\".\"servicios\" SET serv_descripcion='" + descripcion + "' WHERE idservicios='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
        } else {
            // Si la descripción ha cambiado, verifica si el nuevo nombre ya existe en la base de datos
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"servicios\" WHERE serv_descripcion = '" + descripcion + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("servicio_existe");
            } else {
                st.executeUpdate("UPDATE \"HotelRum\".\"servicios\" SET serv_descripcion='" + descripcion + "' WHERE idservicios='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
            }
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String pk = request.getParameter("idpk");
    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM \"HotelRum\".\"servicios\" WHERE idservicios=" + pk);
        out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con éxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}
%>
