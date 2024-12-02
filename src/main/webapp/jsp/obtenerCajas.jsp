<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idcajas, caja_nombre FROM \"HotelRum\".\"cajas\" ORDER BY idcajas ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idcajas") %>"><%= rs.getString("caja_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
%>

