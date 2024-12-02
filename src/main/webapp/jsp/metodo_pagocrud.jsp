<%@ include file="conexion.jsp" %>

<%
if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"metodo_pago\" ORDER BY idmetodo_pago ASC;");
        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idmetodo_pago") %></td>
    <td><%= rs.getString("descripcion") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarMetodoPago('<%= rs.getString("idmetodo_pago") %>', '<%= rs.getString("descripcion") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarMetodoPagoModal" onclick="$('#idMetodo_pago_e').val('<%= rs.getString("idmetodo_pago") %>')"></i>
        <a href="reporteVistaIndividual/reporteMetodoPago.jsp?mp=<%= rs.getString("idmetodo_pago") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("cargar")) {
    String descripcion = request.getParameter("descripcion").trim();

    if (!descripcion.isEmpty() && descripcion.matches("^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]+)*$")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"metodo_pago\" WHERE LOWER(descripcion) = LOWER('" + descripcion + "')");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("metodo_pago_existe");
            } else if (descripcion.equals(descripcion.toUpperCase())) {
                out.println("<div class='alert alert-danger' role='alert'>El nombre no debe estar completamente en mayúsculas.</div>");
            } else {
                st.executeUpdate("INSERT INTO \"HotelRum\".\"metodo_pago\" (descripcion) VALUES('" + descripcion + "')");
                out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        }
    } else {
        out.println("<div class='alert alert-danger' role='alert'>Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</div>");
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String descripcion = request.getParameter("descripcion").trim();
    String id = request.getParameter("idmetodo_pago");

    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT descripcion FROM \"HotelRum\".\"metodo_pago\" WHERE idmetodo_pago='" + id + "'");
        rs.next();
        String descripcionOriginal = rs.getString("descripcion");

        if (descripcion.equals(descripcionOriginal)) {
            st.executeUpdate("UPDATE \"HotelRum\".\"metodo_pago\" SET descripcion='" + descripcion + "' WHERE idmetodo_pago='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
        } else {
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"metodo_pago\" WHERE LOWER(descripcion) = LOWER('" + descripcion + "')");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("metodo_pago_existe");
                return;
            }

            if (descripcion.equals(descripcion.toUpperCase())) {
                out.println("<div class='alert alert-danger' role='alert'>El nombre no debe estar completamente en mayúsculas.</div>");
                return;
            }

            st.executeUpdate("UPDATE \"HotelRum\".\"metodo_pago\" SET descripcion='" + descripcion + "' WHERE idmetodo_pago='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String pk = request.getParameter("idpk");
    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM \"HotelRum\".\"metodo_pago\" WHERE idmetodo_pago=" + pk);
        out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con éxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}
%>