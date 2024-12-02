<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idpersonales, per_nombre FROM \"HotelRum\".\"personales\" ORDER BY per_nombre ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idpersonales") %>"><%= rs.getString("per_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
%>

