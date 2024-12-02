<%@ include file="conexion.jsp" %>
<% 
// Validamos si el parámetro 'listar' existe antes de verificar su valor
String listar = request.getParameter("listar");
if (listar != null && listar.equals("listar")) {
    // Operación de lectura/listado de usuarios
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
            "SELECT u.idusuarios, u.usu_nombre, u.usu_contra, u.usu_estado, e.per_nombre, r.rol_descripcion, c.caja_nombre " +
            "FROM \"HotelRum\".\"usuarios\" u " +
            "JOIN \"HotelRum\".\"personales\" e ON u.personales_idpersonales = e.idpersonales " +
            "JOIN \"HotelRum\".\"roles\" r ON u.roles_idroles = r.idroles " +
            "LEFT JOIN \"HotelRum\".\"cajas\" c ON u.cajas_idcajas = c.idcajas " +
            "ORDER BY u.idusuarios ASC;"
        );
        while (rs.next()) {
%>
<tr>
    <td><% out.print(rs.getString("idusuarios")); %></td>
    <td><% out.print(rs.getString("usu_nombre")); %></td>
    <td><% out.print(rs.getString("usu_contra")); %></td>
    <td><% out.print(rs.getString("usu_estado")); %></td>
    <td><% out.print(rs.getString("per_nombre")); %></td>
    <td><% out.print(rs.getString("rol_descripcion")); %></td>
    <td><% out.print(rs.getString("caja_nombre") != null ? rs.getString("caja_nombre") : "Sin Caja"); %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarUsuario('<%= rs.getString("idusuarios") %>', '<%= rs.getString("usu_nombre") %>', '<%= rs.getString("usu_contra") %>', '<%= rs.getString("usu_estado") %>', '<%= rs.getString("per_nombre") %>', '<%= rs.getString("rol_descripcion") %>', '<%= rs.getString("caja_nombre") != null ? rs.getString("caja_nombre") : "" %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarUsuarioModal" onclick="$('#idusuarios_e').val('<%= rs.getString("idusuarios") %>')"></i>
        <a href="reporteVistaIndividual/reporteUsuario.jsp?usu=<%= rs.getString("idusuarios") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e.getMessage());
    }
} else if (listar != null && listar.equals("cargar")) {
    // Código para insertar un usuario
    String nombre = request.getParameter("usu_nombre").trim();
    String contra = request.getParameter("usu_contra").trim();
    String personal = request.getParameter("personales_idpersonales");
    String rol = request.getParameter("roles_idroles");
    String caja = request.getParameter("cajas_idcajas");
    String estado = request.getParameter("usu_estado");

    if (estado == null || estado.isEmpty()) {
        estado = "Activo";
    }

    if (!nombre.isEmpty() && !contra.isEmpty() && !personal.isEmpty() && !rol.isEmpty()) {
        try {
            Statement st = conn.createStatement();
            // Verificamos si ya existe un usuario con el mismo nombre
            ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"usuarios\" WHERE usu_nombre = '" + nombre + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("usuario_existe");
            } else {
                // Definimos el valor de cajas_idcajas como NULL si no se selecciona
                String cajasValue = (caja == null || caja.isEmpty()) ? "NULL" : caja;
                // Inserción del nuevo usuario
                String insertQuery = "INSERT INTO \"HotelRum\".\"usuarios\" (usu_nombre, usu_contra, usu_estado, personales_idpersonales, roles_idroles, cajas_idcajas) " +
                                     "VALUES('" + nombre + "', '" + contra + "', '" + estado + "', '" + personal + "', '" + rol + "', " + cajasValue + ")";
                st.executeUpdate(insertQuery);
                out.println("<div class='alert alert-success' role='alert'>Usuario insertado con éxito!</div>");
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } else {
        out.println("<div class='alert alert-danger' role='alert'>Por favor, complete todos los campos.</div>");
    }
} else if (listar != null && listar.equals("modificar")) {
    // Código para modificar un usuario
    String nombre = request.getParameter("usu_nombre").trim();
    String contra = request.getParameter("usu_contra").trim();
    String personal = request.getParameter("personales_idpersonales");
    String rol = request.getParameter("roles_idroles");
    String id = request.getParameter("idusuarios");
    String caja = request.getParameter("cajas_idcajas");
    String estado = request.getParameter("usu_estado");

    if (estado == null || estado.isEmpty()) {
        estado = "Activo";
    }

    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT usu_nombre FROM \"HotelRum\".\"usuarios\" WHERE idusuarios='" + id + "'");
        rs.next();
        String nombreOriginal = rs.getString("usu_nombre");

        if (nombre.equals(nombreOriginal)) {
            st.executeUpdate("UPDATE \"HotelRum\".\"usuarios\" SET usu_contra='" + contra + "', usu_estado='" + estado + "', personales_idpersonales='" + personal + "', roles_idroles='" + rol + "', cajas_idcajas=" + (caja != null ? caja : "NULL") + " WHERE idusuarios='" + id + "'");
            out.println("<div class='alert alert-success' role='alert'>Usuario modificado con éxito!</div>");
        } else {
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"usuarios\" WHERE usu_nombre = '" + nombre + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("usuario_existe");
            } else {
                st.executeUpdate("UPDATE \"HotelRum\".\"usuarios\" SET usu_nombre='" + nombre + "', usu_contra='" + contra + "', usu_estado='" + estado + "', personales_idpersonales='" + personal + "', roles_idroles='" + rol + "', cajas_idcajas=" + (caja != null ? caja : "NULL") + " WHERE idusuarios='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Usuario modificado con éxito!</div>");
            }
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e.getMessage());
    }
} else if (listar != null && listar.equals("eliminar")) {
    // Código para eliminar un usuario
    String pk = request.getParameter("idpk");
    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM \"HotelRum\".\"usuarios\" WHERE idusuarios=" + pk);
        out.println("<div class='alert alert-danger' role='alert'>Usuario eliminado con éxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL: " + e.getMessage());
    }
} 
%>
