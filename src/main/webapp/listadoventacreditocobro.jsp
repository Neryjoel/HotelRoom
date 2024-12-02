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
    <legend><i class="fas fa-file-invoice"></i> &nbsp;LISTA COBROS</legend>
    <div class="button-container">
        <a href="reporteVistaGeneral/reporteCiudadGeneral.jsp" class="btn btn-raised btn-dark btn-sm d-flex align-items-center report-button">
            <i class="fas fa-file-alt mr-2"></i> Reporte
        </a>
    </div>
</div>

<style>
    .sidebar {
        float: left; /* Alinea a la izquierda */
        padding: 10px; /* Espacio alrededor del contenido */
        margin-right: 20px; /* Margen derecho para separación del contenido principal */
        display: flex;
        margin-top: -20px;
        flex-direction: column;
    }

    .button-container {
        display: flex;
        align-items: center; /* Alinea verticalmente en el centro */
        width: 100%; /* Asegura que el contenedor de los botones ocupe todo el ancho disponible */
        gap: 10px; /* Opcional: Espacio entre los botones */
    }

    .btn {
        margin: 0; /* Elimina el margen predeterminado de los botones */
    }

    .report-button {
        margin-left: -5px; /* Empuja el botón "Reporte" a la esquina derecha del contenedor */
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
    <table class="table table-dark" id="resultadoTablaFacturas">
        <thead>
            <tr>
                <th>REF.</th>
                <th>FECHA</th>
                <th>HUESPED</th>
                <th>NRO FACTURA</th>  <!-- traer de la tabla factura el numero con iiner join -->
                <th>NRO TRANSACCION</th>
                <th>MONTO</th>
                <th>METODO DE PAGO</th>
                <th>TIPO PAGO</th>
                <th>BANCO</th>
                <th>TIPO TARJETA</th>
                <th>ESTADO</th>
                <% if (sesion.getAttribute("rol") != null && sesion.getAttribute("rol").equals("Administrador")) { %>
                <th>USUARIO</th>
                <% } %>
            </tr>
        </thead>
        <tbody id="resultadoFacturas">
            <!-- Aquí se cargarán las facturas -->
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
<% }%>
<div id="respuesta"></div>


<script>
$(document).ready(function () {
    cargarTabla();
    
});

// Variable para indicar si la tabla ya ha sido inicializada
    var tablaInicializada = false;

function cargarTabla() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/cobrocrud.jsp',
        type: 'post',
        success: function (response) {
            $("#resultadoTablaFacturas tbody").html(response);

            // Initialize DataTable after loading content
            if (!tablaInicializada) {
                $('#resultadoTablaFacturas').DataTable({
                    "paging": true,
                    "searching": true,
                    "info": false,
                    "ordering": true,
                    "autoWidth": false
                });
                tablaInicializada = true;
            }
        }
    });
}



</script>
<%@include file="footer.jsp" %>
