<%@ include file="conexion.jsp" %>
<%
    Statement st = null;
    ResultSet rs = null;
    try {
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idciudades, ciu_nombre FROM \"HotelRum\".\"ciudades\" ORDER BY ciu_nombre ASC;");
        while (rs.next()) {
%>
            <option value="<%= rs.getString("idciudades") %>"><%= rs.getString("ciu_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    } finally {
        // Cerrar ResultSet y Statement
        try {
            if (rs != null) {
                rs.close();
            }
            if (st != null) {
                st.close();
            }
        } catch (SQLException e) {
            out.println("Error cerrando recursos: " + e);
        }
    }
%>