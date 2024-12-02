<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>

<%
    String reservationId = request.getParameter("reservationId");
    String nuevoEstado = request.getParameter("nuevoEstado");

    if (reservationId != null && nuevoEstado != null) {
        try {
            // Preparar la consulta SQL para actualizar el estado de todas las facturas de la reserva
            String sql = "UPDATE \"HotelRum\".\"factura\" " +
                         "SET estado = ? " +
                         "WHERE reservas_idreservas = ? AND estado = 'PendienteCobro'";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            
            // Establecer los parámetros
            pstmt.setString(1, nuevoEstado);
            pstmt.setInt(2, Integer.parseInt(reservationId));

            // Ejecutar la actualización
            int filasAfectadas = pstmt.executeUpdate();

            if (filasAfectadas > 0) {
                out.println("Estado de facturas actualizado a " + nuevoEstado + ". Facturas afectadas: " + filasAfectadas);
            } else {
                out.println("No se encontraron facturas pendientes de cobro para esta reserva");
            }

            // Cerrar recursos
            pstmt.close();
        } catch (SQLException e) {
            out.println("Error al actualizar estado: " + e.getMessage());
        } finally {
            // Cerrar la conexión
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    } else {
        out.println("Parámetros inválidos");
    }
%>