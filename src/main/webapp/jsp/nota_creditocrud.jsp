<%@ include file="conexion.jsp" %>
<%    if ("listar".equals(request.getParameter("listar"))) {
        try {
            Statement st = null;
            ResultSet rs = null;

            // Consulta SQL para obtener los detalles del movimiento de caja
            String sql = "SELECT "
                    + "n.idnota_credito AS idnota_credito, "
                    + "n.fecha_emision AS fecha_emision, "
                    + "n.motivo AS motivo, "
                    + "n.total AS total, "
                    + "n.compras_idcompras AS compras_idcompras, "
                    + "u.usu_nombre AS usuario "
                    + "FROM "
                    + "\"HotelRum\".nota_credito n "
                    + "INNER JOIN \"HotelRum\".compras c ON n.compras_idcompras = c.idcompras "
                    + "INNER JOIN \"HotelRum\".usuarios u ON n.usuarios_idusuarios = u.idusuarios "
                    + "ORDER BY n.idnota_credito DESC;";

            st = conn.createStatement();
            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idnota_credito")%></td>
    <td><%= rs.getString("fecha_emision")%></td>
    <td><%= rs.getString("motivo")%></td>
    <td><%= rs.getBigDecimal("total")%></td>
    <td><%= rs.getBigDecimal("compras_idcompras")%></td>
    <td><%= rs.getString("usuario")%></td>
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
