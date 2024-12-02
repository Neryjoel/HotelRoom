<%@ include file="conexion.jsp" %>

<%
String accion = request.getParameter("listar");
if (accion != null) {
    try {
        Statement st = conn.createStatement();

        if (accion.equals("listar")) {
            ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"categorias\" ORDER BY idcategorias ASC;");
            while (rs.next()) {
%>
<tr>
    <td><%= rs.getString("idcategorias") %></td>
    <td><%= rs.getString("cat_nombre") %></td>
    <td>
        <i class="fas fa-edit btn btn-success" onclick="rellenarEditarCategoria('<%= rs.getString("idcategorias") %>', '<%= rs.getString("cat_nombre") %>')"></i>
        <i class="fas fa-trash btn btn-danger" data-toggle="modal" data-target="#eliminarCategoriaModal" onclick="$('#idcategoria_e').val('<%= rs.getString("idcategorias") %>')"></i>
        <a href="reporteVistaIndividual/reporteCategoria.jsp?cat=<%= rs.getString("idcategorias") %>" class="btn btn-info">
            <i class="fas fa-eye"></i>
        </a>
    </td>
</tr>
<%
            }
        } else if (accion.equals("cargar")) {
            String nombre = request.getParameter("cat_nombre").trim();
            if (!nombre.isEmpty() && nombre.matches("^[a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_]+)*$")) {
                // Convertir a minúsculas para la comparación
                String nombreLower = nombre.toLowerCase();

                ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"categorias\" WHERE LOWER(cat_nombre) = '" + nombreLower + "'");
                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("categoria_existe");
                } else {
                    // Insertar sin cambiar el nombre original
                    st.executeUpdate("INSERT INTO \"HotelRum\".\"categorias\" (cat_nombre) VALUES('" + nombre + "')");
                    out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
                }
            } else {
                out.println("<div class='alert alert-danger' role='alert'>Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</div>");
            }
        } else if (accion.equals("modificar")) {
            String nombre = request.getParameter("cat_nombre").trim();
            String id = request.getParameter("idcategoria");

            // Convertir el nombre a minúsculas para la comparación
            String nombreLower = nombre.toLowerCase();

            ResultSet rs = st.executeQuery("SELECT cat_nombre FROM \"HotelRum\".\"categorias\" WHERE idcategorias='" + id + "'");
            rs.next();
            String nombreOriginal = rs.getString("cat_nombre");
            String nombreOriginalLower = nombreOriginal.toLowerCase();

            if (nombreLower.equals(nombreOriginalLower)) {
                // Si el nombre no ha cambiado, actualiza directamente
                st.executeUpdate("UPDATE \"HotelRum\".\"categorias\" SET cat_nombre='" + nombre + "' WHERE idcategorias='" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
            } else {
                // Si el nombre ha cambiado, verifica si el nuevo nombre ya existe
                ResultSet rsCheck = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"categorias\" WHERE LOWER(cat_nombre) = '" + nombreLower + "'");
                rsCheck.next();
                int count = rsCheck.getInt("count");

                if (count > 0) {
                    out.println("categoria_existe");
                } else {
                    st.executeUpdate("UPDATE \"HotelRum\".\"categorias\" SET cat_nombre='" + nombre + "' WHERE idcategorias='" + id + "'");
                    out.println("<div class='alert alert-success' role='alert'>Datos modificados con éxito!</div>");
                }
            }
        } else if (accion.equals("eliminar")) {
            String pk = request.getParameter("idpk");
            st.executeUpdate("DELETE FROM \"HotelRum\".\"categorias\" WHERE idcategorias=" + pk);
            out.println("<div class='alert alert-danger' role='alert'>Registro eliminado con éxito!</div>");
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}
%>
