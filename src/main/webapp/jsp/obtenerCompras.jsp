<%@include file="conexion.jsp" %>
<%
 if (request.getParameter("listar").equals("buscarproveedor")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idproveedores, prov_nombre, prov_ruc FROM \"HotelRum\".\"proveedores\" ORDER BY idproveedores ASC;");
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>,<%= rs.getString(2) %>,<%= rs.getString(3) %>">
    <%= rs.getString(2) %>
</option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }

} else if (request.getParameter("listar").equals("buscararticulo")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        
        // Obtener el tipo de artículo (si se proporciona)
        String tipoArticulo = request.getParameter("tipo") != null ? 
            request.getParameter("tipo") : "Articulo";
        
        // Consulta para filtrar por tipo de artículo
        String query = "SELECT idarticulos, art_nombre, art_precio_venta " +
                       "FROM \"HotelRum\".articulos " +
                       "WHERE art_tipo = '" + tipoArticulo + "' " +
                       "ORDER BY idarticulos ASC";
        
        rs = st.executeQuery(query);
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>,<%= rs.getString(3) %>"><%= rs.getString(2) %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
}else if (request.getParameter("listar").equals("buscartipo_pago")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"tipo_pago\" ORDER BY idtipo_pago ASC;");
%>
<option value="">Seleccionar</option>
<%
            while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>"><%= rs.getString(2) %></option>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    }

%>
