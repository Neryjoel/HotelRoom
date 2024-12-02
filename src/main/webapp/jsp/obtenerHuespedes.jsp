<%@ include file="conexion.jsp" %>
<%
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"huespedes\" ORDER BY hues_nombre ASC;");
        while (rs.next()) {
%>
<option value="<%= rs.getString("idhuespedes") %>"><%= rs.getString("hues_nombre") %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
%>
