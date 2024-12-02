<%@ include file="conexion.jsp" %>
<%    if (request.getParameter("listar").equals("listar")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT a.idarticulos, a.art_nombre, a.art_precio_compra, a.art_precio_venta, a.stock_min, a.art_tipo, a.art_iva, c.cat_nombre "
                    + "FROM \"HotelRum\".\"articulos\" a "
                    + "LEFT JOIN \"HotelRum\".\"categorias\" c ON a.categorias_idcategorias = c.idcategorias "
                    + "ORDER BY a.idarticulos ASC;");
            while (rs.next()) {
%>
<tr>
    <td><%out.print(rs.getString("idarticulos"));%></td>
    <td><%out.print(rs.getString("art_nombre"));%></td>
    <td><%out.print(rs.getString("art_precio_compra"));%></td>
    <td><%out.print(rs.getString("art_precio_venta"));%></td>
    <td><%out.print(rs.getString("stock_min"));%></td>
    <td><%out.print(rs.getString("art_iva"));%></td>
    <td><%out.print(rs.getString("art_tipo"));%></td>
    <td><%out.print(rs.getString("cat_nombre"));%></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarArticulo('<%= rs.getString("idarticulos")%>', '<%= rs.getString("art_nombre")%>', '<%= rs.getString("art_precio_compra")%>', '<%= rs.getString("art_precio_venta")%>', '<%= rs.getString("stock_min")%>', '<%= rs.getString("art_iva")%>', '<%= rs.getString("art_tipo")%>', '<%= rs.getString("cat_nombre")%>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarArticuloModal" onclick="$('#idarticulos_e').val('<%= rs.getString("idarticulos")%>')"></i>
    </td>
</tr>
<%
            }
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    } else if ("cargar".equals(request.getParameter("listar"))) {
        String nombre = request.getParameter("art_nombre").trim();
        String tipo = request.getParameter("art_tipo").trim();
        String iva = request.getParameter("art_iva").trim();
        String categoria = request.getParameter("categorias_idcategorias");

        int precioVenta, precioCompra = 0, stockMin = 0;

        // Validar y convertir los precios y stock solo si el tipo es "Articulo"
        try {
            precioVenta = Integer.parseInt(request.getParameter("art_precio_venta"));

            if ("Articulo".equals(tipo)) {
                precioCompra = Integer.parseInt(request.getParameter("art_precio_compra"));
                stockMin = Integer.parseInt(request.getParameter("stock_min"));
            }
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger' role='alert'>Precio o Stock inválido!</div>");
            return;
        }

        if (!nombre.isEmpty() && tipo != null && iva != null && (!"Articulo".equals(tipo) || categoria != null)) {
            try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(
                    "SELECT COUNT(*) AS count FROM \"HotelRum\".\"articulos\" WHERE TRIM(LOWER(art_nombre)) = TRIM(LOWER('" + nombre + "'))")) {

                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("articulo_existe");
                } else {
                    String insertQuery = "INSERT INTO \"HotelRum\".\"articulos\" (art_nombre, art_tipo, art_precio_venta, art_iva";

                    // Campos adicionales para "Articulo"
                    if ("Articulo".equals(tipo)) {
                        insertQuery += ", art_precio_compra, stock_min, categorias_idcategorias";
                    }

                    insertQuery += ") VALUES ('" + nombre + "', '" + tipo + "', " + precioVenta + ", '" + iva + "'";

                    if ("Articulo".equals(tipo)) {
                        insertQuery += ", " + precioCompra + ", " + stockMin + ", " + categoria;
                    }

                    insertQuery += ")";

                    st.executeUpdate(insertQuery);
                    out.println("<div class='alert alert-success' role='alert'>Artículo insertado con éxito!</div>");
                }
            } catch (Exception e) {
                out.println("Error PSQL: " + e.getMessage());
            }
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Por favor, complete todos los campos correctamente.</div>");
        }
    } else if (request.getParameter("listar").equals("modificar")) {
    String nombre = request.getParameter("art_nombre").trim();
    String precioCompra = request.getParameter("art_precio_compra").trim();
    String precioVenta = request.getParameter("art_precio_venta").trim();
    String stockMin = request.getParameter("stock_min").trim();
    String iva = request.getParameter("art_iva").trim();
    String tipo = request.getParameter("art_tipo").trim();
    String categoria = request.getParameter("categorias_idcategorias");
    String id = request.getParameter("idarticulos");

    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT art_nombre FROM \"HotelRum\".\"articulos\" WHERE idarticulos='" + id + "'");
        rs.next();
        String nombreOriginal = rs.getString("art_nombre");

        // Verificar si el nombre ha cambiado
        boolean nombreCambiado = !nombre.equals(nombreOriginal);

        // Verificar si el nuevo nombre ya existe en la base de datos
        if (nombreCambiado) {
            rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"articulos\" WHERE art_nombre = '" + nombre + "'");
            rs.next();
            int count = rs.getInt("count");

            if (count > 0) {
                out.println("articulo_existe");
                return; // Salir si el artículo ya existe
            }
        }

        // Actualizar según el tipo de artículo
        if ("Articulo".equals(tipo)) {
            // Para artículos, incluir todos los campos
            st.executeUpdate("UPDATE \"HotelRum\".\"articulos\" SET art_nombre='" + nombre + "', art_precio_compra=" + precioCompra + ", art_precio_venta=" + precioVenta + ", stock_min=" + stockMin + ", art_iva='" + iva + "', art_tipo='" + tipo + "', categorias_idcategorias=" + categoria + " WHERE idarticulos='" + id + "'");
        } else {
            // Para servicios, no incluir precio de compra, stock mínimo ni categoría
            st.executeUpdate("UPDATE \"HotelRum\".\"articulos\" SET art_nombre='" + nombre + "', art_precio_venta=" + precioVenta + ", art_iva='" + iva + "', art_tipo='" + tipo + "' WHERE idarticulos='" + id + "'");
        }

        out.println("<div class='alert alert-success' role='alert'>Artículo modificado con éxito!</div>");
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("eliminar")) {
        String pk = request.getParameter("idpk");
        try {
            Statement st = null;
            st = conn.createStatement();
            st.executeUpdate("DELETE FROM \"HotelRum\".\"articulos\" WHERE idarticulos=" + pk);
            out.println("<div class='alert alert-danger' role='alert'>Artículo eliminado con éxito!</div>");
        } catch (Exception e) {
            out.println("Error PSQL: " + e);
        }
    }
%>