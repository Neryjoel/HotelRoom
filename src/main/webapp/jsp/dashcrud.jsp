<%@include file="conexion.jsp" %>
<%
try {
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery("SELECT COUNT(*) AS total FROM \"HotelRum\".\"huespedes\"");
    int totalHuespedes = 0;
    
    if (rs.next()) {
        totalHuespedes = rs.getInt("total");
    }
    
    // Guardar el total de hu�spedes en una variable para mostrarlo en la p�gina JSP
    request.setAttribute("totalHuespedes", totalHuespedes);
} catch (SQLException e) {
    e.printStackTrace();

    // Aqu� podr�as imprimir un mensaje espec�fico de error para depurar m�s f�cilmente
    out.println("Error al obtener el total de hu�spedes: " + e.getMessage());
}
%>
