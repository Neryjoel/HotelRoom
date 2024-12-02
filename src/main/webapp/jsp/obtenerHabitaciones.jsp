<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT idhabitaciones, habi_descripcion FROM \"HotelRum\".\"habitaciones\" WHERE habi_estado = 'Disponible' ORDER BY habi_descripcion ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idhabitaciones") %>"><%= rs.getString("habi_descripcion") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
%>


