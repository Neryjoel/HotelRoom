<%@ include file="conexion.jsp" %>

<% 
    // Obtener el parámetro "listar" para mostrar los ajustes de stock
    if ("listar".equals(request.getParameter("listar"))) {
        try {
            Statement st = null;
            ResultSet rs = null;

            // Consulta SQL para obtener los detalles del ajuste de stock
            String sql = "SELECT "
                    + "a.idajustesstocks, "
                    + "art.art_nombre AS articulo_nombre, "
                    + "a.cantidad "
                    + "FROM "
                    + "\"HotelRum\".ajustesstocks a "
                    + "INNER JOIN \"HotelRum\".articulos art ON a.articulos_idarticulos = art.idarticulos";

            st = conn.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idajustesstocks") %></td>
    <td><%= rs.getString("articulo_nombre")%></td>
    <td><%= rs.getInt("cantidad")%></td>
    <td>
        <i class="fas fa-eye btn btn-primary" data-toggle="modal" data-target="#eliminarStockModal" onclick="$('#idstock_e').val('<%= rs.getString("idajustesstocks")%>')"></i>
    </td>
</tr>
<%
            }

            // Cerrar recursos
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    }
%>