<%@ page import="java.sql.*" %>
<%@ include file="conexion.jsp" %>

<%
    String reservationId = request.getParameter("reservationId");
    String userId = request.getParameter("userId");

    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Consulta para obtener la última factura de la reserva
        String sql = "SELECT idfactura " +
                     "FROM \"HotelRum\".\"factura\" " +
                     "WHERE reservas_idreservas = ? " +
                     "ORDER BY idfactura DESC " +
                     "LIMIT 1";

        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(reservationId));

        rs = pstmt.executeQuery();

        if (rs.next()) {
            // Obtener y imprimir el ID de factura
            int facturaId = rs.getInt("idfactura");
            out.println(facturaId);
            
            // Log adicional
            System.out.println("Última factura encontrada para reserva " + reservationId + ": " + facturaId);
        } else {
            // Si no se encuentra ninguna factura
            System.out.println("No se encontró ninguna factura para la reserva " + reservationId);
            out.println("0"); // O algún valor que indique "no encontrado"
        }
    } catch (SQLException e) {
        System.err.println("Error SQL al obtener última factura: " + e.getMessage());
        out.println("0");
    } catch (NumberFormatException e) {
        System.err.println("ID de reserva inválido: " + reservationId);
        out.println("0");
    } finally {
        // Cerrar recursos
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar recursos: " + e.getMessage());
        }
    }
%>