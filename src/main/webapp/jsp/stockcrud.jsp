<%@ include file="conexion.jsp" %>

<%
    if ("listar".equals(request.getParameter("listar"))) {
        try {
            Statement st = null;
            ResultSet rs = null;

            // Consulta SQL para obtener los detalles del stock actualizado
            String sql = "SELECT "
                    + "s.idstock, "
                    + "s.cantidad, "
                    + "a.art_nombre AS articulo_nombre "
                    + "FROM "
                    + "\"HotelRum\".stock s "
                    + "INNER JOIN \"HotelRum\".articulos a ON s.articulos_idarticulos = a.idarticulos "
                    + "LEFT JOIN \"HotelRum\".factura f ON s.factura_idfactura = f.idfactura "
                    + "LEFT JOIN \"HotelRum\".compras c ON s.compras_idcompras = c.idcompras";

            st = conn.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idstock")%></td>
    <td><%= rs.getString("articulo_nombre")%></td>
    <td><%= rs.getInt("cantidad")%></td>
    <td>
        <i class="fas fa-edit btn btn-success btn-edit" data-idstock="<%= rs.getString("idstock") %>" 
           data-articulonombre="<%= rs.getString("articulo_nombre") %>" 
           data-cantidadactual="<%= rs.getInt("cantidad") %>"></i>
        <i class="fas fa-eye btn btn-primary" data-toggle="modal" data-target="#eliminarStockModal" onclick="$('#idstock_e').val('<%= rs.getString("idstock")%>')"></i>
    </td>
</tr>
<%
            }

            // Cerrar recursos
            rs.close();
            st.close();
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } else if ("modificar".equals(request.getParameter("modificar"))) {
        String idstock = request.getParameter("idstock");
        String nuevaCantidad = request.getParameter("nueva_cantidad");

        try {
            Statement st = conn.createStatement();
            String sql = "UPDATE \"HotelRum\".stock SET cantidad = " + nuevaCantidad + " WHERE idstock = " + idstock;
            st.executeUpdate(sql);
            out.println("<div class='alert alert-success fade-out' role='alert'>Cantidad actualizada con éxito!</div>");
        } catch (Exception e) {
            out.println("Error al actualizar: " + e.getMessage());
        }
    }
%>