<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idpisos, pi_nombre FROM \"HotelRum\".\"pisos\" ORDER BY pi_nombre ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idpisos") %>"><%= rs.getString("pi_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
%>

