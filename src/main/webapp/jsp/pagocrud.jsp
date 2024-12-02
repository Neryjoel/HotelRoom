<%@ include file="conexion.jsp" %>
<%
    String listarParam = request.getParameter("listar");

    if ("listar".equals(listarParam)) {
        // Código para listar cobros
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            
            // SQL query to list payments
            String sql = "SELECT " +
                         "    p.idpagos AS REF, " +
                         "    p.fecha_pago AS FECHA, " +
                         "    h.prov_nombre AS PROVEEDOR, " +
                         "    p.monto AS MONTO, " +
                         "    mp.descripcion AS METODO_DE_PAGO, " +
                         "    tp.tipo_descripcion AS TIPO_PAGO, " +
                         "    b.ban_descripcion AS BANCO, " +
                         "    t.tar_descripcion AS TIPO_TARJETA, " +
                         "    p.estado AS ESTADO, " +
                         "    u.usu_nombre AS USUARIO " +
                         "FROM " +
                         "    \"HotelRum\".pagos p " +
                         "    INNER JOIN \"HotelRum\".compras f ON p.compras_idcompras = f.idcompras " +
                         "    INNER JOIN \"HotelRum\".metodo_pago mp ON p.metodo_pago_idmetodo_pago = mp.idmetodo_pago " +
                         "    INNER JOIN \"HotelRum\".bancos b ON p.bancos_idbancos = b.idbancos " +
                         "    INNER JOIN \"HotelRum\".tipo_pago tp ON p.tipo_pago_id_tipo_pago = tp.idtipo_pago " +
                         "    INNER JOIN \"HotelRum\".usuarios u ON p.usuarios_idusuarios = u.idusuarios " +
                         "    LEFT JOIN \"HotelRum\".tipo_tarjeta t ON p.tipo_tarjeta_idtipo_tarjeta = t.idtipo_tarjeta " +
                         "    INNER JOIN \"HotelRum\".proveedores h ON p.proveedores_idproveedores = h.idproveedores " +
                         "WHERE " +
                          "    p.estado = 'Pagado' " +
                         "ORDER BY " +
                         "    p.idpagos DESC;";
            
            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
     <td><%= rs.getString("REF") %></td>
    <td><%= rs.getString("FECHA") %></td>
    <td><%= rs.getString("PROVEEDOR") %></td>
    <td><%= rs.getBigDecimal("MONTO") %></td>
    <td><%= rs.getString("METODO_DE_PAGO") %></td>
    <td><%= rs.getString("TIPO_PAGO") %></td>
    <td><%= rs.getString("BANCO") %></td>
    <td><%= rs.getString("TIPO_TARJETA") %></td>
    <td><%= rs.getString("ESTADO") %></td>
    <td><%= rs.getString("USUARIO") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarCiudad('<%= rs.getString("idciudades") %>', '<%= rs.getString("ciu_nombre") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarCiudadModal" onclick="$('#idciudades_e').val('<%= rs.getString("idciudades") %>')"></i>
        <a href="reporteVistaIndividual/reporteCiudad.jsp?ciu_GET=<%= rs.getString("idciudades") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error en la consulta SQL: " + e.getMessage());
        } 
    }else if ("listarPendiente".equals(listarParam)) {
        // Código para listar cobros
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            
            // SQL query to list payments
            String sql = "SELECT " +
                         "    p.idpagos AS REF, " +
                         "    p.fecha_pago AS FECHA, " +
                         "    h.prov_nombre AS PROVEEDOR, " +
                         "    p.monto AS MONTO, " +
                         "    mp.descripcion AS METODO_DE_PAGO, " +
                         "    tp.tipo_descripcion AS TIPO_PAGO, " +
                         "    b.ban_descripcion AS BANCO, " +
                         "    t.tar_descripcion AS TIPO_TARJETA, " +
                         "    p.estado AS ESTADO, " +
                         "    u.usu_nombre AS USUARIO " +
                         "FROM " +
                         "    \"HotelRum\".pagos p " +
                         "    INNER JOIN \"HotelRum\".compras f ON p.compras_idcompras = f.idcompras " +
                         "    INNER JOIN \"HotelRum\".metodo_pago mp ON p.metodo_pago_idmetodo_pago = mp.idmetodo_pago " +
                         "    INNER JOIN \"HotelRum\".bancos b ON p.bancos_idbancos = b.idbancos " +
                         "    INNER JOIN \"HotelRum\".tipo_pago tp ON p.tipo_pago_id_tipo_pago = tp.idtipo_pago " +
                         "    INNER JOIN \"HotelRum\".usuarios u ON p.usuarios_idusuarios = u.idusuarios " +
                         "    LEFT JOIN \"HotelRum\".tipo_tarjeta t ON p.tipo_tarjeta_idtipo_tarjeta = t.idtipo_tarjeta " +
                         "    INNER JOIN \"HotelRum\".proveedores h ON p.proveedores_idproveedores = h.idproveedores " +
                         "WHERE " +
                          "    p.estado = 'Pendiente' " +
                         "ORDER BY " +
                         "    p.idpagos DESC;";
            
            rs = st.executeQuery(sql);

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("REF") %></td>
    <td><%= rs.getString("FECHA") %></td>
    <td><%= rs.getString("PROVEEDOR") %></td>
    <td><%= rs.getBigDecimal("MONTO") %></td>
    <td><%= rs.getString("METODO_DE_PAGO") %></td>
    <td><%= rs.getString("TIPO_PAGO") %></td>
    <td><%= rs.getString("BANCO") %></td>
    <td><%= rs.getString("TIPO_TARJETA") %></td>
    <td><%= rs.getString("ESTADO") %></td>
    <td><%= rs.getString("USUARIO") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarCiudad('<%= rs.getString("idciudades") %>', '<%= rs.getString("ciu_nombre") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarCiudadModal" onclick="$('#idciudades_e').val('<%= rs.getString("idciudades") %>')"></i>
        <a href="reporteVistaIndividual/reporteCiudad.jsp?ciu_GET=<%= rs.getString("idciudades") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error en la consulta SQL: " + e.getMessage());
        } 
    }
/*else if ("insertarCobro".equals(listarParam)) {
    // Obtener los parámetros
    String idfactura = request.getParameter("idfactura");
    String metodoPago = request.getParameter("metodoPago");
    String monto = request.getParameter("monto");
    String banco = request.getParameter("banco");
    String tipoTarjeta = request.getParameter("tipoTarjeta");
    String nroTransaccion = request.getParameter("nro_transaccion");

    try {
        Statement st = conn.createStatement();
        // Inserta en la tabla cobros
        String sql = "INSERT INTO \"HotelRum\".\"cobros\" (factura_idfactura, metodo_pago_idmetodo_pago, monto, bancos_idbancos, tipo_tarjeta_idtipo_tarjeta, nro_transaccion) VALUES (" +
                     idfactura + ", " + metodoPago + ", " + monto + ", " + banco + ", " + tipoTarjeta + ", '" + nroTransaccion + "')";
        st.executeUpdate(sql);
        out.println("Pago registrado correctamente.");
    } catch (Exception e) {
        out.println("Error al insertar en cobros: " + e);
    }
}*/
%>