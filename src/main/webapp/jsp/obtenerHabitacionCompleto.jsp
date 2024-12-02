<%@ include file="conexion.jsp" %>
<%
if (request.getParameter("listar") != null && request.getParameter("listar").equals("listarHabitaciones")) {
    String numeroHabitacion = request.getParameter("idHabitacionEditar");
    
    try {
        Statement st = conn.createStatement();
        String query = "SELECT h.*, p.pi_nombre FROM \"HotelRum\".\"habitaciones\" h " +
                      "LEFT JOIN \"HotelRum\".\"pisos\" p ON h.pisos_idpisos = p.idpisos " +
                      "WHERE h.habi_estado = 'Disponible' ";
        
        // Si hay una habitación siendo editada, incluirla en los resultados
        if (numeroHabitacion != null && !numeroHabitacion.isEmpty()) {
            query += "OR h.habi_nombre = " + numeroHabitacion + " ";
        }
        
        query += "ORDER BY h.idhabitaciones ASC;";
        
        ResultSet rs = st.executeQuery(query);
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
    <option value="<%= rs.getInt("idhabitaciones") %>,<%= rs.getString("habi_descripcion") %>,<%= rs.getString("habi_estado") %>,<%= rs.getDouble("habi_precio") %>,<%= rs.getInt("habi_capacidad") %>,<%= rs.getInt("pisos_idpisos") %>,<%= rs.getInt("habi_nombre") %>,<%= rs.getString("pi_nombre") %>">
        <%= rs.getInt("habi_nombre") %> | <%= rs.getString("pi_nombre") %>
    </option>
<%
        }
    } catch (Exception e) {
        out.print("Error PSQL: " + e.getMessage());
    }
}
%>