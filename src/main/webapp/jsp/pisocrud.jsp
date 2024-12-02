<%@ include file="conexion.jsp" %>

<%
String accion = request.getParameter("listar");
if (accion != null) {
    try {
        Statement st = conn.createStatement();

        // Manejo de la acción "listar" para mostrar botones de pisos
        if (accion.equals("listar")) {
            ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"pisos\" ORDER BY idpisos ASC;");

            // Verifica si hay resultados
            if (!rs.isBeforeFirst()) { // No hay filas
                out.println("<div class='alert alert-warning' role='alert'>No hay pisos disponibles.</div>");
            } else {
                // Limpiar salida anterior antes de iniciar nueva salida para botones
                out.println("<div class='btn-group mb-4' role='group' aria-label='Selector de Niveles' id='botonesPisos'>");
                out.println("<button type='button' class='btn' onclick=\"navigateLevel(this, 'all')\">Todos</button>");

                // Salida de botón para cada piso
                while (rs.next()) {
                    String piNombre = rs.getString("pi_nombre");
                    out.println("<button type='button' class='btn' onclick=\"navigateLevel(this, '" + piNombre + "')\">" + piNombre + "</button>");
                }
                out.println("</div>");
            }
            rs.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error: " + e + "</div>");
    }
}

// Este bloque se ejecuta fuera del if anterior, se recomienda asegurarse que 
// sólo se ejecute si se está haciendo una acción diferente a "listar".
if (accion != null && !accion.equals("listar")) {
    try {
        Statement st = conn.createStatement();

        // Manejo de la acción "cargar" para insertar un nuevo piso
        if (accion.equals("cargar")) {
            String nombre = request.getParameter("pi_nombre").trim();
            if (!nombre.isEmpty() && nombre.matches("^[A-ZÑÁÉÍÓÚ][a-zñáéíóúü]*( [A-ZÑÁÉÍÓÚ][a-zñáéíóúü]*)*$")) {
                String nombreLower = nombre.toLowerCase();

                ResultSet rs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"pisos\" WHERE LOWER(pi_nombre) = '" + nombreLower + "'");
                rs.next();
                int count = rs.getInt("count");

                if (count > 0) {
                    out.println("piso_existe");
                } else {
                    st.executeUpdate("INSERT INTO \"HotelRum\".\"pisos\" (pi_nombre) VALUES('" + nombre + "')");
                    out.println("<div class='alert alert-success' role='alert'>Datos insertados con éxito!</div>");
                }
            } else {
                out.println("<div class='alert alert-danger' role='alert'>Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</div>");
            }
        } 
            else if (accion.equals("modificar")) {
                String nombre = request.getParameter("pi_nombre").trim();
                String id = request.getParameter("idpisos");

                String nombreLower = nombre.toLowerCase();
                ResultSet rs = st.executeQuery("SELECT pi_nombre FROM \"HotelRum\".\"pisos\" WHERE idpisos='" + id + "'");
                if (rs.next()) {
                    String nombreOriginal = rs.getString("pi_nombre");
                    String nombreOriginalLower = nombreOriginal.toLowerCase();

                    if (nombreLower.equals(nombreOriginalLower)) {
                        out.println("<div class='alert alert-info' role='alert'>No se han realizado cambios.</div>");
                    } else {
                        ResultSet countRs = st.executeQuery("SELECT COUNT(*) AS count FROM \"HotelRum\".\"pisos\" WHERE LOWER(pi_nombre) = '" + nombreLower + "' AND idpisos != '" + id + "'");
                        countRs.next();
                        int count = countRs.getInt("count");

                        if (count > 0) {
                            out.println("piso_existe");
                        } else {
                            st.executeUpdate("UPDATE \"HotelRum\".\"pisos\" SET pi_nombre = '" + nombre + "' WHERE idpisos = '" + id + "'");
                            out.println("<div class='alert alert-success' role='alert'>Datos actualizados con éxito!</div>");
                        }
                    }
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>Piso no encontrado.</div>");
                }
            }

            // Manejo de la acción "eliminar" para borrar un piso
            else if (accion.equals("eliminar")) {
                String id = request.getParameter("idpisos");
                st.executeUpdate("DELETE FROM \"HotelRum\".\"pisos\" WHERE idpisos = '" + id + "'");
                out.println("<div class='alert alert-success' role='alert'>Piso eliminado con éxito!</div>");
            }

            st.close();
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
        } catch (Exception e) {
            out.println("<div class='alert alert-danger' role='alert'>Error: " + e + "</div>");
        }
    }
%>