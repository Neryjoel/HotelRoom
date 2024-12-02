<%@include file="jsp/conexion.jsp" %>
<%
if (request.getParameter("listar").equals("listar")) {
    // Código para listar movimientos de caja
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT "
                + "mc.idmovimiento_caja AS idmovimiento_caja, "
                + "c.caja_nombre AS caja_nombre, "
                + "mc.fecha_apertura AS fecha_apertura, "
                + "mc.fecha_cierre AS fecha_cierre, "
                + "mc.saldo_inicial AS saldo_inicial, "
                + "mc.saldo_disponible AS saldo_disponible, "
                + "u.usu_nombre AS usuario "
                + "FROM "
                + "\"HotelRum\".movimiento_caja mc "
                + "INNER JOIN \"HotelRum\".cajas c ON mc.cajas_idcajas = c.idcajas "
                + "INNER JOIN \"HotelRum\".usuarios u ON mc.usuarios_idusuarios = u.idusuarios "
                + "ORDER BY mc.idmovimiento_caja DESC;");

        while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idmovimiento_caja") %></td>
    <td><%= rs.getString("caja_nombre") %></td>
    <td><%= rs.getString("fecha_apertura") %></td>
    <td><%= rs.getString("fecha_cierre") %></td>
    <td><%= rs.getBigDecimal("saldo_inicial") %></td>
    <td><%= rs.getBigDecimal("saldo_disponible") %></td>
    <td><%= rs.getString("usuario") %></td>
</tr>
<%
        }
    } catch (Exception e) {
        out.println("Error en la consulta SQL: " + e.getMessage());
    }
} else if (request.getParameter("listar").equals("cargar")) {    // Carga de nuevos movimientos de caja
    
    // Retrieve and validate parameters
    String fechaApertura = request.getParameter("fecha_apertura");
    String saldoInicial = request.getParameter("saldo_inicial");
    String cajasIdcajas = request.getParameter("cajas_idcajas");
    String usuariosIdusuarios = request.getParameter("usuarios_idusuarios");

    if (fechaApertura != null && saldoInicial != null && cajasIdcajas != null && usuariosIdusuarios != null) {
        try {
            // Convert parameters to the required data types
            java.sql.Date fechaAperturaDate = java.sql.Date.valueOf(fechaApertura); // Assuming the format is YYYY-MM-DD
            double saldoInicialDouble = Double.parseDouble(saldoInicial);
            int codCajaInt = Integer.parseInt(cajasIdcajas);
            int usuariosIdusuariosInt = Integer.parseInt(usuariosIdusuarios);

            // SQL Insert query
            String sql = "INSERT INTO \"HotelRum\".movimiento_caja (fecha_apertura, saldo_inicial, cajas_idcajas, usuarios_idusuarios) " +
                         "VALUES ('" + fechaAperturaDate + "', " + saldoInicialDouble + ", " + codCajaInt + ", " + usuariosIdusuariosInt + ")";
            
            // Execute the query
            Statement st = conn.createStatement();
            st.executeUpdate(sql);

            out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
        } catch (Exception e) {
            out.println("<div class='alert alert-danger' role='alert'>Error al insertar datos: " + e.getMessage() + "</div>");
        }
    } else {
        // Error message when parameters are missing
        out.println("<div class='alert alert-danger' role='alert'>Error: Parámetros faltantes.</div>");
    }
}


%>