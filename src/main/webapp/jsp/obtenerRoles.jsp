<%@ include file="conexion.jsp" %>
<%
    Statement st = null;
    ResultSet rs = null;
    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idroles, rol_descripcion FROM \"HotelRum\".\"roles\" ORDER BY rol_descripcion ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idroles") %>"><%= rs.getString("rol_descripcion") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    } finally {
        // Cerrar el ResultSet y el Statement
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                out.println("Error al cerrar ResultSet: " + e);
            }
        }
        if (st != null) {
            try {
                st.close();
            } catch (SQLException e) {
                out.println("Error al cerrar Statement: " + e);
            }
        }
    }
%>