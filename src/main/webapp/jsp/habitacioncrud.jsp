<%@ include file="conexion.jsp" %>

<%    if ("listar".equals(request.getParameter("listar"))) {
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT h.*, p.pi_nombre FROM \"HotelRum\".\"habitaciones\" h "
                + "INNER JOIN \"HotelRum\".\"pisos\" p ON h.pisos_idpisos = p.idpisos "
                + "ORDER BY h.idhabitaciones ASC;")) {
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idhabitaciones")%></td>
    <td><%= rs.getString("habi_nombre")%></td>
    <td><%= rs.getString("habi_descripcion")%></td>
    <td><%= rs.getString("habi_estado")%></td>
    <td><%= rs.getString("habi_precio")%></td>
    <td><%= rs.getString("pi_nombre")%></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarHabitacion('<%= rs.getString("idhabitaciones")%>', '<%= rs.getString("habi_nombre")%>', '<%= rs.getString("habi_descripcion")%>', '<%= rs.getString("habi_estado")%>', '<%= rs.getString("habi_precio")%>', '<%= rs.getString("pi_nombre")%>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarHabitacionModal" onclick="$('#idhabitacion_e').val('<%= rs.getString("idhabitaciones")%>')"></i>
        <a href="reporteVistaIndividual/reporteHabitacion.jsp?hab=<%= rs.getString("idhabitaciones")%>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } else if ("cargar".equals(request.getParameter("listar"))) {
        String descripcion = request.getParameter("habi_descripcion").trim();
        String nombre = request.getParameter("habi_nombre").trim();
        String estado = request.getParameter("habi_estado");
        int precio;

        // Ensure safe parsing of price
        try {
            precio = Integer.parseInt(request.getParameter("habi_precio"));
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>Precio inválido!</div>");
            return;
        }

        String piso = request.getParameter("pisos_idpisos");

        if (!descripcion.isEmpty() && descripcion.matches("^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]+)*$")) {
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"habitaciones\" WHERE habi_nombre = '" + nombre + "'")) {

                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("habitacion_existe");
                } else {
                    // Corrected the INSERT statement
                    st.executeUpdate("INSERT INTO \"HotelRum\".\"habitaciones\" (habi_nombre, habi_descripcion, habi_estado, habi_precio, pisos_idpisos) VALUES('" + nombre + "','" + descripcion + "', '" + estado + "', " + precio + ", " + piso + ")");
                    out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
                }
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            }
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</div>");
        }
    } else if ("modificar".equals(request.getParameter("listar"))) {
        String descripcion = request.getParameter("habi_descripcion").trim();
        String nombre = request.getParameter("habi_nombre").trim();
        String estado = request.getParameter("habi_estado");
        int precio;

        try {
            precio = Integer.parseInt(request.getParameter("habi_precio"));
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>Precio inválido!</div>");
            return;
        }

        String piso = request.getParameter("pisos_idpisos");
        String id = request.getParameter("idhabitaciones");

        if (!descripcion.isEmpty() && descripcion.matches("^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ]+)*$")) {
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT habi_nombre FROM \"HotelRum\".\"habitaciones\" WHERE idhabitaciones='" + id + "'")) {

                rs.next();
                String descripcionOriginal = rs.getString("habi_nombre");

                // Modificación para evitar el error de "ya existe"
                try (ResultSet countRs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"habitaciones\" WHERE habi_nombre = '" + nombre + "' AND idhabitaciones != '" + id + "'")) {
                    countRs.next();
                    int count = countRs.getInt("count");

                    if (count > 0) {
                        out.println("<div class='alert alert-danger' role='alert'>La descripción de la habitación ya existe!</div>");
                    } else {
                        st.executeUpdate("UPDATE \"HotelRum\".\"habitaciones\" SET habi_nombre='" + nombre + "', habi_descripcion='" + descripcion + "', habi_estado='" + estado + "', habi_precio=" + precio + ", pisos_idpisos='" + piso + "' WHERE idhabitaciones='" + id + "'");
                        out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
                    }
                }
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            }
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</div>");
        }
    } else if ("eliminar".equals(request.getParameter("listar"))) {
        String pk = request.getParameter("idpk");
        try (Statement st = conn.createStatement()) {
            st.executeUpdate("DELETE FROM \"HotelRum\".\"habitaciones\" WHERE idhabitaciones=" + pk);
            out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con éxito!</div>");
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } else if ("listarHabitaciones".equals(request.getParameter("listar"))) {
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT h.*, p.pi_nombre FROM \"HotelRum\".\"habitaciones\" h "
                + "INNER JOIN \"HotelRum\".\"pisos\" p ON h.pisos_idpisos = p.idpisos "
                + "ORDER BY p.idpisos, h.idhabitaciones;")) {

            while (rs.next()) {
                String pisoNombre = rs.getString("pi_nombre");
                String habiNombre = rs.getString("habi_nombre");
                String estado = rs.getString("habi_estado");
                String descripcion = rs.getString("habi_descripcion");

                String statusClass = "";
                String iconClass = "";
                boolean isClickable = false;

                switch (estado != null ? estado.toLowerCase() : "") {
                    case "ocupada":
                        statusClass = "Ocupada";
                        iconClass = "fas fa-bed";
                        break;
                    case "limpieza":
                        statusClass = "Limpieza";
                        iconClass = "fas fa-broom";
                        isClickable = true;
                        break;
                    case "mantenimiento":
                        statusClass = "Mantenimiento";
                        iconClass = "fas fa-tools";
                        break;
                    case "reservada":
                        statusClass = "Reservada";
                        iconClass = "fas fa-calendar-check";
                        break;
                    case "disponible":
                        statusClass = "Disponible";
                        iconClass = "fas fa-door-open";
                        isClickable = true;
                        break;
                    default:
                        statusClass = "Desconocido";
                        iconClass = "fas fa-question";
                }

                out.println("<div class='room-card " + statusClass + "' data-level='" + pisoNombre + "'>");
                out.println("<h6>" + habiNombre + "</h6>");
                out.println("<p class='description-text'>" + (descripcion != null ? descripcion : "Sin descripción") + "</p>");

                // Aquí va el botón que mencionaste
                out.println("<button class='btn btn-block status-btn" + (isClickable ? "" : " disabled") + "' "
                        + "onclick='handleRoomStatus(\"" + estado + "\", \"" + rs.getString("idhabitaciones") + "\", \"" + habiNombre + "\")'>");
                out.println("<i class='" + iconClass + "'></i> " + estado);
                out.println("</button>");

                out.println("</div>");
            }
        } catch (SQLException e) {
            out.println("Error al cargar habitaciones: " + e.getMessage());
        }
    } else if ("actualizarEstado".equals(request.getParameter("listar"))) {
        String idHabitacion = request.getParameter("idhabitacion");
        String nuevoEstado = request.getParameter("estado");

        try (Statement st = conn.createStatement()) {
            st.executeUpdate("UPDATE \"HotelRum\".\"habitaciones\" SET habi_estado='" + nuevoEstado + "' WHERE idhabitaciones=" + idHabitacion);
            out.println("success");
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } else if ("listarHabitacionesOcupadas".equals(request.getParameter("listar"))) {
        HttpSession sesion = request.getSession();
        String userId = (String) sesion.getAttribute("id"); // Obtener ID del usuario logueado
        String userName = (String) sesion.getAttribute("user"); // Obtener nombre del usuario logueado

        // Consulta para obtener solo los movimientos de caja abiertos del cajero actual
        String queryMovimientos = "SELECT idmovimiento_caja FROM \"HotelRum\".movimiento_caja WHERE estado = 'Abierto' AND usuarios_idusuarios = ?;";

        List<String> idMovimientosAbiertos = new ArrayList<>();
        try (PreparedStatement pstMov = conn.prepareStatement(queryMovimientos)) {
            pstMov.setInt(1, Integer.parseInt(userId)); // Establecer el ID del cajero como Integer
            ResultSet rsMov = pstMov.executeQuery();
            while (rsMov.next()) {
                idMovimientosAbiertos.add(rsMov.getString("idmovimiento_caja"));
            }
        } catch (SQLException e) {
            out.println("Error al cargar movimientos de caja: " + e.getMessage());
        }

        // Verificar si hay movimientos de caja abiertos
if (idMovimientosAbiertos.isEmpty()) {
    out.println("<script>showModal();</script>"); // Mostrar el modal
    return; // Salir si no hay movimientos abiertos
}

        String query = "WITH "
                + "Timbrados AS ( "
                + "SELECT  "
                + "idtimbrado,  "
                + "fecha_inicio,  "
                + "fecha_fin,  "
                + "num_timbre "
                + "FROM \"HotelRum\".timbrado "
                + "WHERE estado = 'Activo' "
                + "AND CURRENT_DATE BETWEEN fecha_inicio AND fecha_fin "
                + "), "
                + "HabitacionesPorReserva AS ( "
                + "SELECT "
                + "h.idhabitaciones, "
                + "h.habi_nombre, "
                + "h.habi_descripcion, "
                + "h.habi_precio, "
                + "r.idreservas, "
                + "f.numerofac, "
                + "hu.hues_nombre || ' ' || hu.hues_apellido AS nombre_completo, "
                + "hu.hues_ci, "
                + "hu.hues_correo, "
                + "r.res_fecha_entrada, "
                + "p.pi_nombre, "
                + "t.fecha_inicio, "
                + "t.fecha_fin, "
                + "t.num_timbre, "
                + "t.idtimbrado, "
                + // Agregar el ID del timbrado
                "u.idusuarios, "
                + "u.usu_nombre, "
                + "ROW_NUMBER() OVER (PARTITION BY r.idreservas ORDER BY h.idhabitaciones) AS rn "
                + "FROM "
                + "\"HotelRum\".\"habitaciones\" h "
                + "JOIN "
                + "\"HotelRum\".\"reservas\" r ON h.idhabitaciones = r.habitacion_idhabitacion "
                + "LEFT JOIN "
                + "\"HotelRum\".\"factura\" f ON r.idreservas = f.reservas_idreservas "
                + "LEFT JOIN "
                + "\"HotelRum\".\"huespedes\" hu ON r.huespedes_idhuespedes = hu.idhuespedes "
                + "LEFT JOIN "
                + "\"HotelRum\".\"pisos\" p ON h.pisos_idpisos = p.idpisos "
                + "LEFT JOIN "
                + "\"HotelRum\".\"timbrado\" t ON f.timbrado_idtimbrado = t.idtimbrado "
                + "LEFT JOIN "
                + "\"HotelRum\".\"usuarios\" u ON f.usuarios_idusuarios = u.idusuarios "
                + "WHERE "
                + "h.habi_estado = 'Ocupada' "
                + "AND r.estado = 'Confirmada' "
                + "AND (f.estado IS NULL OR f.estado = 'Pendiente' OR f.estado = 'Cancelado' OR f.estado = 'Finalizado') "
                + ") "
                + "SELECT "
                + "h.idhabitaciones, "
                + "h.habi_nombre, "
                + "h.habi_descripcion, "
                + "h.habi_precio, "
                + "h.idreservas, "
                + "h.numerofac, "
                + "h.nombre_completo, "
                + "h.hues_ci, "
                + "h.hues_correo, "
                + "h.res_fecha_entrada, "
                + "h.pi_nombre, "
                + "t.fecha_inicio, "
                + "t.fecha_fin, "
                + "t.num_timbre, "
                + "t.idtimbrado "
                + "FROM "
                + "HabitacionesPorReserva h "
                + "CROSS JOIN "
                + "Timbrados t "
                + "WHERE "
                + "h.rn = 1;"; // Asegúrate de que esta consulta se adapte a tus necesidades

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(query)) {
            while (rs.next()) {
                String pisoNombre = rs.getString("pi_nombre");
                String habiNombre = rs.getString("habi_nombre");
                String descripcion = rs.getString("habi_descripcion");
                String precio = rs.getString("habi_precio");
                String idReservas = rs.getString("idreservas");
                String numeroFactura = rs.getString("numerofac");
                String nombreCompleto = rs.getString("nombre_completo");
                String documentoCI = rs.getString("hues_ci");
                String correoHuesped = rs.getString("hues_correo");
                String fechaInicio = rs.getString("fecha_inicio");
                String fechaFin = rs.getString("fecha_fin");
                String checkInDate = rs.getString("res_fecha_entrada");
                String numTimbrado = rs.getString("num_timbre");
                String idTimbrado = rs.getString("idtimbrado"); // Obtener el ID del timbrado

                // Aquí se asume que quieres usar el primer movimiento de caja abierto
                String idMovimientoCaja = idMovimientosAbiertos.get(0); // Obtener el primer ID de movimiento de caja abierto

                out.println("<div class='room-card Ocupada' data-level='" + pisoNombre + "'>");
                out.println("<h6>" + habiNombre + "</h6>");
                out.println("<p class='description-text'>" + (descripcion != null ? descripcion : "Sin descripción") + "</p>");

                // Escapar comillas simples para JavaScript
                String descripcionEscapada = (descripcion != null) ? descripcion.replace("'", "\\'") : "";
                String nombreCompletoEscapado = (nombreCompleto != null) ? nombreCompleto.replace("'", "\\'") : "";
                String correoHuespedEscapado = (correoHuesped != null) ? correoHuesped.replace("'", "\\'") : "";

                out.println("<button class='btn btn-block status-btn' "
                        + "onclick='setRoomDataAndRedirect(\"" + rs.getString("idhabitaciones") + "\", \""
                        + habiNombre + "\", \"" + descripcionEscapada + "\", " + precio + ", \""
                        + nombreCompletoEscapado + "\", \"" + documentoCI + "\", \"" + correoHuespedEscapado + "\", \""
                        + fechaInicio + "\", \"" + fechaFin + "\", \"" + checkInDate + "\", \"" + numeroFactura + "\", \"" + idTimbrado + "\", \"" + numTimbrado + "\", \"" + idMovimientoCaja + "\", \"" + userId + "\", \"" + idReservas + "\", \"" + userName + "\")'>");
                out.println("<i class='fas fa-bed'></i> Vender");
                out.println("</button>");
                out.println("</div>"); // Cerrar el div de room-card
            }
        } catch (SQLException e) {
            out.println("Error al cargar habitaciones ocupadas: " + e.getMessage());
        }
    } else if ("listarHabitacionesCobros".equals(request.getParameter("listar"))) {
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT "
                + "h.idhabitaciones, "
                + "h.habi_nombre, "
                + "h.habi_descripcion, "
                + "h.habi_precio, "
                + "p.pi_nombre, "
                + "hu.hues_nombre || ' ' || hu.hues_apellido AS nombre_completo, "
                + "hu.hues_ci, "
                + "hu.hues_telefono, "
                + "hu.hues_correo, "
                + "r.res_fecha_entrada, "
                + "r.res_fecha_salida, "
                + "r.res_senia, "
                + "r.idreservas " // Asegúrate de incluir esta línea
                + "FROM \"HotelRum\".\"habitaciones\" h "
                + "JOIN \"HotelRum\".\"reservas\" r ON h.idhabitaciones = r.habitacion_idhabitacion "
                + "JOIN \"HotelRum\".\"huespedes\" hu ON r.huespedes_idhuespedes = hu.idhuespedes "
                + "JOIN \"HotelRum\".\"pisos\" p ON h.pisos_idpisos = p.idpisos "
                + "WHERE h.habi_estado = 'Ocupada' "
                + "AND r.estado = 'Confirmada' "
                + "ORDER BY h.idhabitaciones;")) {

            while (rs.next()) {
                String pisoNombre = rs.getString("pi_nombre");
                String habiNombre = rs.getString("habi_nombre");
                String descripcion = rs.getString("habi_descripcion");
                String nombreCompleto = rs.getString("nombre_completo");
                String documentoCI = rs.getString("hues_ci");
                String telefono = rs.getString("hues_telefono");
                String correo = rs.getString("hues_correo");
                String fechaEntrada = rs.getString("res_fecha_entrada");
                String fechaSalida = rs.getString("res_fecha_salida");
                String senia = rs.getString("res_senia"); // This should correctly retrieve the deposit
                String idReservas = rs.getString("idreservas"); // This should correctly retrieve the reservation ID

                // Debugging output to verify values
                System.out.println("ID Reservas: " + idReservas + ", Seña: " + senia);

                out.println("<div class='room-card Ocupada' data-level='" + pisoNombre + "'>");
                out.println("<h6>" + habiNombre + "</h6>");
                out.println("<p class='description-text'>" + (descripcion != null ? descripcion : "Sin descripción") + "</p>");

                // Escape quotes and special characters for JavaScript
                String descripcionEscapada = descripcion.replace("'", "\\'");
                String nombreCompletoEscapado = nombreCompleto.replace("'", "\\'");

                out.println("<button class='btn btn-block status-btn' "
                        + "onclick='setRoomDataAndRedirect(\"" + rs.getString("idhabitaciones") + "\", \""
                        + habiNombre + "\", \"" + descripcionEscapada + "\", " + rs.getDouble("habi_precio") + ", \""
                        + nombreCompletoEscapado + "\", \"" + documentoCI + "\", \"" + telefono + "\", \""
                        + correo + "\", \"" + fechaEntrada + "\", \"" + fechaSalida + "\", \"" + idReservas + "\", \""
                        + senia + "\")'>");
                out.println("<i class='fas fa-money-bill-wave'></i> Cobrar");
                out.println("</button>");

                out.println("</div>"); // Close room-card div
            }
        } catch (SQLException e) {
            out.println("Error al cargar habitaciones para cobro: " + e.getMessage());
        }
    }
%>
