<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idarticulos, art_nombre FROM \"HotelRum\".\"articulos\" ORDER BY art_nombre ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idarticulos") %>"><%= rs.getString("art_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
%>