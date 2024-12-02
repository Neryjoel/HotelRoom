<%@ include file="conexion.jsp" %>
<%
if (request.getParameter("listar") != null && request.getParameter("listar").equals("listarHuespedes")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"huespedes\" ORDER BY idhuespedes ASC;");
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
    <option value="<%= rs.getString("idhuespedes") %>,<%= rs.getString("hues_nombre") %>,<%= rs.getString("hues_apellido") %>,<%= rs.getString("hues_ci") %>,<%= rs.getString("hues_telefono") %>,<%= rs.getString("hues_correo") %>">
        <%= rs.getString("hues_nombre") %> <%= rs.getString("hues_apellido") %>
    </option>
<%
        }
    } catch (Exception e) {
        out.print("Error PSQL: " + e.getMessage());
    }
}
%>