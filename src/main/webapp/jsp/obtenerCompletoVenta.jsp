<%@ include file="conexion.jsp" %>
<%
if ("obtenerDatosHabitaciones".equals(request.getParameter("listar"))) {
    String idReserva = request.getParameter("idreservas"); // Obtener el ID de reserva desde el parámetro
    
    // Agrega esta línea para depurar el valor de idReserva
    out.println("ID de reserva: " + idReserva); // Imprime el ID de reserva para depuración
    
    try (PreparedStatement pst = conn.prepareStatement(
        "SELECT " +
        "    h.habi_nombre, " +
        "    h.habi_descripcion, " +
        "    h.habi_precio, " +
        "    hu.hues_nombre || ' ' || hu.hues_apellido AS hues_full_name, " + // Concatenar nombre y apellido
        "    hu.hues_ci, " +
        "    r.res_fecha_entrada " +
        "FROM " +
        "    \"HotelRum\".\"reservas\" r " + // Empezamos desde la tabla reservas
        "JOIN " +
        "    \"HotelRum\".\"habitaciones\" h ON r.habitacion_idhabitacion = h.idhabitaciones " +
        "JOIN " +
        "    \"HotelRum\".\"huespedes\" hu ON r.huespedes_idhuespedes = hu.idhuespedes " + // Relacionar con huespedes
        "WHERE " +
        "    r.estado = 'Confirmada' " +
        "    AND r.idreservas = ?")) { // Usar un parámetro para el ID de reserva
        
        pst.setInt(1, Integer.parseInt(idReserva)); // Establecer el ID de reserva en el PreparedStatement
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            String datos = rs.getString("habi_nombre") + "|" +
                           rs.getString("habi_descripcion") + "|" +
                           rs.getDouble("habi_precio") + "|" +
                           rs.getString("hues_full_name") + "|" + // Usar el campo concatenado
                           rs.getString("hues_ci") + "|" +
                           rs.getTimestamp("res_fecha_entrada"); // Agregar fecha de entrada
            out.print(datos);
        } else {
            out.print("No se encontraron datos para la reserva especificada.");
        }
    } catch (Exception e) {
        out.println("Error al obtener datos de la reserva: " + e.getMessage());
    }
}
%>