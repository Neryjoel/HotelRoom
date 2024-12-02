<%@include file="conexion.jsp" %>
<%
 if (request.getParameter("listar").equals("buscarmetodo_pago")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"metodo_pago\" ORDER BY idmetodo_pago ASC;");
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>,<%= rs.getString(2) %>"><%= rs.getString(2) %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("buscarbanco")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"bancos\" ORDER BY idbancos ASC;");
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>,<%= rs.getString(2) %>"><%= rs.getString(2) %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}else if (request.getParameter("listar").equals("buscartipo_tarjeta")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();
        rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"tipo_tarjeta\" ORDER BY idtipo_tarjeta ASC;");
%>
<option value="">Seleccionar</option>
<%
        while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>,<%= rs.getString(2) %>"><%= rs.getString(2) %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL" + e);
    }
}else if (request.getParameter("listar").equals("buscartipo_pago")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM \"HotelRum\".\"tipo_pago\" WHERE tipo_descripcion IN ('Contado') ORDER BY idtipo_pago ASC;");

        while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>"><%= rs.getString(2) %></option>
<%
        }
    } catch (Exception e) {
        out.println("Error PSQL: " + e);
    }
}

%>
