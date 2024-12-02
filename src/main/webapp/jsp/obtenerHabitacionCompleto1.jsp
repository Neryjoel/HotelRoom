<%@ include file="conexion.jsp" %>
<%
if ("obtenerDatosHabitacion".equals(request.getParameter("listar"))) {
    String idHabitacion = request.getParameter("idhabitacion");
    try (PreparedStatement pst = conn.prepareStatement(
        "SELECT h.*, p.pi_nombre FROM \"HotelRum\".\"habitaciones\" h " +
        "LEFT JOIN \"HotelRum\".\"pisos\" p ON h.pisos_idpisos = p.idpisos " +
        "WHERE h.idhabitaciones = ?")) {
        
        pst.setInt(1, Integer.parseInt(idHabitacion));
        ResultSet rs = pst.executeQuery();
        
        if (rs.next()) {
            String datos = rs.getInt("idhabitaciones") + "|" +
                           rs.getString("habi_descripcion") + "|" +
                           rs.getString("habi_estado") + "|" +
                           rs.getDouble("habi_precio") + "|" +
                           rs.getInt("habi_capacidad") + "|" +
                           rs.getInt("habi_nombre") + "|" +
                           rs.getString("pi_nombre");
            
            out.print(datos);
        }
    } catch (Exception e) {
        out.println("Error al obtener datos de la habitación: " + e.getMessage());
    }
}
%>