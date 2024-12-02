<%@ include file="conexion.jsp" %>
<%
    HttpSession sesion = request.getSession();
    if (request.getParameter("listar").equals("cargar")) {
        // Capturar parámetros
        String codarticulos = request.getParameter("codarticulos");
        String fechadevolucion = request.getParameter("fechadevolucion");
        String codproveedores = request.getParameter("codproveedores");
        String cantidad = request.getParameter("cantidad");
        String art_precio_compra = request.getParameter("art_precio_compra");
        String motivo = request.getParameter("motivo");  // Añadido motivo

        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT iddevoluciones FROM \"HotelRum\".\"devoluciones\" WHERE estado = 'Pendiente';");

            if (rs.next()) {
                // Actualizar devolución existente
                st.executeUpdate("INSERT INTO \"HotelRum\".\"detalle_devoluciones\" (devoluciones_iddevoluciones, articulos_idarticulos, cantidad, precio_unitario) VALUES ('" + rs.getString(1) + "','" + codarticulos + "','" + cantidad + "','" + art_precio_compra + "')");
            } else {
                // Crear nueva devolución
                st.executeUpdate("INSERT INTO \"HotelRum\".\"devoluciones\" (fechadevolucion, motivo, proveedores_idproveedores, usuarios_idusuarios) VALUES ('" + fechadevolucion + "','" + motivo + "','" + codproveedores + "','" + sesion.getAttribute("id") + "')");
                ResultSet pk = st.executeQuery("SELECT iddevoluciones FROM \"HotelRum\".\"devoluciones\" WHERE estado='Pendiente';");
                pk.next();
                st.executeUpdate("INSERT INTO \"HotelRum\".\"detalle_devoluciones\" (devoluciones_iddevoluciones, articulos_idarticulos, cantidad, precio_unitario) VALUES ('" + pk.getString(1) + "','" + codarticulos + "','" + cantidad + "','" + art_precio_compra + "')");
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("listar")) {
        try {
            Statement st = conn.createStatement();
            ResultSet pk = st.executeQuery("SELECT iddevoluciones FROM \"HotelRum\".\"devoluciones\" WHERE estado='Pendiente';");
            pk.next();
            ResultSet rs = st.executeQuery("SELECT dt.iddetalle_devoluciones, a.art_nombre, dt.cantidad, dt.precio_unitario FROM \"HotelRum\".\"detalle_devoluciones\" dt JOIN \"HotelRum\".\"articulos\" a ON dt.articulos_idarticulos = a.idarticulos WHERE dt.devoluciones_iddevoluciones='" + pk.getString(1) + "'");

            while (rs.next()) {
                int cantidad = rs.getInt("cantidad");
                int precio_unitario = rs.getInt("precio_unitario");
                int calcular = cantidad * precio_unitario;
%>
<tr>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i></td>
    <td><%= rs.getString("art_nombre") %></td>
    <td><%= cantidad %></td>
    <td><%= precio_unitario %></td>
    <td><%= calcular %></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("listarsuma")) {
        try {
            Statement st = conn.createStatement();
            ResultSet pk = st.executeQuery("SELECT iddevoluciones FROM \"HotelRum\".\"devoluciones\" WHERE estado='Pendiente';");
            pk.next();
            ResultSet rs = st.executeQuery("SELECT dt.iddetalle_devoluciones, a.art_nombre, dt.cantidad, dt.precio_unitario FROM \"HotelRum\".\"detalle_devoluciones\" dt JOIN \"HotelRum\".\"articulos\" a ON dt.articulos_idarticulos = a.idarticulos WHERE dt.devoluciones_iddevoluciones='" + pk.getString(1) + "'");

            int sumador = 0;
            while (rs.next()) {
                int cantidad = rs.getInt("cantidad");
                int precio_unitario = rs.getInt("precio_unitario");
                int calcular = cantidad * precio_unitario;
                sumador += calcular;
            }
            out.println(sumador);
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("elimregdevolucion")) {
        String pk = request.getParameter("pkd");
        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM \"HotelRum\".\"detalle_devoluciones\" WHERE iddetalle_devoluciones=" + pk + "");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("canceldevolucion")) {
        try {
            Statement st = conn.createStatement();
            ResultSet pk = st.executeQuery("SELECT iddevoluciones FROM \"HotelRum\".\"devoluciones\" WHERE estado='Pendiente';");
            pk.next();
            st.executeUpdate("UPDATE \"HotelRum\".\"devoluciones\" SET estado='Cancelado' WHERE iddevoluciones=" + pk.getString(1) + "");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("finaldevolucion")) {
        try {
            Statement st = conn.createStatement();
            ResultSet pk = st.executeQuery("SELECT iddevoluciones FROM \"HotelRum\".\"devoluciones\" WHERE estado='Pendiente';");
            pk.next();
            st.executeUpdate("UPDATE \"HotelRum\".\"devoluciones\" SET estado='Finalizado', total=" + request.getParameter("total") + " WHERE iddevoluciones=" + pk.getString(1));
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("listardevoluciones")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(
                "SELECT d.iddevoluciones, to_char(d.fechadevolucion, 'dd-mm-YYYY'), p.prov_nombre, d.motivo, d.total, u.usu_nombre " +
                "FROM \"HotelRum\".\"devoluciones\" d " +
                "JOIN \"HotelRum\".\"proveedores\" p ON d.proveedores_idproveedores = p.idproveedores " +
                "JOIN \"HotelRum\".\"usuarios\" u ON d.usuarios_idusuarios = u.idusuarios " +
                "WHERE d.estado = 'Finalizado' ORDER BY iddevoluciones;"
            );

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(5) %></td>  <!-- Mostrar el motivo -->
    <% if (sesion.getAttribute("rol").equals("Administrador")){ %>
    <td><%= rs.getString(6) %></td>
    <% } %>
    <td>
    <i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" title="Anular Devolución" onclick="$('#pkanul').val('<%= rs.getString(1) %>')" style="cursor: pointer;"></i>
    &nbsp;&nbsp;
    <a href="reportes.jsp?<%= rs.getString(1) %>" title="Imprimir Devolución" style="color: black; cursor: pointer;">
        <i class="fa fa-eye"></i>
    </a>
</td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } 
else if (request.getParameter("listar").equals("anulardevoluciones")) {
    try {
        // Obtener el ID de la devolución a anular
        String idDevolucion = request.getParameter("idpkdevolucion");

        // Crear una declaración SQL
        Statement st = conn.createStatement();
        
        // Actualizar el estado de la devolución a 'Anulado'
        st.executeUpdate("UPDATE \"HotelRum\".\"devoluciones\" SET estado='Anulado' WHERE iddevoluciones=" + idDevolucion);
        
        // Obtener los detalles de la devolución para actualizar el inventario
        ResultSet rsDetalles = st.executeQuery(
            "SELECT articulos_idarticulos, cantidad, precio_unitario " +
            "FROM \"HotelRum\".\"detalle_devoluciones\" WHERE devoluciones_iddevoluciones=" + idDevolucion);

        while (rsDetalles.next()) {
            int idArticulo = rsDetalles.getInt("articulos_idarticulos");
            int cantidad = rsDetalles.getInt("cantidad");
            double precioUnitario = rsDetalles.getDouble("precio_unitario");

            // Insertar en la tabla inventario
            st.executeUpdate(
                "INSERT INTO \"HotelRum\".\"inventario\" (tipo_movimiento, cantidad, precio_unitario, articulos_idarticulos, devoluciones_iddevoluciones, usuarios_idusuarios) " +
                "VALUES ('DEVOLUCION ANULADO', " + cantidad + ", " + precioUnitario + ", " + idArticulo + ", " + idDevolucion + ", " + sesion.getAttribute("id") + ")");
        }
        out.print("<script>llenadevoluciones();</script>");
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
}

%>