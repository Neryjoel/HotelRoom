<%@include file="conexion.jsp" %>
<%
try {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT COUNT(*) AS total FROM \"HotelRum\".\"huespedes\"");
    int totalHuespedes = 0;
    
    if (rs.next()) {
        totalHuespedes = rs.getInt("total");
    }
    
    // Guardar el total de huéspedes en una variable para mostrarlo en la página JSP
    request.setAttribute("totalHuespedes", totalHuespedes);
} catch (SQLException e) {
    e.printStackTrace();

    // Aquí podrías imprimir un mensaje específico de error para depurar más fácilmente
    out.println("Error al obtener el total de huéspedes: " + e.getMessage());
}
%>
