<%@ include file="conexion.jsp" %>
<%    HttpSession sesion = request.getSession();
    if (request.getParameter("listar").equals("cargar")) {
        // Capture parameters
        String codarticulos = request.getParameter("codarticulos");
        String codtipo_pago = request.getParameter("codtipo_pago");
        String fechacompra = request.getParameter("fechacompra");
        String codproveedores = request.getParameter("codproveedores");
        String cantidad = request.getParameter("cantidad");
        String art_precio_compra = request.getParameter("art_precio_compra");

        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idcompras FROM \"HotelRum\".\"compras\" WHERE estado = 'Pendiente';");

            if (rs.next()) {
                // Update existing purchase
                st.executeUpdate("INSERT INTO \"HotelRum\".\"detalle_compras\" (compras_idcompras, articulos_idarticulos, cantidad, precio_unitario) VALUES ('" + rs.getString(1) + "','" + codarticulos + "','" + cantidad + "','" + art_precio_compra + "')");
            } else {
                // Create a new purchase
                // Aquí no se incluye el tipo de pago en la inserción inicial
                st.executeUpdate("INSERT INTO \"HotelRum\".\"compras\" (fechacompra, proveedores_idproveedores, usuarios_idusuarios) VALUES ('" + fechacompra + "','" + codproveedores + "','" + sesion.getAttribute("id") + "')");
                ResultSet pk = st.executeQuery("SELECT idcompras FROM \"HotelRum\".\"compras\" WHERE estado='Pendiente';");
                pk.next();
                st.executeUpdate("INSERT INTO \"HotelRum\".\"detalle_compras\" (compras_idcompras, articulos_idarticulos, cantidad, precio_unitario) VALUES ('" + pk.getString(1) + "','" + codarticulos + "','" + cantidad + "','" + art_precio_compra + "')");
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("listar")) {
    try {
        Statement st = conn.createStatement();
        ResultSet pk = st.executeQuery("SELECT idcompras FROM \"HotelRum\".\"compras\" WHERE estado='Pendiente';");
        
        // Verificar si hay compras pendientes
        if (!pk.next()) {
            // No hay compras pendientes, no imprimir nada
            out.println("<tr><td colspan='5'>No hay detalles disponibles para esta compra.</td></tr>");
            out.println("0"); // Enviar 0 para el total
            return;
        }
        
        // Obtener el ID de la compra pendiente
        String idCompraPendiente = pk.getString(1);
        
        // Consultar los detalles de la compra
        ResultSet rs = st.executeQuery(
            "SELECT dt.iddetallecompras, " +
            "a.art_nombre, " +
            "dt.cantidad, " +
            "dt.precio_unitario, " +
            "(dt.cantidad * dt.precio_unitario) AS total " +
            "FROM \"HotelRum\".\"detalle_compras\" dt " +
            "JOIN \"HotelRum\".\"articulos\" a ON dt.articulos_idarticulos = a.idarticulos " +
            "WHERE dt.compras_idcompras='" + idCompraPendiente + "'"
        );

        // Variable para rastrear si hay resultados
        boolean hayResultados = false;

        // Iterar sobre los resultados
        while (rs.next()) {
            hayResultados = true;
            
            // Obtener datos de cada detalle
            int idDetalleCompra = rs.getInt("iddetallecompras");
            String nombreArticulo = rs.getString("art_nombre");
            int cantidad = rs.getInt("cantidad");
            int precioUnitario = rs.getInt("precio_unitario");
            int totalLinea = rs.getInt("total");
%>
<tr>
    <td>
        <i class="fa fa-trash" 
           data-toggle="modal" 
           data-target="#exampleModal" 
           onclick="$('#pkdel').val(<%= idDetalleCompra %>)">
        </i>
    </td>
    <td><%= nombreArticulo %></td>
    <td><%= cantidad %></td>
    <td><%= precioUnitario %></td>
    <td><%= totalLinea %></td>
</tr>
<%
        }

        // Si no hay resultados, mostrar mensaje
        if (!hayResultados) {
            out.println("<tr><td colspan='5'>No hay detalles disponibles para esta compra.</td></tr>");
        }

    } catch (SQLException e) {
        // Manejo de errores de base de datos
        out.println("<tr><td colspan='5'>Error al cargar los detalles: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    } catch (Exception e) {
        // Manejo de otros errores
        out.println("<tr><td colspan='5'>Error inesperado: " + e.getMessage() + "</td></tr>");
        e.printStackTrace();
    }
} else if (request.getParameter("listar").equals("listarsuma")) {
    try {
        Statement st = conn.createStatement();
        ResultSet pk = st.executeQuery("SELECT idcompras FROM \"HotelRum\".\"compras\" WHERE estado='Pendiente';");
        
        // Verifica si hay compras pendientes
        if (!pk.next()) {
            out.println("0"); // Si no hay compras, retorna 0
            return; // Asegúrate de salir de la función
        }

        // Obtener el ID de la compra pendiente
        String idCompraPendiente = pk.getString(1);
        
        // Ahora consulta los detalles de la compra
        ResultSet rs = st.executeQuery("SELECT dt.cantidad, dt.precio_unitario FROM \"HotelRum\".\"detalle_compras\" dt WHERE dt.compras_idcompras='" + idCompraPendiente + "'");

        int sumador = 0;
        while (rs.next()) {
            int cantidad = rs.getInt("cantidad");
            int precio_unitario = rs.getInt("precio_unitario");
            sumador += cantidad * precio_unitario;
        }
        out.println(sumador); // Imprime la suma total
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("elimregcompra")) {
    String pk = request.getParameter("pkd");
    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM \"HotelRum\".\"detalle_compras\" WHERE iddetallecompras=" + pk + "");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("cancelcompra")) {
    try {
        Statement st = conn.createStatement();
        ResultSet pk = st.executeQuery("SELECT idcompras FROM \"HotelRum\".\"compras\" WHERE estado='Pendiente';");
        pk.next();
        st.executeUpdate("UPDATE \"HotelRum\".\"compras\" SET estado='Cancelado' WHERE idcompras=" + pk.getString(1) + "");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter(
        "listar").equals("finalcompra")) {
    try {
        Statement st = conn.createStatement();
        ResultSet pk = st.executeQuery("SELECT idcompras FROM \"HotelRum\".\"compras\" WHERE estado='Pendiente';");
        pk.next();
        // Asegúrate de incluir codtipo_pago en la actualización
        st.executeUpdate("UPDATE \"HotelRum\".\"compras\" SET estado='Finalizado', total=" + request.getParameter("total") + ", tipo_pago_idtipo_pago=" + request.getParameter("codtipo_pago") + " WHERE idcompras=" + pk.getString(1));
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter(
        "listar").equals("listarcompras")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
                "SELECT c.idcompras, "
                + "to_char(c.fechacompra, 'dd-mm-YYYY') AS fecha_compra, "
                + "p.prov_nombre, "
                + "c.total, "
                + "u.usu_nombre, "
                + "tp.tipo_descripcion AS tipo_pago "
                + // Add tipo_pago here
                "FROM \"HotelRum\".\"compras\" c "
                + "JOIN \"HotelRum\".\"proveedores\" p ON c.proveedores_idproveedores = p.idproveedores "
                + "JOIN \"HotelRum\".\"usuarios\" u ON c.usuarios_idusuarios = u.idusuarios "
                + "JOIN \"HotelRum\".\"tipo_pago\" tp ON c.tipo_pago_idtipo_pago = tp.idtipo_pago "
                + // Join tipo_pago
                "WHERE c.estado = 'Finalizado' "
                + "ORDER BY c.idcompras;"
        );

        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td><%= rs.getString(3)%></td>
    <td><%= rs.getString(4)%></td>
    <% if (sesion.getAttribute("rol").equals("Administrador")) {%>
    <td><%= rs.getString(5)%></td>
    <% }%>
    <td>
        <i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" title="Anular Compra" onclick="$('#pkanul').val('<%= rs.getString(1)%>')" style="cursor: pointer;"></i>
        &nbsp;&nbsp;
        <a href="reportes.jsp?<%= rs.getString(1)%>" title="Imprimir Compra" style="color: black; cursor: pointer;">
            <i class="fa fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } else if (request.getParameter(
            "listar").equals("anularcompras")) {
        try {
            // Obtener el ID de la compra a anular
            String idCompra = request.getParameter("idpkcompra");

            // Crear una declaración SQL para obtener los detalles de la compra
            Statement st = conn.createStatement();

            // Actualizar el estado de la compra a 'Anulado'
            st.executeUpdate("UPDATE \"HotelRum\".\"compras\" SET estado='Anulado' WHERE idcompras=" + idCompra);

            // Obtener los detalles de la compra para registrar el inventario
            ResultSet rsDetalles = st.executeQuery(
                    "SELECT articulos_idarticulos, cantidad, precio_unitario "
                    + "FROM \"HotelRum\".\"detalle_compras\" WHERE compras_idcompras=" + idCompra);

            while (rsDetalles.next()) {
                int idArticulo = rsDetalles.getInt("articulos_idarticulos");
                int cantidad = rsDetalles.getInt("cantidad");
                double precioUnitario = rsDetalles.getDouble("precio_unitario");

                // Insertar en la tabla inventario
                st.executeUpdate(
                        "INSERT INTO \"HotelRum\".\"inventario\" (tipo_movimiento, cantidad, precio_unitario, articulos_idarticulos, compras_idcompras, usuarios_idusuarios) "
                        + "VALUES ('COMPRA ANULADO', " + cantidad + ", " + precioUnitario + ", " + idArticulo + ", " + idCompra + ", " + sesion.getAttribute("id") + ")");
            }
            out.print("<script>llenadocompras();</script>");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    }
%>
