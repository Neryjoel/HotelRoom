<%@ include file="conexion.jsp" %>
<%
if ("insertarCobro".equals(request.getParameter("listar"))) {
    try {
        // Obtener par�metros
        String facturaId = request.getParameter("facturaId");
        String metodoPagoId = request.getParameter("metodoPagoId");
        String monto = request.getParameter("monto");
        String bancoId = request.getParameter("bancoId");
        String tipoTarjetaId = request.getParameter("tipoTarjetaId");
        String nroTransaccion = request.getParameter("nroTransaccion");

        // Depuraci�n de par�metros recibidos
        System.out.println("Par�metros recibidos:");
        System.out.println("FacturaId: " + facturaId);
        System.out.println("MetodoPagoId: " + metodoPagoId);
        System.out.println("Monto: " + monto);
        System.out.println("BancoId: " + bancoId);
        System.out.println("TipoTarjetaId: " + tipoTarjetaId);
        System.out.println("NroTransaccion: " + nroTransaccion);

        // Validaciones
        if (facturaId == null || facturaId.isEmpty() || "0".equals(facturaId)) {
            out.println("Error: ID de factura inv�lido");
            return;
        }

        // Obtener ID de usuario de la sesi�n
        HttpSession sesion = request.getSession();
        String userId = (String) sesion.getAttribute("id");

        // Preparar consulta para obtener el ID del movimiento de caja actual
        PreparedStatement pstmMovimiento = conn.prepareStatement(
            "SELECT idmovimiento_caja FROM \"HotelRum\".\"movimiento_caja\" " +
            "WHERE usuarios_idusuarios = ? AND estado = 'Abierto' " +
            "ORDER BY fecha_apertura DESC LIMIT 1"
        );
        pstmMovimiento.setInt(1, Integer.parseInt(userId));
        ResultSet rsMovimiento = pstmMovimiento.executeQuery();
        
        int idMovimientoCaja = 0;
        if (rsMovimiento.next()) {
            idMovimientoCaja = rsMovimiento.getInt("idmovimiento_caja");
        } else {
            out.println("Error: No se encontr� movimiento de caja abierto");
            return;
        }

        // Preparar consulta para obtener el ID del hu�sped
        PreparedStatement pstmHuesped = conn.prepareStatement(
            "SELECT huespedes_idhuespedes FROM \"HotelRum\".\"reservas\" " +
            "WHERE idreservas = (SELECT reservas_idreservas FROM \"HotelRum\".\"factura\" WHERE idfactura = ?)"
        );
        pstmHuesped.setInt(1, Integer.parseInt(facturaId));
        ResultSet rsHuesped = pstmHuesped.executeQuery();
        
        int idHuesped = 0;
        if (rsHuesped.next()) {
            idHuesped = rsHuesped.getInt("huespedes_idhuespedes");
        } else {
            out.println("Error: No se encontr� hu�sped para la factura");
            return;
        }

        // Preparar consulta de inserci�n con manejo detallado de par�metros
        String sqlInsertCobro = "INSERT INTO \"HotelRum\".cobros (" +
            "factura_idfactura, metodo_pago_idmetodo_pago, monto, " +
            "bancos_idbancos, tipo_tarjeta_idtipo_tarjeta, " +
            "huespedes_idhuespedes, usuarios_idusuarios, " +
            "movimiento_caja_idmovimiento, nro_transaccion, estado) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, " +
            "CASE " +
            "    WHEN (SELECT tipo_descripcion FROM \"HotelRum\".tipo_pago WHERE idtipo_pago = ?) = 'Contado' THEN 'Cobrado' " +
            "    WHEN (SELECT tipo_descripcion FROM \"HotelRum\".tipo_pago WHERE idtipo_pago = ?) = 'Despues' THEN 'Pendiente' " +
            "    ELSE 'Pendiente' " +
            "END)";

        PreparedStatement pstmInsertCobro = conn.prepareStatement(sqlInsertCobro);
        
        // Establecer par�metros con validaciones exhaustivas
        pstmInsertCobro.setInt(1, Integer.parseInt(facturaId));
        pstmInsertCobro.setInt(2, Integer.parseInt(metodoPagoId));
        pstmInsertCobro.setDouble(3, Double.parseDouble(monto));
        
        // Manejo de Banco (con validaci�n expl�cita)
        if (bancoId != null && !bancoId.trim().isEmpty()) {
            try {
                int bancoIdInt = Integer.parseInt(bancoId);
                pstmInsertCobro.setInt(4, bancoIdInt);
                System.out.println("Banco insertado: " + bancoIdInt);
            } catch (NumberFormatException e) {
                pstmInsertCobro.setNull(4, java.sql.Types.INTEGER);
                System.out.println("Banco no v�lido, se insertar� como NULL");
            }
        } else {
            pstmInsertCobro.setNull(4, java.sql.Types.INTEGER);
            System.out.println("Banco no proporcionado, se insertar� como NULL");
        }
        
        // Manejo de Tipo de Tarjeta (con validaci�n expl�cita)
        if (tipoTarjetaId != null && !tipoTarjetaId.trim().isEmpty()) {
            try {
                int tipoTarjetaIdInt = Integer.parseInt(tipoTarjetaId);
                pstmInsertCobro.setInt(5, tipoTarjetaIdInt);
                System.out.println("Tipo Tarjeta insertado: " + tipoTarjetaIdInt);
            } catch (NumberFormatException e) {
                pstmInsertCobro.setNull(5, java.sql.Types.INTEGER);
                System.out.println("Tipo Tarjeta no v�lido, se insertar� como NULL");
            }
        } else {
            pstmInsertCobro.setNull(5, java.sql.Types.INTEGER);
            System.out.println("Tipo Tarjeta no proporcionado, se insertar� como NULL");
        }
        
        // Establecer resto de par�metros
        pstmInsertCobro.setInt(6, idHuesped);
        pstmInsertCobro.setInt(7, Integer.parseInt(userId));
        pstmInsertCobro.setInt(8, idMovimientoCaja);
        
        // Manejo de N�mero de Transacci�n
        if (nroTransaccion != null && !nroTransaccion.trim().isEmpty()) {
            pstmInsertCobro.setString(9, nroTransaccion);
            System.out.println("N�mero de Transacci�n insertado: " + nroTransaccion);
        } else {
            pstmInsertCobro.setNull(9, java.sql.Types.VARCHAR);
            System.out.println("N�mero de Transacci�n no proporcionado, se insertar� como NULL");
        }

        // Establecer el m�todo de pago como par�metro para el CASE
        pstmInsertCobro.setInt(10, Integer.parseInt(metodoPagoId)); // Para el primer CASE
        pstmInsertCobro.setInt(11, Integer.parseInt(metodoPagoId)); // Para el segundo CASE

        // Ejecutar inserci�n con manejo de errores
        try {
            int filasAfectadas = pstmInsertCobro.executeUpdate();
            
            if (filasAfectadas > 0) {
                out.println("Cobro insertado exitosamente");
                System.out.println("Cobro insertado con �xito para la factura: " + facturaId);
            } else {
                out.println("Error: No se pudo insertar el cobro");
                System.out.println("No se insert� ning�n cobro para la factura: " + facturaId);
            }
        } catch (SQLException sqlEx) {
            // Registro detallado de errores SQL
            System.err.println("Error SQL detallado al insertar cobro:");
            System.err.println("Mensaje: " + sqlEx.getMessage());
            System.err.println("C�digo de error SQL: " + sqlEx.getErrorCode());
            System.err.println("Estado SQL: " + sqlEx.getSQLState());
            
            out.println("Error SQL al insertar cobro: " + sqlEx.getMessage());
        }

    } catch (Exception e) {
        // Manejo de errores generales
        System.err.println("Error general en inserci�n de cobro:");
        e.printStackTrace();
        
        out.println("Error inesperado: " + e.getMessage());
    } finally {
        // Cerrar recursos
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error al cerrar conexi�n: " + e.getMessage());
        }
    }
}
%>