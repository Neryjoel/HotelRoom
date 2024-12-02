<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idtipo_pago, tipo_descripcion FROM \"HotelRum\".\"tipo_pago\" ORDER BY tipo_descripcion ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idtipo_pago") %>"><%= rs.getString("tipo_descripcion") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
%>