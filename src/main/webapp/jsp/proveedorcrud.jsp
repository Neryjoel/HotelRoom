<%@ include file="conexion.jsp" %>
<% if (request.getParameter("listar").equals("listar")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT p.idproveedores, p.prov_nombre, p.prov_ruc, p.prov_telefono, p.prov_direccion, p.prov_email, c.ciu_nombre FROM \"HotelRum\".\"proveedores\" p JOIN \"HotelRum\".\"ciudades\" c ON p.ciudades_idciudades = c.idciudades ORDER BY p.idproveedores ASC;");
            while (rs.next()) {
%>
<tr>
    <td><% out.print(rs.getString("idproveedores")); %></td>
    <td><% out.print(rs.getString("prov_nombre")); %></td>
    <td><% out.print(rs.getString("prov_ruc")); %></td>
    <td><% out.print(rs.getString("prov_telefono")); %></td>
    <td><% out.print(rs.getString("prov_direccion")); %></td>
    <td><% out.print(rs.getString("prov_email")); %></td>
    <td><% out.print(rs.getString("ciu_nombre"));%></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarProveedor('<%= rs.getString("idproveedores")%>', '<%= rs.getString("prov_nombre")%>', '<%= rs.getString("prov_ruc")%>', '<%= rs.getString("prov_telefono")%>', '<%= rs.getString("prov_direccion")%>', '<%= rs.getString("prov_email")%>', '<%= rs.getString("ciu_nombre")%>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarProveedorModal" onclick="$('#idproveedores_e').val('<%= rs.getString("idproveedores")%>')"></i>
        <a href="reporteVistaIndividual/reporteProveedor.jsp?pro=<%= rs.getString("idproveedores")%>" class="btn btn-info">
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
        String nombre = request.getParameter("prov_nombre").trim();
        String ruc = request.getParameter("prov_ruc").trim();
        String telefono = request.getParameter("prov_telefono").trim();
        String direccion = request.getParameter("prov_direccion").trim();
        String email = request.getParameter("prov_email").trim();
        String ciudad = request.getParameter("ciudades_idciudades");

        if (!nombre.isEmpty() && !ruc.isEmpty() && !telefono.isEmpty() && !direccion.isEmpty() && !email.isEmpty() && !ciudad.isEmpty()) {
            try {
                Statement st = null;
                ResultSet rs = null;
                st = conn.createStatement();
                rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"proveedores\" WHERE prov_ruc = '" + ruc + "'");
                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("proveedor_existe");
                } else {
                    st.executeUpdate("INSERT INTO \"HotelRum\".\"proveedores\" (prov_nombre, prov_ruc, prov_telefono, prov_direccion, prov_email, ciudades_idciudades) VALUES('" + nombre + "', '" + ruc + "', '" + telefono + "', '" + direccion + "', '" + email + "', '" + ciudad + "')");
                    out.println("<div class='alert alert-success' role='alert'>Proveedor insertado con éxito!</div>");
                }
            } catch (Exception e) {
                out.println("Error PSQL" + e);
            }
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Por favor, complete todos los campos.</div>");
        }
    } else if (request.getParameter("listar").equals("modificar")) {
        String nombre = request.getParameter("prov_nombre").trim();
        String ruc = request.getParameter("prov_ruc").trim();
        String telefono = request.getParameter("prov_telefono").trim();
        String direccion = request.getParameter("prov_direccion").trim();
        String email = request.getParameter("prov_email").trim();
        String ciudad = request.getParameter("ciudades_idciudades");
        String id = request.getParameter("idproveedores");

        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT prov_ruc FROM \"HotelRum\".\"proveedores\" WHERE idproveedores='" + id + "'");
            rs.next();
            String rucOriginal = rs.getString("prov_ruc");

            if (ruc.equals(rucOriginal)) {
                // If RUC has not changed, simply update the database
                st.executeUpdate("UPDATE \"HotelRum\".\"proveedores\" SET prov_nombre='" + nombre + "', prov_telefono='" + telefono + "', prov_direccion='" + direccion + "', prov_email='" + email + "', ciudades_idciudades='" + ciudad + "' WHERE idproveedores='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Proveedor modificado con éxito!</div>");
            } else {
                // If RUC has changed, check if the new RUC already exists in the database
                rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"proveedores\" WHERE prov_ruc = '" + ruc + "'");
                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("proveedor_existe");
                } else {
                    st.executeUpdate("UPDATE \"HotelRum\".\"proveedores\" SET prov_nombre='" + nombre + "', prov_ruc='" + ruc + "', prov_telefono='" + telefono + "', prov_direccion='" + direccion + "', prov_email='" + email + "', ciudades_idciudades='" + ciudad + "' WHERE idproveedores='" + id + "'");
                    out.println("<div class='alert alert-success' role='alert'>Proveedor modificado con éxito!</div>");
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
            st.executeUpdate("DELETE FROM \"HotelRum\".\"proveedores\" WHERE idproveedores=" + pk);
            out.println("<div class='alert alert-danger' role='alert'>Proveedor eliminado con éxito!</div>");
        } catch (Exception e) {
            out.println("Error PSQL" + e);
        }
    }
%>
