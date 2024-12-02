<%@ include file="conexion.jsp" %>
<%
    String estadoCaja = "cerrado"; // Default value in case no records are found

    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT estado FROM \"HotelRum\".\"caja\" ORDER BY fecha_apertura DESC LIMIT 1");

        if (rs.next()) {
            estadoCaja = rs.getString("estado");
        }
    } catch (Exception e) {
        out.println("Error al verificar el estado de la caja: " + e.getMessage());
    }
%>