<%@ include file="conexion.jsp" %>
<%
    if ("listar".equals(request.getParameter("listar"))) {
        try {
            Statement st = null;
            ResultSet rs = null;

            // Consulta SQL para obtener los detalles del inventario
            String sql = "SELECT "
                    + "i.idinventario, "
                    + "i.fecha AS fecha, "
                    + "i.tipo_movimiento AS tipo_movimiento, "
                    + "a.art_nombre AS articulo_nombre, "
                    + "i.cantidad, "
                    + "i.precio_unitario AS precio_unitario, "
                    + "u.usu_nombre AS usuario "
                    + "FROM "
                    + "\"HotelRum\".inventario i "
                    + "INNER JOIN \"HotelRum\".articulos a ON i.articulos_idarticulos = a.idarticulos "
                    + "INNER JOIN \"HotelRum\".usuarios u ON i.usuarios_idusuarios = u.idusuarios order by i.idinventario desc;";

            st = conn.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idinventario") %></td>
    <td><%= rs.getString("fecha") %></td>
    <td><%= rs.getString("tipo_movimiento") %></td>
    <td><%= rs.getString("articulo_nombre") %></td>
    <td><%= rs.getInt("cantidad") %></td>
    <td><%= rs.getBigDecimal("precio_unitario") %></td>
    <td><%= rs.getString("usuario") %></td>
</tr>
<%
            }
            // Cerrar recursos
            rs.close();
            st.close();
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } 
%>
