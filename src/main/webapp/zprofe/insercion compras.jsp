<%@include file="conexion.jsp"%>
<%    if (request.getParameter("listar").equals("cargar")) {

        /*DATOS PARA LA CABECERA*/
        //idproveedor
        //fecha
        /*DATOS PARA EL DETALLE*/
        //idproducto
        //cantidad
        //precio
        String codproveedor = request.getParameter("codproveedor");
        String fecharegistro = request.getParameter("fecharegistro");
        String codproducto = request.getParameter("codproducto");
        String cantidad = request.getParameter("cantidad");
        String precio = request.getParameter("precio");
        //out.println(codproveedor + ',' + fecharegistro + ',' + codproducto + ',' + cantidad + ',' + precio);
        try {
            Statement st = null;
            ResultSet rs = null;
            ResultSet pk = null;
            st = conn.createStatement();
            rs = st.executeQuery("SELECT id FROM compras where estado='Pendiente';");
            if (rs.next()) {
                //out.println("Existe cabecera");
                st.executeUpdate("insert into detallecompras (idcompra,idproducto,cantidad,precio)values('" + rs.getString(1) + "','" + codproducto + "','" + cantidad + "','" + precio + "')");
            } else {
                //out.println("NO existe cabecera");

                st.executeUpdate("insert into compras (idproveedor,fecha)values('" + codproveedor + "','" + fecharegistro + "')");
                pk = st.executeQuery("SELECT id FROM compras where estado='Pendiente';");
                pk.next();
                st.executeUpdate("insert into detallecompras (idcompra,idproducto,cantidad,precio)values('" + pk.getString(1) + "','" + codproducto + "','" + cantidad + "','" + precio + "')");
            }

        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("listar")) {
        try {
            Statement st = null;
            ResultSet rs = null;
            ResultSet pk = null;
            st = conn.createStatement();
            pk = st.executeQuery("SELECT id FROM compras where estado='Pendiente';");
            pk.next();
            rs = st.executeQuery("select dt.id,p.descripcion,dt.cantidad, dt.precio from detallecompras dt, productos p where dt.idproducto=p.id and dt.idcompra='" + pk.getString(1) + "'");
            while (rs.next()) {
                String cantidad = rs.getString(3);
                String precio = rs.getString(4);
                Integer cantidad1 = Integer.parseInt(cantidad);
                Integer precio1 = Integer.parseInt(precio);
                int calcular = cantidad1 * precio1;
%>
<tr>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkdel').val(<%out.print(rs.getString(1));%>)"></i></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><%out.print(calcular);%></td>

</tr>
<%}
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    }else if (request.getParameter("listar").equals("listarsuma")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT id FROM compras where estado='Pendiente';");
        pk.next();
        rs = st.executeQuery("select dt.id,p.descripcion,dt.cantidad, dt.precio from detallecompras dt, productos p where dt.idproducto=p.id and dt.idcompra='" + pk.getString(1) + "'");
        int sumador = 0;
        while (rs.next()) {
            String cantidad = rs.getString(3);
            String precio = rs.getString(4);
            Integer cantidad1 = Integer.parseInt(cantidad);
            Integer precio1 = Integer.parseInt(precio);
            int calcular = cantidad1 * precio1;
            sumador += calcular;
        }
        out.println(sumador);
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("elimregcompra")) {

    String pk = request.getParameter("pkd");
    try {
        Statement st = null;
        st = conn.createStatement();
        st.executeUpdate("delete from detallecompras where id=" + pk + "");
        //out.println("<div class='alert alert-success' role='alert'>  Datos eliminados con exitos!</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("cancelcompra")) {

    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT id FROM compras where estado='Pendiente';");
        pk.next();
        st.executeUpdate("update compras set estado='Cancelado' where id=" + pk.getString(1) + "");
        //out.println("<div class='alert alert-success' role='alert'>  Datos modificados con exitos!</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("finalcompra")) {

    try {
        Statement st = null;
        ResultSet pk = null;
        st = conn.createStatement();
        pk = st.executeQuery("SELECT id FROM compras where estado='Pendiente';");
        pk.next();
        st.executeUpdate("update compras set estado='Finalizado', total=" + request.getParameter("total") + " where id=" + pk.getString(1) + "");
        //out.println("<div class='alert alert-success' role='alert'>  Datos modificados con exitos!</div>");
    } catch (Exception e) {
        out.println("error PSQL" + e);
    }
} else if (request.getParameter("listar").equals("listarcompras")) {
    try {
        Statement st = null;
        ResultSet rs = null;
        st = conn.createStatement();

        rs = st.executeQuery("select c.id,to_char(c.fecha,'dd-mm-YYYY'),p.razon_social,c.total from compras c, proveedores p where c.idproveedor = p.idproveedor and c.estado='Finalizado'");

        while (rs.next()) {

%>
<tr>

    <td><%out.print(rs.getString(1));%></td>
    <td><%out.print(rs.getString(2));%></td>
    <td><%out.print(rs.getString(3));%></td>
    <td><%out.print(rs.getString(4));%></td>
    <td><i class="fa fa-trash" data-toggle="modal" data-target="#exampleModal" onclick="$('#pkanul').val(<%out.print(rs.getString(1));%>)"></i></td>
</tr>
<%

            }
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    } else if (request.getParameter("listar").equals("anularcompras")) {
        
        try {
            Statement st = null;
            ResultSet pk = null;
            st = conn.createStatement();
            st.executeUpdate("update compras set estado='Anulado' where id=" + request.getParameter("idpkcompra") + "");
            //out.println("<div class='alert alert-success' role='alert'>  Datos modificados con exitos!</div>");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    }

%>