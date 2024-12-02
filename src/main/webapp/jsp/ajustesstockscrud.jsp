<%@ include file="conexion.jsp" %>

<% 
     HttpSession sesion = request.getSession();
    // Check the action type
    if ("listar".equals(request.getParameter("listar"))) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = null;

            // Query to get stock adjustment details
            String sql = "SELECT "
                    + "a.idajustesstocks, "
                    + "art.art_nombre AS articulo_nombre, "
                    + "a.cantidad, "
                    + "a.aju_motivo "
                    + "FROM \"HotelRum\".ajustesstocks a "
                    + "INNER JOIN \"HotelRum\".articulos art ON a.articulos_idarticulos = art.idarticulos";

            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idajustesstocks") %></td>
    <td><%= rs.getString("articulo_nombre") %></td>
    <td><%= rs.getInt("cantidad") %></td>
    <td><%= rs.getString("aju_motivo") %></td>
    <td>
        <i class="fas fa-edit btn btn-success btn-edit" data-idajustesstocks="<%= rs.getString("idajustesstocks") %>" 
           data-articulonombre="<%= rs.getString("articulo_nombre") %>" 
           data-cantidadactual="<%= rs.getInt("cantidad") %>"
           data-motivo="<%= rs.getString("aju_motivo") %>"></i>
        <i class="fas fa-eye btn btn-primary" data-toggle="modal" data-target="#eliminarStockModal" onclick="$('#idstock_e').val('<%= rs.getString("idajustesstocks") %>')"></i>
    </td>
</tr>
<%
            }

            // Close resources
            if (rs != null) rs.close();
            if (st != null) st.close();
        } catch (Exception e) {
            out.println("Error PSQL: " + e.getMessage());
        }
    } else if ("modificar".equals(request.getParameter("modificar"))) {
        String idajustesstocks = request.getParameter("idajustesstocks");
        String nuevaCantidad = request.getParameter("nueva_cantidad");
        String aju_motivo = request.getParameter("aju_motivo");

        try {
            Statement st = conn.createStatement();
            // Update the stock adjustment
            String updateSql = "UPDATE \"HotelRum\".ajustesstocks "
                             + "SET cantidad = " + nuevaCantidad + ", aju_motivo = '" + aju_motivo + "' "
                             + "WHERE idajustesstocks = " + idajustesstocks;
            st.executeUpdate(updateSql);

            // Insert into inventory after modification
            ResultSet rsDetalle = st.executeQuery(
                "SELECT articulos_idarticulos, cantidad "
                + "FROM \"HotelRum\".ajustesstocks WHERE idajustesstocks = " + idajustesstocks);

            if (rsDetalle.next()) {
                int idArticulo = rsDetalle.getInt("articulos_idarticulos");
                int cantidad = Integer.parseInt(nuevaCantidad);

                // Insert into the inventory table
                String insertInventorySql = "INSERT INTO \"HotelRum\".\"inventario\" (tipo_movimiento, cantidad, precio_unitario, articulos_idarticulos, usuarios_idusuarios,ajustesstocks_idajustesstocks) "
                                           + "VALUES ('AJUSTE INVENTARIO', " + cantidad + ", " + 0 + ", " + idArticulo + ", " + sesion.getAttribute("id") + ", " + idajustesstocks + ")";
                st.executeUpdate(insertInventorySql);
            }

            out.println("<div class='alert alert-success fade-out' role='alert'>Cantidad y motivo actualizados con éxito, y registrado en inventario!</div>");

            // Close resources
            if (rsDetalle != null) rsDetalle.close();
            if (st != null) st.close();
        } catch (Exception e) {
            out.println("Error al actualizar: " + e.getMessage());
        }
    }
%>
