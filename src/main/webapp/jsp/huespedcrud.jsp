<%@ include file="conexion.jsp" %>

<%
if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"huespedes\" ORDER BY idhuespedes ASC;");
        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idhuespedes") %></td>
    <td><%= rs.getString("hues_nombre") %></td>
    <td><%= rs.getString("hues_apellido") %></td>
    <td><%= rs.getString("hues_ci") %></td>
    <td><%= rs.getString("hues_telefono") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarHuesped('<%= rs.getString("idhuespedes") %>', '<%= rs.getString("hues_nombre") %>', '<%= rs.getString("hues_apellido") %>', '<%= rs.getString("hues_ci") %>', '<%= rs.getString("hues_telefono") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarHuespedModal" onclick="$('#idhuespedes_e').val('<%= rs.getString("idhuespedes") %>')"></i>
        <a href="reporteVistaIndividual/reporteHuesped.jsp?hues_GET=<%= rs.getString("idhuespedes") %>" class="btn btn-info">
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
    String nombre = request.getParameter("hues_nombre").trim();
    String apellido = request.getParameter("hues_apellido").trim();
    String ci = request.getParameter("hues_ci").trim();
    String telefono = request.getParameter("hues_telefono").trim();
    
    if (!nombre.isEmpty() && !apellido.isEmpty() && !ci.isEmpty() && !telefono.isEmpty()) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"huespedes\" WHERE hues_ci = '" + ci + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("huesped_existe");
            } else {
                st.executeUpdate("INSERT INTO \"HotelRum\".\"huespedes\" (hues_nombre, hues_apellido, hues_ci, hues_telefono) VALUES('" + nombre + "', '" + apellido + "', '" + ci + "', '" + telefono + "')");
                out.println("<div class='alert alert-success' role='alert'>Huesped insertado con éxito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        }
    } else {
        out.println("<div class='alert alert-danger' role='alert'>Por favor, complete todos los campos.</div>");
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String nombre = request.getParameter("hues_nombre").trim();
    String apellido = request.getParameter("hues_apellido").trim();
    String ci = request.getParameter("hues_ci").trim();
    String telefono = request.getParameter("hues_telefono").trim();
    String id = request.getParameter("idhuespedes");

    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT hues_ci FROM \"HotelRum\".\"huespedes\" WHERE idhuespedes='" + id + "'");
        rs.next();
        String ciOriginal = rs.getString("hues_ci");

        if (ci.equals(ciOriginal)) {
            // Si la cedula no ha cambiado, simplemente actualiza la base de datos
            st.executeUpdate("UPDATE \"HotelRum\".\"huespedes\" SET hues_nombre='" + nombre + "', hues_apellido='" + apellido + "', hues_telefono='" + telefono + "' WHERE idhuespedes='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Huesped modificado con éxito!</div>");
        } else {
            // Si la cedula ha cambiado, verifica si la nueva cedula ya existe en la base de datos
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"huespedes\" WHERE hues_ci = '" + ci + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("huesped_existe");
            } else {
                st.executeUpdate("UPDATE \"HotelRum\".\"huespedes\" SET hues_nombre='" + nombre + "', hues_apellido='" + apellido + "', hues_ci='" + ci + "', hues_telefono='" + telefono + "' WHERE idhuespedes='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Huesped modificado con éxito!</div>");
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
        st.executeUpdate("DELETE FROM \"HotelRum\".\"huespedes\" WHERE idhuespedes=" + pk);
        out.println("<div class='alert alert-danger' role='alert'>Huesped eliminado con éxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}
%>
