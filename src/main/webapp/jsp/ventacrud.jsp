<%@ page import="java.sql.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="conexion.jsp" %>

<%    HttpSession sesion = request.getSession();
    String userId = (String) sesion.getAttribute("id"); // Obtener ID del usuario logueado
    String userName = (String) sesion.getAttribute("user"); // Obtener nombre del usuario logueado

    if (request.getParameter("listar").equals("cargar")) { // campo cargar
        String fechafac = request.getParameter("fechafac");
        String codarticulos = request.getParameter("idarticulos");
        String cantidad = request.getParameter("cantidad");
        String art_precio_venta = request.getParameter("art_precio_venta");
        String codreservas = request.getParameter("codreservas");

        try {
            // Convertir la fecha al formato correcto
            SimpleDateFormat formatoEntrada = new SimpleDateFormat("dd-MM-yyyy");
            SimpleDateFormat formatoSQL = new SimpleDateFormat("yyyy-MM-dd");
            String fechaFormateada = formatoSQL.format(formatoEntrada.parse(fechafac));

            // Validaciones iniciales
            if (codarticulos == null || codarticulos.isEmpty() || "Seleccionar".equals(codarticulos)) {
                out.println("<div class='alert alert-warning' role='alert'>Seleccione un artículo válido</div>");
                return;
            }

            // Variables para timbrado y movimiento de caja
            int idTimbrado = 0;
            int idMovimiento = 0;

            // Buscar timbrado activo vigente
            PreparedStatement pstmTimbrado = conn.prepareStatement(
                    "SELECT idtimbrado FROM \"HotelRum\".\"timbrado\" "
                    + "WHERE estado = 'Activo' AND current_date BETWEEN fecha_inicio AND fecha_fin LIMIT 1"
            );
            ResultSet rsTimbrado = pstmTimbrado.executeQuery();

            if (rsTimbrado.next()) {
                idTimbrado = rsTimbrado.getInt("idtimbrado");
            } else {
                out.println("<div class='alert alert-danger' role='alert'>No hay timbrado activo vigente</div>");
                return;
            }

            // Buscar movimiento de caja abierto
            PreparedStatement pstmMovimiento = conn.prepareStatement(
                    "SELECT idmovimiento_caja FROM \"HotelRum\".\"movimiento_caja\" "
                    + "WHERE usuarios_idusuarios = ? AND estado = 'Abierto' ORDER BY fecha_apertura DESC LIMIT 1"
            );
            pstmMovimiento.setInt(1, Integer.parseInt(userId));
            ResultSet rsMovimiento = pstmMovimiento.executeQuery();

            if (rsMovimiento.next()) {
                idMovimiento = rsMovimiento.getInt("idmovimiento_caja");
            } else {
                out.println("<div class='alert alert-danger' role='alert'>No hay movimiento de caja abierto</div>");
                return;
            }

            // Verificar factura existente
            PreparedStatement pstmVerificarFactura = conn.prepareStatement(
                    "SELECT idfactura FROM \"HotelRum\".\"factura\" "
                    + "WHERE reservas_idreservas = ? AND estado = 'Pendiente' AND usuarios_idusuarios = ?"
            );
            pstmVerificarFactura.setInt(1, Integer.parseInt(codreservas));
            pstmVerificarFactura.setInt(2, Integer.parseInt(userId));
            ResultSet rsFactura = pstmVerificarFactura.executeQuery();

            int idFactura;
            if (rsFactura.next()) {
                // Si ya existe una factura pendiente, obtener su ID
                idFactura = rsFactura.getInt("idfactura");
            } else {
                // Crear nueva factura con timbrado y movimiento
                PreparedStatement pstmInsertFactura = conn.prepareStatement(
                        "INSERT INTO \"HotelRum\".\"factura\" "
                        + "(fechafac, reservas_idreservas, usuarios_idusuarios, estado, "
                        + "timbrado_idtimbrado, movimiento_caja_idmovimiento) "
                        + "VALUES (?, ?, ?, 'Pendiente', ?, ?) RETURNING idfactura"
                );
                pstmInsertFactura.setDate(1, Date.valueOf(fechaFormateada));
                pstmInsertFactura.setInt(2, Integer.parseInt(codreservas));
                pstmInsertFactura.setInt(3, Integer.parseInt(userId));
                pstmInsertFactura.setInt(4, idTimbrado);
                pstmInsertFactura.setInt(5, idMovimiento);

                ResultSet rsNuevaFactura = pstmInsertFactura.executeQuery();

                if (rsNuevaFactura.next()) {
                    idFactura = rsNuevaFactura.getInt("idfactura");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>Error al crear la factura.</div>");
                    return;
                }
            }

            // Insertar detalle de factura
            PreparedStatement pstmInsertDetalle = conn.prepareStatement(
                    "INSERT INTO \"HotelRum\".\"factura_has_servicio\" "
                    + "(factura_idfactura, articulos_idarticulos, cantidad, precio) "
                    + "VALUES (?, ?, ?, ?)"
            );
            pstmInsertDetalle.setInt(1, idFactura);
            pstmInsertDetalle.setInt(2, Integer.parseInt(codarticulos));
            pstmInsertDetalle.setInt(3, Integer.parseInt(cantidad));
            pstmInsertDetalle.setInt(4, Integer.parseInt(art_precio_venta));

            pstmInsertDetalle.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'> Detalle agregado exitosamente</div>");

        } catch (SQLException e) {
            System.err.println("Error SQL: " + e.getMessage());
            out.println("<div class='alert alert-danger' role='alert'>Error en la base de datos: " + e.getMessage() + "</div>");
        } catch (NumberFormatException e) {
            System.err.println("Error de formato numérico: " + e.getMessage());
            out.println("<div class='alert alert-danger' role='alert'>Error en los datos numéricos</div>");
        } catch (Exception e) {
            System.err.println("Error general: " + e.getMessage());
            out.println("<div class='alert alert-danger' role='alert'>Error inesperado: " + e.getMessage() + "</div>");
        }
    } else if (request.getParameter("listar").equals("listar")) {
        String reservationId = request.getParameter("reservationId");

        // Verificación adicional de impresión para depuración
        System.out.println("ReservationId recibido: " + reservationId);

        if (reservationId != null && !reservationId.isEmpty()) {
            PreparedStatement pstmtDetalles = null;
            ResultSet rs = null;

            try {
                // Consulta SQL más detallada
                String queryDetalles = "SELECT "
                        + "dt.idfactura_has_servicio, "
                        + "p.art_nombre, "
                        + "dt.cantidad, "
                        + "dt.precio, "
                        + "f.idfactura "
                        + "FROM \"HotelRum\".\"factura_has_servicio\" dt "
                        + "JOIN \"HotelRum\".\"articulos\" p ON dt.articulos_idarticulos = p.idarticulos "
                        + "JOIN \"HotelRum\".\"factura\" f ON dt.factura_idfactura = f.idfactura "
                        + "WHERE f.reservas_idreservas = ? AND f.estado='Pendiente' AND f.usuarios_idusuarios = ?"; // Filtrar por ID de usuario

// Preparar la declaración
                pstmtDetalles = conn.prepareStatement(queryDetalles);
                pstmtDetalles.setInt(1, Integer.parseInt(reservationId)); // Convertir a entero
                pstmtDetalles.setInt(2, Integer.parseInt(userId)); // Filtrar por ID de usuario

                // Ejecutar la consulta
                rs = pstmtDetalles.executeQuery();

                // Contador para verificar si hay resultados
                int resultCount = 0;

                // Iterar sobre los resultados
                while (rs.next()) {
                    resultCount++;

                    // Obtener valores
                    String artNombre = rs.getString("art_nombre");
                    int cantidad = rs.getInt("cantidad");
                    int precio = rs.getInt("precio");
                    int calcular = cantidad * precio;

                    // Impresión de depuración
                    System.out.println("Detalle encontrado - Artículo: " + artNombre
                            + ", Cantidad: " + cantidad
                            + ", Precio: " + precio);
%>
<tr>
    <td><%= artNombre%></td>
    <td><%= cantidad%></td>
    <td><%= precio%></td>
    <td><%= calcular%></td>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i></td>
</tr>
<%
            }

            // Verificar si no se encontraron resultados
            if (resultCount == 0) {
                out.println("<tr><td colspan='4'>No hay detalles disponibles para esta reserva.</td></tr>");

                // Verificación adicional para entender por qué no hay resultados
                System.out.println("No se encontraron detalles para la reserva con ID: " + reservationId);
            }

        } catch (SQLException e) {
            // Manejo de errores SQL más detallado
            System.err.println("Error SQL al obtener detalles de cobro: " + e.getMessage());
            out.println("<tr><td colspan='4'>Error al recuperar detalles: " + e.getMessage() + "</td></tr>");
        } catch (NumberFormatException e) {
            // Manejo de error si el ID de reserva no es un número válido
            System.err.println("ID de reserva no es un número válido: " + reservationId);
            out.println("<tr><td colspan='4'>ID de reserva inválido.</td></tr>");
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
} else if (request.getParameter("listar").equals("listarsuma")) {
    String reservationId = request.getParameter("reservationId");

    PreparedStatement pstmtDetalles = null;
    ResultSet rs = null;

    try {
        String querySuma = "SELECT "
                + "dt.cantidad, "
                + "dt.precio "
                + "FROM \"HotelRum\".\"factura_has_servicio\" dt "
                + "JOIN \"HotelRum\".\"factura\" f ON dt.factura_idfactura = f.idfactura "
                + "WHERE f.reservas_idreservas = ? "
                + "AND f.estado = 'Pendiente' "
                + "AND f.usuarios_idusuarios = ?"; // Filtrar por ID de usuario

        pstmtDetalles = conn.prepareStatement(querySuma);
        pstmtDetalles.setInt(1, Integer.parseInt(reservationId)); // Convertir a entero
        pstmtDetalles.setInt(2, Integer.parseInt(userId)); // Filtrar por ID de usuario

        rs = pstmtDetalles.executeQuery();

        int sumador = 0;

        while (rs.next()) {
            int cantidad = rs.getInt("cantidad");
            int precio = rs.getInt("precio");
            int calcular = cantidad * precio;
            sumador += calcular;
        }

        out.println(sumador);

        // Verificación de depuración
        System.out.println("Total calculado para reserva " + reservationId + ": " + sumador);

    } catch (SQLException e) {
        // Manejo de errores SQL más detallado
        System.err.println("Error SQL al calcular suma de cobro: " + e.getMessage());
        out.println("0");
    } catch (NumberFormatException e) {
        // Manejo de error si el ID de reserva no es un número válido
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
} else if (request.getParameter("listar").equals("elimregcompra")) {

    String pk = request.getParameter("pkd");
    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("DELETE FROM \"HotelRum\".\"factura_has_servicio\" WHERE idfactura_has_servicio=" + pk + "");
        //out.println("<div class='alert alert-success' role='alert'>  Datos eliminados con exitos!</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("cancelcompra")) {
    String reservationId = request.getParameter("reservationId"); // Obtener el ID de reserva

    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();

        // Selecciona la factura pendiente para el usuario actual y la reserva específica
        pk = st.executeQuery("SELECT idfactura FROM \"HotelRum\".\"factura\" WHERE estado='Pendiente' AND reservas_idreservas=" + reservationId + " AND usuarios_idusuarios=" + userId + ";");

        if (pk.next()) {
            // Actualiza el estado de la factura a 'Cancelado'
            st.executeUpdate("UPDATE \"HotelRum\".\"factura\" SET estado='Cancelado' WHERE idfactura=" + pk.getString(1) + ";");
            out.println("Factura cancelada con éxito.");
        } else {
            out.println("No hay facturas pendientes para cancelar.");
        }
    } catch (Exception e) {
        out.println("error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("finalcompra")) {
    String codtipo_pago = request.getParameter("codtipo_pago");
    String reservationId = request.getParameter("reservationId");
    String total = request.getParameter("total");

    try {
        // Iniciar transacción
        conn.setAutoCommit(false);

        // 1. Actualizar factura
        PreparedStatement pstmUpdateFactura = conn.prepareStatement(
            "UPDATE \"HotelRum\".\"factura\" "
            + "SET estado = CASE "
            + "    WHEN ? = '2' THEN 'PendienteCobro' " // '2' es el ID para 'Despues'
            + "    ELSE 'Finalizado' "
            + "END, "
            + "tipo_pago_idtipo_pago = ?, "
            + "total = ? "
            + "WHERE estado = 'Pendiente' "
            + "AND reservas_idreservas = ? "
            + "AND usuarios_idusuarios = ? RETURNING idfactura"
        );
        pstmUpdateFactura.setString(1, codtipo_pago); // Aquí se establece el tipo de pago
        pstmUpdateFactura.setInt(2, Integer.parseInt(codtipo_pago));
        pstmUpdateFactura.setDouble(3, Double.parseDouble(total));
        pstmUpdateFactura.setInt(4, Integer.parseInt(reservationId));
        pstmUpdateFactura.setInt(5, Integer.parseInt(userId));

        ResultSet rsFactura = pstmUpdateFactura.executeQuery();
        int idFactura = 0;
        if (rsFactura.next()) {
            idFactura = rsFactura.getInt("idfactura");
        }

        // 2. Obtener el movimiento de caja actual
        PreparedStatement pstmMovimiento = conn.prepareStatement(
                "SELECT idmovimiento_caja FROM \"HotelRum\".\"movimiento_caja\" "
                + "WHERE usuarios_idusuarios = ? AND estado = 'Abierto' "
                + "ORDER BY fecha_apertura DESC LIMIT 1"
        );
        pstmMovimiento.setInt(1, Integer.parseInt(userId));
        ResultSet rsMovimiento = pstmMovimiento.executeQuery();
        int idMovimientoCaja = 0;
        if (rsMovimiento.next()) {
            idMovimientoCaja = rsMovimiento.getInt("idmovimiento_caja");
        }

        // 3. Insertar en movimiento_detalle
        PreparedStatement pstmInsertMovimientoDetalle = conn.prepareStatement(
                "INSERT INTO \"HotelRum\".\"movimiento_detalle\" "
                + "(movimiento_caja_idmovimiento_caja, tipo_movimiento, monto, factura_idfactura) "
                + "VALUES (?, 'INGRESO', ?, ?)"
        );
        pstmInsertMovimientoDetalle.setInt(1, idMovimientoCaja);
        pstmInsertMovimientoDetalle.setDouble(2, Double.parseDouble(total));
        pstmInsertMovimientoDetalle.setInt(3, idFactura);
        pstmInsertMovimientoDetalle.executeUpdate();

        // Confirmar transacción
        conn.commit();

        out.println("Venta finalizada con éxito");

    } catch (SQLException e) {
        // Rollback en caso de error
        conn.rollback();
        System.err.println("Error al finalizar la compra: " + e.getMessage());
        out.println("Error al finalizar la compra: " + e.getMessage());
    } finally {
        // Restaurar autocommit
        conn.setAutoCommit(true);
    }
} else if (request.getParameter("listar").equals("listarcompras")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery(
                "SELECT f.idfactura, to_char(f.fechafac, 'dd-mm-YYYY'), "
                + "h.hues_nombre || ' ' || h.hues_apellido as nombre_completo, f.total, u.usu_nombre as usuario "
                + "FROM \"HotelRum\".\"factura\" f "
                + "JOIN \"HotelRum\".\"reservas\" r ON f.reservas_idreservas = r.idreservas "
                + "JOIN \"HotelRum\".\"huespedes\" h ON r.huespedes_idhuespedes = h.idhuespedes "
                + "JOIN \"HotelRum\".\"usuarios\" u ON f.usuarios_idusuarios = u.idusuarios "
                + "WHERE f.estado = 'Finalizado' order by idfactura;"
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
        <i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" title="Anular Factura" onclick="$('#pkanul').val('<%= rs.getString(1)%>')" style="cursor: pointer;"></i>
        &nbsp;&nbsp;  
        <a href="reportesdetalles/factura.jsp?fac_GET=<%= rs.getString(1)%>" title="Imprimir Factura" style="color: black; cursor: pointer;">
            <i class="fas fa-eye"></i>
        </a>
    </td>

</tr>
<%
            }
        } catch (Exception e) {
            out.println("error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("anularcompras")) {
        try {
            // Obtener el ID de la factura a anular
            String idFactura = request.getParameter("idpkcompra");

            // Crear una declaración SQL
            Statement st = conn.createStatement();

            // Actualizar el estado de la factura a 'Anulado'
            st.executeUpdate("UPDATE \"HotelRum\".\"factura\" SET estado='Anulado' WHERE idfactura=" + idFactura);

            // Obtener los detalles de la factura para actualizar el inventario
            ResultSet rsDetalles = st.executeQuery(
                    "SELECT articulos_idarticulos, cantidad, precio "
                    + "FROM \"HotelRum\".\"factura_has_servicio\" WHERE factura_idfactura=" + idFactura);

            while (rsDetalles.next()) {
                int idArticulo = rsDetalles.getInt("articulos_idarticulos");
                int cantidad = rsDetalles.getInt("cantidad");
                double precio = rsDetalles.getDouble("precio");

                // Insertar en la tabla inventario
                st.executeUpdate(
                        "INSERT INTO \"HotelRum\".\"inventario\" (tipo_movimiento, cantidad, precio_unitario, articulos_idarticulos, factura_idfactura, usuarios_idusuarios) "
                        + "VALUES ('VENTA ANULADO', " + cantidad + ", " + precio + ", " + idArticulo + ", " + idFactura + ", " + sesion.getAttribute("id") + ")");
            }
            out.print("<script>llenadocompras();</script>");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    }

%>
