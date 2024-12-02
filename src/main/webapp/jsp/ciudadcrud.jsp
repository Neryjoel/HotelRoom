<%@ include file="conexion.jsp" %>

<%
if (request.getParameter("listar").equals("listar")) {
    Statement st = null;
    ResultSet rs = null;
    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"ciudades\" ORDER BY idciudades ASC;");
        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idciudades") %></td>
    <td><%= rs.getString("ciu_nombre") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarCiudad('<%= rs.getString("idciudades") %>', '<%= rs.getString("ciu_nombre") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarCiudadModal" onclick="$('#idciudades_e').val('<%= rs.getString("idciudades") %>')"></i>
        <a href="reporteVistaIndividual/reporteCiudad.jsp?ciu_GET=<%= rs.getString("idciudades") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) { /* Handle exception */ }
        if (st != null) try { st.close(); } catch (Exception e) { /* Handle exception */ }
    }
} else if (request.getParameter("listar").equals("cargar")) {
    String nombre = request.getParameter("ciu_nombre").trim();
    String regexMayusculas = "^[A-Z¡…Õ”⁄‹—\\s]+$";

    if (!nombre.isEmpty() && nombre.matches("^[a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò][a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò]*( [a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò]+)*$") && !nombre.matches(regexMayusculas)) {
        Statement st = null;
        ResultSet rs = null;
        try {
            st = conn.createStatement();
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"ciudades\" WHERE LOWER(ciu_nombre) = LOWER('" + nombre + "')");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("ciudad_existe");
            } else {
                st.executeUpdate("INSERT INTO \"HotelRum\".\"ciudades\" (ciu_nombre) VALUES('" + nombre + "')");
                out.println("<div class='alert alert-success' role='alert'>Datos insertados con Èxito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { /* Handle exception */ }
            if (st != null) try { st.close(); } catch (Exception e) { /* Handle exception */ }
        }
    } else {
        out.println("<div class='alert alert-danger' role='alert'>Nombre de la ciudad inv·lido!</div>");
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String nombre = request.getParameter("ciu_nombre").trim();
    String id = request.getParameter("idciudades");
    String regexMayusculas = "^[A-Z¡…Õ”⁄‹—\\s]+$";

    Statement st = null;
    ResultSet rs = null;
    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT ciu_nombre FROM \"HotelRum\".\"ciudades\" WHERE idciudades='" + id + "'");
        rs.next();
        String nombreOriginal = rs.getString("ciu_nombre");

        if (nombre.equalsIgnoreCase(nombreOriginal)) {
            // Si el nombre no ha cambiado (ignorando may˙sculas), simplemente actualiza la base de datos
            st.executeUpdate("UPDATE \"HotelRum\".\"ciudades\" SET ciu_nombre='" + nombre + "' WHERE idciudades='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Datos modificados con Èxito!</div>");
        }        else {
            // Si el nombre ha cambiado, verifica si el nuevo nombre ya existe en la base de datos
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"ciudades\" WHERE LOWER(ciu_nombre) = LOWER('" + nombre + "')");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("ciudad_existe");
            } else {
                if (!nombre.matches(regexMayusculas)) {
                    st.executeUpdate("UPDATE \"HotelRum\".\"ciudades\" SET ciu_nombre='" + nombre + "' WHERE idciudades='" + id + "'");
                    out.println("<div class='alert alert-success' role='alert'>Datos modificados con Èxito!</div>");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>Nombre de la ciudad inv·lido!</div>");
                }
            }
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) { /* Handle exception */ }
        if (st != null) try { st.close(); } catch (Exception e) { /* Handle exception */ }
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String pk = request.getParameter("idpk");
    Statement st = null;
    try {
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM \"HotelRum\".\"ciudades\" WHERE idciudades=" + pk);
        out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con Èxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    } finally {
        if (st != null) try { st.close(); } catch (Exception e) { /* Handle exception */ }
    }
}
%>