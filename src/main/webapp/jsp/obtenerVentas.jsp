<%@ include file="conexion.jsp" %>
<%
    if (request.getParameter("listar").equals("buscararticulo")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idarticulos, art_nombre, art_tipo FROM \"HotelRum\".\"articulos\" ORDER BY art_nombre ASC;");
%>
<option value="">Seleccionar</option>
<%
            while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>">Tipo: <%= rs.getString(3) %> | <%= rs.getString(2) %></option>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    } else if (request.getParameter("listar").equals("buscartipo_pago")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"tipo_pago\" WHERE tipo_descripcion IN ('Contado', 'Despues') ORDER BY idtipo_pago ASC;");
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
} else if (request.getParameter("listar").equals("obtenerPrecio")) {
    String idarticulo = request.getParameter("idarticulo");
    try {
        PreparedStatement pstm = conn.prepareStatement("SELECT art_precio_venta FROM \"HotelRum\".\"articulos\" WHERE idarticulos = ?");
        pstm.setInt(1, Integer.parseInt(idarticulo));
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            out.print(rs.getBigDecimal("art_precio_venta")); // Devuelve solo el precio
        } else {
            out.print("0"); // Si no se encuentra el artículo, devuelve 0
        }
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
}
%>