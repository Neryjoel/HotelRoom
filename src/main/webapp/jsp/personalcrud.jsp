<%@ include file="conexion.jsp" %>
<% if (request.getParameter("listar").equals("listar")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT p.idpersonales, p.per_nombre, p.per_apellido, p.per_telefono, p.per_ci, c.ciu_nombre FROM \"HotelRum\".\"personales\" p JOIN \"HotelRum\".\"ciudades\" c ON p.ciudades_idciudades = c.idciudades ORDER BY p.idpersonales ASC;");
            while (rs.next()) {
%>
<tr>
    <td><%out.print(rs.getString("idpersonales"));%></td>
    <td><%out.print(rs.getString("per_nombre"));%></td>
    <td><%out.print(rs.getString("per_apellido"));%></td>
    <td><%out.print(rs.getString("per_ci"));%></td>
    <td><%out.print(rs.getString("per_telefono"));%></td>
    <td><%out.print(rs.getString("ciu_nombre"));%></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarPersonal('<%= rs.getString("idpersonales") %>', '<%= rs.getString("per_nombre") %>', '<%= rs.getString("per_apellido") %>', '<%= rs.getString("per_ci") %>', '<%= rs.getString("per_telefono") %>', '<%= rs.getString("ciu_nombre") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarPersonalModal" onclick="$('#idpersonales_e').val('<%= rs.getString("idpersonales") %>')"></i>
        <a href="reporteVistaIndividual/reportePersonal.jsp?per=<%= rs.getString("idpersonales") %>" class="btn btn-info">
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
    String nombre = request.getParameter("per_nombre").trim();
    String apellido = request.getParameter("per_apellido").trim();
    String ci = request.getParameter("per_ci").trim();
    String telefono = request.getParameter("per_telefono").trim();
    String ciudad = request.getParameter("ciudades_idciudades");
    
    if (!nombre.isEmpty() && !apellido.isEmpty() && !ci.isEmpty() && !telefono.isEmpty() && !ciudad.isEmpty()) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"personales\" WHERE per_ci = '" + ci + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("personal_existe");
            } else {
                st.executeUpdate("INSERT INTO \"HotelRum\".\"personales\" (per_nombre, per_apellido, per_ci, per_telefono, ciudades_idciudades) VALUES('" + nombre + "', '" + apellido + "', '" + ci + "', '" + telefono + "', '" + ciudad + "')");
                out.println("<div class='alert alert-success' role='alert'>Personal insertado con éxito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        }
    } else {
        out.println("<div class='alert alert-danger' role='alert'>Por favor, complete todos los campos.</div>");
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String nombre = request.getParameter("per_nombre").trim();
    String apellido = request.getParameter("per_apellido").trim();
    String ci = request.getParameter("per_ci").trim();
    String telefono = request.getParameter("per_telefono").trim();
    String ciudad = request.getParameter("ciudades_idciudades");
    String id = request.getParameter("idpersonales");

    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT per_ci FROM \"HotelRum\".\"personales\" WHERE idpersonales='" + id + "'");
        rs.next();
        String ciOriginal = rs.getString("per_ci");

        if (ci.equals(ciOriginal)) {
            // Si la cedula no ha cambiado, simplemente actualiza la base de datos
            st.executeUpdate("UPDATE \"HotelRum\".\"personales\" SET per_nombre='" + nombre + "', per_apellido='" + apellido + "', per_telefono='" + telefono + "', ciudades_idciudades='" + ciudad + "' WHERE idpersonales='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Personal modificado con éxito!</div>");
        } else {
            // Si la cedula ha cambiado, verifica si la nueva cedula ya existe en la base de datos
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"personales\" WHERE per_ci = '" + ci + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("personal_existe");
            } else {
                st.executeUpdate("UPDATE \"HotelRum\".\"personales\" SET per_nombre='" + nombre + "', per_apellido='" + apellido + "', per_ci='" + ci + "', per_telefono='" + telefono + "', ciudades_idciudades='" + ciudad + "' WHERE idpersonales='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Personal modificado con éxito!</div>");
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
        st.executeUpdate("DELETE FROM \"HotelRum\".\"personales\" WHERE idpersonales=" + pk);
        out.println("<div class='alert alert-danger' role='alert'>Personal eliminado con éxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}
%>
