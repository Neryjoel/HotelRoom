<%@ include file="conexion.jsp" %>
<%
if (request.getParameter("listar").equals("listarmovimientosdetalle")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT "
                    + "md.idmovimiento_detalle AS REF, "
                    + "md.movimiento_caja_idmovimiento_caja AS ID_MOVIMIENTO_CAJA, "
                    + "to_char(md.fecha, 'dd-mm-YYYY HH24:MI') AS FECHA, "
                    + "md.tipo_movimiento AS TIPO_MOVIMIENTO, "
                    + "f.total AS MONTO, "
                    + "f.numerofac AS NRO_FACTURA, "
                    + "u.usu_nombre AS USUARIO "
                    + "FROM \"HotelRum\".movimiento_detalle md "
                    + "LEFT JOIN \"HotelRum\".factura f ON md.factura_idfactura = f.idfactura "
                    + "LEFT JOIN \"HotelRum\".cobros c ON f.idfactura = c.factura_idfactura "
                    + "LEFT JOIN \"HotelRum\".movimiento_caja mc ON md.movimiento_caja_idmovimiento_caja = mc.idmovimiento_caja "
                    + "LEFT JOIN \"HotelRum\".usuarios u ON f.usuarios_idusuarios = u.idusuarios "
                    + "WHERE c.estado = 'Cobrado' "  // Filtrar solo por estado 'Cobrado'
                    + "ORDER BY md.idmovimiento_detalle DESC;");

        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("REF")%></td>
    <td><%= rs.getString("ID_MOVIMIENTO_CAJA")%></td>
    <td><%= rs.getString("FECHA")%></td>
    <td><%= rs.getString("TIPO_MOVIMIENTO")%></td>
    <td><%= rs.getString("MONTO")%></td>
    <td><%= rs.getString("NRO_FACTURA") != null ? rs.getString("NRO_FACTURA") : "N/A"%></td>
    <td><%= rs.getString("USUARIO")%></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error al listar movimientos: " + e);
        }
    }
%>