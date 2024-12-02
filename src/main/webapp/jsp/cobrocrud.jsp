<%@ page import="java.sql.PreparedStatement" %>

<%@ include file="conexion.jsp" %>
<%    HttpSession sesion = request.getSession();
    String userId = (String) sesion.getAttribute("id"); // Obtener ID del usuario logueado
    String userName = (String) sesion.getAttribute("user"); // Obtener nombre del usuario logueado
    String listarParam = request.getParameter("listar");

    if ("listar".equals(listarParam)) {
        // Código para listar cobros
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT "
                    + "c.idcobros AS REF, "
                    + "c.fecha_cobro AS FECHA, "
                    + "COALESCE(h.hues_nombre, 'N/A') AS HUESPED, "
                    + "COALESCE(f.numerofac, 'N/A') AS NRO_FACTURA, "
                    + "COALESCE(c.nro_transaccion, 'N/A') AS NRO_TRANSACCION, "
                    + "COALESCE(c.monto, 0) AS MONTO, " // Cambiado a 0 para el campo numérico
                    + "COALESCE(mp.descripcion, 'N/A') AS METODO_DE_PAGO, "
                    + "COALESCE(tp.tipo_descripcion, 'N/A') AS TIPO_PAGO, "
                    + "COALESCE(b.ban_descripcion, 'N/A') AS BANCO, "
                    + "COALESCE(t.tar_descripcion, 'N/A') AS TIPO_TARJETA, "
                    + "COALESCE(c.estado, 'N/A') AS ESTADO, "
                    + "COALESCE(u.usu_nombre, 'N/A') AS USUARIO "
                    + "FROM "
                    + "\"HotelRum\".cobros c "
                    + "LEFT JOIN \"HotelRum\".factura f ON c.factura_idfactura = f.idfactura "
                    + "LEFT JOIN \"HotelRum\".metodo_pago mp ON c.metodo_pago_idmetodo_pago = mp.idmetodo_pago "
                    + "LEFT JOIN \"HotelRum\".bancos b ON c.bancos_idbancos = b.idbancos "
                    + "LEFT JOIN \"HotelRum\".tipo_pago tp ON c.tipo_pago_id_tipo_pago = tp.idtipo_pago "
                    + "LEFT JOIN \"HotelRum\".usuarios u ON c.usuarios_idusuarios = u.idusuarios "
                    + "LEFT JOIN \"HotelRum\".huespedes h ON c.huespedes_idhuespedes = h.idhuespedes "
                    + "LEFT JOIN \"HotelRum\".tipo_tarjeta t ON c.tipo_tarjeta_idtipo_tarjeta = t.idtipo_tarjeta "
                    + "WHERE c.estado = 'Cobrado' "
                    + "ORDER BY c.idcobros ASC;");

            while (rs.next()) {
                // Aquí procesas cada fila de resultados
%>
<tr>
    <td><%= rs.getString("REF")%></td>
    <td><%= rs.getString("FECHA")%></td>
    <td><%= rs.getString("HUESPED")%></td>
    <td><%= rs.getString("NRO_FACTURA")%></td>
    <td><%= rs.getString("NRO_TRANSACCION")%></td>
    <td><%= rs.getBigDecimal("MONTO")%></td>
    <td><%= rs.getString("METODO_DE_PAGO")%></td>
    <td><%= rs.getString("TIPO_PAGO")%></td>
    <td><%= rs.getString("BANCO")%></td>
    <td><%= rs.getString("TIPO_TARJETA")%></td>
    <td><%= rs.getString("ESTADO")%></td>
    <td><%= rs.getString("USUARIO")%></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error en la consulta SQL: " + e.getMessage());
    }
} else if ("listarPendiente".equals(listarParam)) {
    // Código para listar cobros
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT "
                + "c.idcobros AS REF, "
                + "c.fecha_cobro AS FECHA, "
                + "COALESCE(h.hues_nombre, 'N/A') AS HUESPED, "
                + "COALESCE(f.numerofac, 'N/A') AS NRO_FACTURA, "
                + "COALESCE(c.nro_transaccion, 'N/A') AS NRO_TRANSACCION, "
                + "COALESCE(c.monto, 0) AS MONTO, " // Cambiado a 0 para el campo numérico
                + "COALESCE(mp.descripcion, 'N/A') AS METODO_DE_PAGO, "
                + "COALESCE(tp.tipo_descripcion, 'N/A') AS TIPO_PAGO, "
                + "COALESCE(b.ban_descripcion, 'N/A') AS BANCO, "
                + "COALESCE(t.tar_descripcion, 'N/A') AS TIPO_TARJETA, "
                + "COALESCE(c.estado, 'N/A') AS ESTADO, "
                + "COALESCE(u.usu_nombre, 'N/A') AS USUARIO "
                + "FROM "
                + "\"HotelRum\".cobros c "
                + "LEFT JOIN \"HotelRum\".factura f ON c.factura_idfactura = f.idfactura "
                + "LEFT JOIN \"HotelRum\".metodo_pago mp ON c.metodo_pago_idmetodo_pago = mp.idmetodo_pago "
                + "LEFT JOIN \"HotelRum\".bancos b ON c.bancos_idbancos = b.idbancos "
                + "LEFT JOIN \"HotelRum\".tipo_pago tp ON c.tipo_pago_id_tipo_pago = tp.idtipo_pago "
                + "LEFT JOIN \"HotelRum\".usuarios u ON c.usuarios_idusuarios = u.idusuarios "
                + "LEFT JOIN \"HotelRum\".huespedes h ON c.huespedes_idhuespedes = h.idhuespedes "
                + "LEFT JOIN \"HotelRum\".tipo_tarjeta t ON c.tipo_tarjeta_idtipo_tarjeta = t.idtipo_tarjeta "
                + "WHERE c.estado = 'Pendiente' "
                + "ORDER BY c.idcobros ASC;");

        while (rs.next()) {
            // Aquí procesas cada fila de resultados
%>
<tr>
    <td><%= rs.getString("REF")%></td>
    <td><%= rs.getString("FECHA")%></td>
    <td><%= rs.getString("HUESPED")%></td>
    <td><%= rs.getString("NRO_FACTURA")%></td>
    <td><%= rs.getString("NRO_TRANSACCION")%></td>
    <td><%= rs.getBigDecimal("MONTO")%></td>
    <td><%= rs.getString("METODO_DE_PAGO")%></td>
    <td><%= rs.getString("TIPO_PAGO")%></td>
    <td><%= rs.getString("BANCO")%></td>
    <td><%= rs.getString("TIPO_TARJETA")%></td>
    <td><%= rs.getString("ESTADO")%></td>
    <td><%= rs.getString("USUARIO")%></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error en la consulta SQL: " + e.getMessage());
    }
} else if ("insertarCobro".equals(listarParam)) {
    // Obtener los parámetros
    String idfactura = request.getParameter("idfactura");
    String metodoPago = request.getParameter("metodoPago");
    String monto = request.getParameter("monto");
    String banco = request.getParameter("banco");
    String tipoTarjeta = request.getParameter("tipoTarjeta");
    String nroTransaccion = request.getParameter("nro_transaccion");

    try {
        Statement st = conn.createStatement();
        // Inserta en la tabla cobros
        String sql = "INSERT INTO \"HotelRum\".\"cobros\" (factura_idfactura, metodo_pago_idmetodo_pago, monto, bancos_idbancos, tipo_tarjeta_idtipo_tarjeta, nro_transaccion) VALUES ("
                + idfactura + ", " + metodoPago + ", " + monto + ", " + banco + ", " + tipoTarjeta + ", '" + nroTransaccion + "')";
        st.executeUpdate(sql);
        out.println("Pago registrado correctamente.");
    } catch (Exception e) {
        out.println("Error al insertar en cobros: " + e);
    }
} else if ("listarcobro".equals(listarParam)) {
    String reservationId = request.getParameter("reservationId");

    if (reservationId != null && !reservationId.isEmpty()) {
        PreparedStatement pstmtDetalles = null;
        ResultSet rs = null;

        try {
            String queryDetalles
                    = "SELECT "
                    + "dt.idfactura_has_servicio, "
                    + "p.art_nombre, "
                    + "dt.cantidad, "
                    + "dt.precio, "
                    + "f.idfactura "
                    + "FROM \"HotelRum\".\"factura_has_servicio\" dt "
                    + "JOIN \"HotelRum\".\"articulos\" p ON dt.articulos_idarticulos = p.idarticulos "
                    + "JOIN \"HotelRum\".\"factura\" f ON dt.factura_idfactura = f.idfactura "
                    + "LEFT JOIN \"HotelRum\".\"cobros\" c ON f.idfactura = c.factura_idfactura "
                    + "WHERE f.reservas_idreservas = ? "
                    + "AND f.estado = 'PendienteCobro'";
            pstmtDetalles = conn.prepareStatement(queryDetalles);
            pstmtDetalles.setInt(1, Integer.parseInt(reservationId));

            rs = pstmtDetalles.executeQuery();

            int resultCount = 0;

            while (rs.next()) {
                resultCount++;

                String artNombre = rs.getString("art_nombre");
                int cantidad = rs.getInt("cantidad");
                int precio = rs.getInt("precio");
                int calcular = cantidad * precio;
%>

<tr>
    <td><%= artNombre%></td>
    <td><%= cantidad%></td>
    <td><%= precio%></td>
    <td><%= calcular%></td>
</tr>

<%
                }

                if (resultCount == 0) {
                    out.println("<tr><td colspan='4'>No hay detalles disponibles para esta reserva.</td></tr>");
                }
            } catch (SQLException | NumberFormatException e) {
                System.err.println("Error al obtener detalles de cobro: " + e.getMessage());
                out.println("<tr><td colspan='4'>Error al recuperar detalles: " + e.getMessage() + "</td></tr>");
            } finally {
                // Cerrar recursos
                try {
                    if (rs != null) {
                        rs.close();
                    }
                    if (pstmtDetalles != null) {
                        pstmtDetalles.close();
                    }
                } catch (SQLException e) {
                    System.err.println("Error al cerrar recursos: " + e.getMessage());
                }
            }
        } else {
            // Mensaje si no se proporcionó ID de reserva
            out.println("<tr><td colspan='4'>No se proporcionó el ID de reserva.</td></tr>");
            System.out.println("No se recibió ID de reserva en la solicitud");
        }
    }
    if (request.getParameter("listar").equals("listarsuma")) {
        String reservationId = request.getParameter("reservationId");

        PreparedStatement pstmtDetalles = null;
        ResultSet rs = null;

        try {
            String querySuma = "SELECT "
                    + "SUM(dt.cantidad * dt.precio) as total_servicios "
                    + "FROM \"HotelRum\".\"factura_has_servicio\" dt "
                    + "JOIN \"HotelRum\".\"factura\" f ON dt.factura_idfactura = f.idfactura "
                    + "WHERE f.reservas_idreservas = ? "
                    + "AND f.estado = 'PendienteCobro'";

            pstmtDetalles = conn.prepareStatement(querySuma);
            pstmtDetalles.setInt(1, Integer.parseInt(reservationId));

            rs = pstmtDetalles.executeQuery();

            if (rs.next()) {
                double totalServicios = rs.getDouble("total_servicios");
                out.println(totalServicios);

                // Depuración
                System.out.println("Total de servicios para reserva " + reservationId + ": " + totalServicios);
            } else {
                out.println("0");
            }
        } catch (SQLException e) {
            System.err.println("Error SQL al calcular suma de servicios: " + e.getMessage());
            out.println("0");
        } catch (NumberFormatException e) {
            System.err.println("ID de reserva no es un número válido: " + reservationId);
            out.println("0");
        } finally {
            // Cerrar recursos
            try {
                if (rs != null) {
                    rs.close();
                }
                if (pstmtDetalles != null) {
                    pstmtDetalles.close();
                }
            } catch (SQLException e) {
                System.err.println("Error al cerrar recursos: " + e.getMessage());
            }
        }
    } else if (request.getParameter("listar").equals("finalcompra")) {

        try {
            Statement st = null;
            ResultSet pk = null;
            st = conn.createStatement();
            pk = st.executeQuery("SELECT idcobros FROM \"HotelRum\".\"cobros\" where estado='Pendiente';");
            pk.next();
            st.executeUpdate("update \"HotelRum\".\"cobros\" set estado='Finalizado', total=" + request.getParameter("monto") + " where idcobros=" + pk.getString(1) + "");
            //out.println("<div class='alert alert-success' role='alert'>  Datos modificados con exitos!</div>");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    }
%>