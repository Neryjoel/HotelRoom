<%@page import="java.math.BigDecimal"%>
<%@ include file="conexion.jsp" %>
<%    if (request.getParameter("listar").equals("listar")) {
        // Lógica para listar reservas
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT "
                    + "r.idreservas, "
                    + "TO_CHAR(r.res_fecha_entrada, 'DD/MM/YYYY HH24:MI') AS res_fecha_entrada, "
                    + "TO_CHAR(r.res_fecha_salida, 'DD/MM/YYYY HH24:MI') AS res_fecha_salida, "
                    + "r.estado, "
                    + "CONCAT(h.hues_nombre, ' ', h.hues_apellido) AS huesped, "
                    + "CONCAT(hab.habi_nombre, ' | ', p.pi_nombre) AS habitacion, "
                    + "r.res_senia "
                    + "FROM \"HotelRum\".\"reservas\" r "
                    + "JOIN \"HotelRum\".\"huespedes\" h ON r.huespedes_idhuespedes = h.idhuespedes "
                    + "JOIN \"HotelRum\".\"habitaciones\" hab ON r.habitacion_idhabitacion = hab.idhabitaciones "
                    + "JOIN \"HotelRum\".\"pisos\" p ON hab.pisos_idpisos = p.idpisos "
                    + "WHERE r.estado NOT IN ('Confirmada', 'Cancelada') OR r.estado IS NULL "                    
                    + "ORDER BY r.idreservas ASC");

            while (rs.next()) {
%>
<tr>
    <td><% out.print(rs.getString("idreservas")); %></td>
    <td><% out.print(rs.getString("res_fecha_entrada")); %></td>
    <td><% out.print(rs.getString("res_fecha_salida")); %></td>
    <td><% out.print(rs.getString("estado")); %></td>
    <td><% out.print(rs.getString("huesped")); %></td>
    <td><% out.print(rs.getString("habitacion")); %></td>
    <td><% out.print(rs.getString("res_senia")); %></td>

    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarReservas(
                        '<%= rs.getString("idreservas")%>',
                        '<%= rs.getString("res_fecha_entrada")%>',
                        '<%= rs.getString("res_fecha_salida")%>',
                        '<%= rs.getString("estado")%>',
                        '<%= rs.getString("huesped")%>',
                        '<%= rs.getString("habitacion")%>',
                        '<%= rs.getString("res_senia")%>'
                        )"></i>        
        <a href="reporteVistaIndividual/reporteReserva.jsp?res=<%= rs.getString("idreservas")%>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("cargar")) {
        // Capturar los parámetros
        String fechaEntrada = request.getParameter("res_fecha_entrada");
        String fechaSalida = request.getParameter("res_fecha_salida");
        String estado = request.getParameter("estado");
        int huespedId = Integer.parseInt(request.getParameter("codhuespedes"));
        int habitacionId = Integer.parseInt(request.getParameter("codhabitaciones"));
        BigDecimal senia = new BigDecimal(request.getParameter("res_senia"));

        // Convertir las fechas al formato correcto
        fechaEntrada = fechaEntrada.replace("T", " ") + ":00";
        fechaSalida = fechaSalida.replace("T", " ") + ":00";

        // Realizar la inserción
        try {
            conn.setAutoCommit(false); // Iniciar transacción

            // Insertar la reserva
            String queryReserva = "INSERT INTO \"HotelRum\".\"reservas\" (res_fecha_entrada, res_fecha_salida, estado, huespedes_idhuespedes, habitacion_idhabitacion, res_senia) "
                    + "VALUES (TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), ?, ?, ?, ?)";
            PreparedStatement psReserva = conn.prepareStatement(queryReserva);
            psReserva.setString(1, fechaEntrada);
            psReserva.setString(2, fechaSalida);
            psReserva.setString(3, estado);
            psReserva.setInt(4, huespedId);
            psReserva.setInt(5, habitacionId);
            psReserva.setBigDecimal(6, senia);
            psReserva.executeUpdate();

            // Si el estado es "Pendiente", actualizar el estado de la habitación a "Reservada"
            if ("Pendiente".equals(estado)) {
                String queryHabitacion = "UPDATE \"HotelRum\".\"habitaciones\" SET habi_estado = 'Reservada' WHERE idhabitaciones = ?";
                PreparedStatement psHabitacion = conn.prepareStatement(queryHabitacion);
                psHabitacion.setInt(1, habitacionId);
                psHabitacion.executeUpdate();
            }

            conn.commit(); // Confirmar transacción
            out.println("<div class='alert alert-success' role='alert'>Reserva insertada correctamente!</div>");
        } catch (SQLException e) {
            try {
                conn.rollback(); // Revertir cambios en caso de error
            } catch (SQLException ex) {
                out.println("Error al hacer rollback: " + ex.getMessage());
            }
            out.println("<div class='alert alert-danger' role='alert'>Error al insertar reserva: " + e.getMessage() + "</div>");
        } finally {
            try {
                conn.setAutoCommit(true); // Restaurar autocommit
            } catch (SQLException ex) {
                out.println("Error al restaurar autocommit: " + ex.getMessage());
            }
        }
    } else if (request.getParameter("listar").equals("modificar")) {
        String id = request.getParameter("idreservas");
        String fechaEntrada = request.getParameter("res_fecha_entrada");
        String fechaSalida = request.getParameter("res_fecha_salida");
        String estado = request.getParameter("estado");
        int huespedId = Integer.parseInt(request.getParameter("codhuespedes"));
        int habitacionId = Integer.parseInt(request.getParameter("codhabitaciones"));
        BigDecimal senia = new BigDecimal(request.getParameter("res_senia"));

        // Convertir las fechas al formato correcto
        fechaEntrada = fechaEntrada.replace("T", " ") + ":00";
        fechaSalida = fechaSalida.replace("T", " ") + ":00";

        try {
            conn.setAutoCommit(false); // Iniciar transacción

            // Actualizar la reserva
            String queryReserva = "UPDATE \"HotelRum\".\"reservas\" SET res_fecha_entrada=TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), res_fecha_salida=TO_TIMESTAMP(?, 'YYYY-MM-DD HH24:MI:SS'), estado=?, huespedes_idhuespedes=?, habitacion_idhabitacion=?, res_senia=? WHERE idreservas=?";
            PreparedStatement pstmtReserva = conn.prepareStatement(queryReserva);
            pstmtReserva.setString(1, fechaEntrada);
            pstmtReserva.setString(2, fechaSalida);
            pstmtReserva.setString(3, estado);
            pstmtReserva.setInt(4, huespedId);
            pstmtReserva.setInt(5, habitacionId);
            pstmtReserva.setBigDecimal(6, senia);
            pstmtReserva.setInt(7, Integer.parseInt(id));
            pstmtReserva.executeUpdate();

            // Actualizar el estado de la habitación según el estado de la reserva
            String nuevoEstadoHabitacion = "";
            switch (estado) {
                case "Confirmada":
                    nuevoEstadoHabitacion = "Ocupada";
                    break;
                case "Pendiente":
                    nuevoEstadoHabitacion = "Reservada";
                    break;
                case "Cancelada":
                    nuevoEstadoHabitacion = "Disponible";
                    break;
                default:
                    nuevoEstadoHabitacion = "Disponible"; // Estado por defecto
            }

            String queryHabitacion = "UPDATE \"HotelRum\".\"habitaciones\" SET habi_estado = ? WHERE idhabitaciones = ?";
            PreparedStatement pstmtHabitacion = conn.prepareStatement(queryHabitacion);
            pstmtHabitacion.setString(1, nuevoEstadoHabitacion);
            pstmtHabitacion.setInt(2, habitacionId);
            pstmtHabitacion.executeUpdate();

            conn.commit(); // Confirmar transacción
            out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
        } catch (SQLException e) {
            try {
                conn.rollback(); // Revertir cambios en caso de error
            } catch (SQLException ex) {
                out.println("Error al hacer rollback: " + ex.getMessage());
            }
            out.println("<div class='alert alert-danger' role='alert'>Error al modificar datos: " + e.getMessage() + "</div>");
        } finally {
            try {
                conn.setAutoCommit(true); // Restaurar autocommit
            } catch (SQLException ex) {
                out.println("Error al restaurar autocommit: " + ex.getMessage());
            }
        }
    } else if (request.getParameter("listar").equals("eliminar")) {
        String pk = request.getParameter("idpk");

        try {
            Statement st = conn.createStatement();
            st.executeUpdate("DELETE FROM \"HotelRum\".\"reservas\" WHERE idreservas=" + pk);
            out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con éxito!</div>");
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    }
%>