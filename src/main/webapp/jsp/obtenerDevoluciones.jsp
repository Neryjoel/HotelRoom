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
<option value="<%= rs.getString(1) %>,<%= rs.getString(2) %>,<%= rs.getString(3) %>"><%= rs.getString(3) %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} 
else if (request.getParameter("listar").equals("buscararticulo")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        
        // Ejecuta el query seleccionando solo los campos necesarios
        rs = st.executeQuery("SELECT idarticulos, art_nombre, art_precio_venta FROM \"HotelRum\".articulos ORDER BY idarticulos ASC;");
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
}

%>
