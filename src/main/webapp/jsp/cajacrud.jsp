<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="conexion.jsp" %>

<%    String listarParam = request.getParameter("listar");
    HttpSession sesion = request.getSession();
    String userId = sesion.getAttribute("id").toString(); // Obtener ID del usuario logueado
    String userRole = sesion.getAttribute("rol").toString(); // Obtener rol del usuario logueado

    if ("listar".equals(listarParam)) {
        // Código para listar movimientos de caja
        try {
            String query;
            if ("Administrador".equals(userRole)) {
                // Si el usuario es Administrador, cargar todos los movimientos
                query = "SELECT "
                        + "mc.idmovimiento_caja AS idmovimiento_caja, "
                        + "c.caja_nombre AS caja_nombre, "
                        + "mc.fecha_apertura AS fecha_apertura, "
                        + "mc.fecha_cierre AS fecha_cierre, "
                        + "mc.saldo_inicial AS saldo_inicial, "
                        + "mc.saldo_disponible AS saldo_disponible, "
                        + "mc.estado AS estados, "
                        + "u.usu_nombre AS usuario "
                        + "FROM "
                        + "\"HotelRum\".movimiento_caja mc "
                        + "INNER JOIN \"HotelRum\".cajas c ON mc.cajas_idcajas = c.idcajas "
                        + "INNER JOIN \"HotelRum\".usuarios u ON mc.usuarios_idusuarios = u.idusuarios "
                        + "ORDER BY mc.idmovimiento_caja ASC;";
            } else {
                // Si no es Administrador, cargar solo los movimientos del usuario logueado
                query = "SELECT "
                        + "mc.idmovimiento_caja AS idmovimiento_caja, "
                        + "c.caja_nombre AS caja_nombre, "
                        + "mc.fecha_apertura AS fecha_apertura, "
                        + "mc.fecha_cierre AS fecha_cierre, "
                        + "mc.saldo_inicial AS saldo_inicial, "
                        + "mc.saldo_disponible AS saldo_disponible, "
                        + "mc.estado AS estados, "
                        + "u.usu_nombre AS usuario "
                        + "FROM "
                        + "\"HotelRum\".movimiento_caja mc "
                        + "INNER JOIN \"HotelRum\".cajas c ON mc.cajas_idcajas = c.idcajas "
                        + "INNER JOIN \"HotelRum\".usuarios u ON mc.usuarios_idusuarios = u.idusuarios "
                        + "WHERE mc.usuarios_idusuarios = ? "
                        + "ORDER BY mc.idmovimiento_caja ASC;";
            }

            // Usar PreparedStatement
            PreparedStatement pstmt = conn.prepareStatement(query);
            if (!"Administrador".equals(userRole)) {
                pstmt.setInt(1, Integer.parseInt(userId)); // Asumiendo que userId es un número entero
            }

            ResultSet rs = pstmt.executeQuery(); // Ejecutar la consulta y obtener resultados

            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm"); // Formato deseado

            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idmovimiento_caja")%></td>
    <td><%= rs.getString("caja_nombre")%></td>
    <td><%= rs.getTimestamp("fecha_apertura") != null ? dateFormat.format(rs.getTimestamp("fecha_apertura")) : ""%></td>
    <td><%= rs.getTimestamp("fecha_cierre") != null ? dateFormat.format(rs.getTimestamp("fecha_cierre")) : ""%></td>
    <td><%= rs.getBigDecimal("saldo_inicial")%></td>
    <td><%= rs.getBigDecimal("saldo_disponible")%></td>
    <td><%= rs.getString("estados")%></td>
    <td><%= rs.getString("usuario")%></td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error en la consulta SQL: " + e.getMessage());
            e.printStackTrace(); // Para depuración
        }
    }
 else if ("guardar".equals(listarParam)) {
        try {
            String saldoInicial = request.getParameter("saldo_inicial");
            String cajasIdcajas = request.getParameter("cajas_idcajas");
            String usuariosIdusuarios = request.getParameter("usuarios_idusuarios");

            // Conversión adecuada para los tipos de datos
            BigDecimal saldoInicialNumeric = new BigDecimal(saldoInicial); // Manejar excepciones
            int cajasId = Integer.parseInt(cajasIdcajas); // Conversión a entero
            int usuariosId = Integer.parseInt(usuariosIdusuarios); // Conversión a entero

            String insertQuery = "INSERT INTO \"HotelRum\".movimiento_caja "
                    + "(saldo_inicial, saldo_disponible, cajas_idcajas, usuarios_idusuarios, estado) "
                    + "VALUES (?, ?, ?, ?, 'Abierto')";
            PreparedStatement pst = conn.prepareStatement(insertQuery);
            pst.setBigDecimal(1, saldoInicialNumeric);
            pst.setBigDecimal(2, saldoInicialNumeric);
            pst.setInt(3, cajasId);
            pst.setInt(4, usuariosId);
            pst.executeUpdate();

out.println("<script>mostrarAlerta('Caja aperturada con éxito.', 'success');</script>");
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger' role='alert'>Error de SQL: " + e.getMessage() + "</div>");
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>Error de formato numérico: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            out.println("<div class='alert alert-danger' role='alert'>Error: " + e.getMessage() + "</div>");
        }
    } else if ("cerrar".equals(listarParam)) {
    try {
        int userIdInt = Integer.parseInt(userId);

        // Consulta para cerrar la caja y establecer la fecha de cierre
        String query = "UPDATE \"HotelRum\".movimiento_caja " +
                       "SET estado = 'Cerrado', " +
                       "    fecha_cierre = CURRENT_TIMESTAMP " + // Establece la fecha de cierre actual
                       "WHERE estado = 'Abierto' " +
                       "AND usuarios_idusuarios = ?";
        
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setInt(1, userIdInt);
        
        int rowsAffected = pst.executeUpdate();

        if (rowsAffected > 0) {
out.print("<script>mostrarAlerta('Caja cerrada con éxito.', 'success');</script>");        
} else {
            out.print("<div class='alert alert-warning' role='alert'>No hay caja abierta para cerrar.</div>");
        }
    } catch (SQLException e) {
        out.print("<div class='alert alert-danger' role='alert'>Error de SQL: " + e.getMessage() + "</div>");
    } catch (NumberFormatException e) {
        out.print("<div class='alert alert-danger' role='alert'>Error: ID de usuario inválido</div>");
    } catch (Exception e) {
        out.print("<div class='alert alert-danger' role='alert'>Error: " + e.getMessage() + "</div>");
    }
} else if ("verificar".equals(listarParam)) {
    try {
        int userIdInt = Integer.parseInt(userId);

        String query = "SELECT COUNT(*) AS total FROM \"HotelRum\".movimiento_caja " +
                       "WHERE estado = 'Abierto' AND usuarios_idusuarios = ?";
        PreparedStatement pst = conn.prepareStatement(query);
        pst.setInt(1, userIdInt);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            int totalAbiertas = rs.getInt("total");
            // Imprimir exactamente "abierta" o "cerrada"
            out.print(totalAbiertas > 0 ? "abierta" : "cerrada");
        }
    } catch (Exception e) {
        // Manejar errores
        System.err.println("Error en verificación de caja: " + e.getMessage());
        out.print("error");
    }
}
%>
