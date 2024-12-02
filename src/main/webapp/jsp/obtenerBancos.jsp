<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idbancos, ban_descripcion FROM \"HotelRum\".\"bancos\" ORDER BY ban_descripcion ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idbancos") %>"><%= rs.getString("ban_descripcion") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
%>