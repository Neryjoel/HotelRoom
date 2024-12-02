<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idcategorias, cat_nombre FROM \"HotelRum\".\"categorias\" ORDER BY cat_nombre ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idcategorias") %>"><%= rs.getString("cat_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
%>