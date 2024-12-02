<%@include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<br>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<div class="sidebar">
    <legend><i class="fas fa-file-invoice"></i> &nbsp; FACTURAS</legend>
    <div class="button-container">
        <!--  
        <button type="button" class="btn btn-raised btn-info btn-sm" onclick="location.href = 'factura_has_servicios.jsp'">Nueva Compra</button>
        -->
        <a href="reporteVistaGeneral/reporteCiudadGeneral.jsp" class="btn btn-raised btn-dark btn-sm d-flex align-items-center report-button">
            <i class="fas fa-file-alt mr-2"></i> Reporte
        </a>
    </div>
</div>

<style>
    .sidebar {
        float: left; /* Alinea a la izquierda */
        padding: 5px; /* Espacio alrededor del contenido */
        margin-right: 20px; /* Margen derecho para separación del contenido principal */
        margin-top: -20px;
        display: flex;
        flex-direction: column;
    }


    .btn {
        margin: 0; /* Elimina el margen predeterminado de los botones */
    }

    .report-button {
        margin-left: auto; /* Empuja el botón "Reporte" a la esquina derecha del contenedor */
    }

    .btn-info {
        /* Personaliza el botón si es necesario */
    }

    .btn-dark {
        /* Personaliza el botón si es necesario */
    }
    .table-container {
        padding: 5px; /* Espacio de 5px alrededor del contenido del contenedor */
    }

    .table {
        margin: 0; /* Asegura que la tabla no tenga márgenes adicionales */
    }
</style>

<div class="table-container">
    <table class="table table-dark" id="resultadoTablaCompras">
        <thead>
            <tr>
                <th>REF.</th>
                <th>FECHA</th>
                <th>HUESPED</th>
                <th>TOTAL</th>
                <% if (sesion.getAttribute("rol") != null && sesion.getAttribute("rol").equals("Administrador")) { %>
                <th>USUARIO</th>
                <% } %>
                <th>ACCION</th>
            </tr>
        </thead>
        <tbody id="resultadoCompras">
            <!-- Aquí se cargarán las compras -->
        </tbody>
    </table>
</div>

<% if (sesion.getAttribute("rol") != null && sesion.getAttribute("rol").equals("Administrador")) { %>
<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Compra</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Esta seguro de querer eliminar la compra?
                <input type="hidden" name="pkanul" id="pkanul"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="anulcompra">SI</button>
            </div>
        </div>
    </div>
</div>
<% } %>
<script>
    $(document).ready(function () {
        llenadocompras();
        $('#resultadoTablaCompras').DataTable({
            "paging": true,
            "searching": true,
            "info": false
        });
    });

    function llenadocompras() {
        $.ajax({
            data: {listar: 'listarcompras'},
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                var table = $('#resultadoTablaCompras').DataTable();
                table.clear().destroy(); // Clear and destroy the DataTable
                $("#resultadoTablaCompras tbody").html(response);
                $('#resultadoTablaCompras').DataTable(); // Reinitialize DataTable
            }
        });
    }

    $("#anulcompra").click(function () {
        idpkcompra = $("#pkanul").val();
        $.ajax({
            data: {listar: 'anularcompras', idpkcompra: idpkcompra},
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                llenadocompras(); // ESTA FUNCION SE COLOCA PARA VOLVER A RELLENAR UNA VES QUE SE ANULE UNA COMPRA
                //sumador();
            }
        });
    });
</script>
<%@include file="footer.jsp" %>
