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
    <legend><i class="fas fa-file-invoice"></i> &nbsp; NOTAS DE CRÉDITO</legend>
    <div class="button-container">
        <button type="button" class="btn btn-raised btn-info btn-sm" onclick="location.href = 'detallenotacredito.jsp'">Nueva Nota de Crédito</button>
        <a href="reporteVistaGeneral/reporteNotaCreditoGeneral.jsp" class="btn btn-raised btn-dark btn-sm d-flex align-items-center report-button">
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
        flex-direction: column;
    }

    .button-container {
        display: flex;
        align-items: center; /* Alinea verticalmente en el centro */
        width: 100%; /* Asegura que el contenedor de los botones ocupe todo el ancho disponible */
        gap: 10px; /* Espacio entre los botones */
    }

    .btn {
        margin: 0; /* Elimina el margen predeterminado de los botones */
    }

    .report-button {
        margin-left: auto; /* Empuja el botón "Reporte" a la esquina derecha del contenedor */
    }

    .table-container {
        padding: 5px; /* Espacio de 5px alrededor del contenido del contenedor */
    }

    .table {
        margin: 0; /* Asegura que la tabla no tenga márgenes adicionales */
    }
</style>

<div class="table-container">
    <table class="table table-dark" id="resultadoTablaNotaCredito">
        <thead>
            <tr>
                <th>REF.</th>
                <th>FECHA EMISIÓN</th>
                <th>MOTIVO</th>
                <th>TOTAL</th>
                <% if (sesion.getAttribute("rol") != null && sesion.getAttribute("rol").equals("Administrador")) { %>
                <th>USUARIO</th>
                <% } %>
                <th>ACCION</th>
            </tr>
        </thead>
        <tbody id="resultadoNotaCredito">
            <!-- Aquí se cargarán las notas de crédito -->
        </tbody>
    </table>
</div>

<% if (sesion.getAttribute("rol") != null && sesion.getAttribute("rol").equals("Administrador")) { %>
<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Nota de Crédito</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro de querer eliminar esta nota de crédito?
                <input type="hidden" name="pkanul" id="pkanul"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="anulnotaCredito">SI</button>
            </div>
        </div>
    </div>
</div>
<% } %>

<script>
    $(document).ready(function () {
        llenadonotacredito();
        $('#resultadoTablaNotaCredito').DataTable({
            "paging": true,
            "searching": true,
            "info": false
        });
    });

    function llenadonotacredito() {
        $.ajax({
            data: {listar: 'listarNotaCredito'}, // Ajusta el backend para manejar esto
            url: 'jsp/nota_creditocrud.jsp', // Ajusta la ruta a tu nuevo JSP para manejar nota_credito
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                var table = $('#resultadoTablaNotaCredito').DataTable();
                table.clear().destroy(); // Limpiar y destruir la DataTable
                $("#resultadoTablaNotaCredito tbody").html(response);
                $('#resultadoTablaNotaCredito').DataTable(); // Reinitialize DataTable
            }
        });
    }

    $("#anulnotaCredito").click(function () {
        var idnotaCredito = $("#pkanul").val();
        $.ajax({
            data: {listar: 'anularNotaCredito', idnotaCredito: idnotaCredito},
            url: 'jsp/nota_creditocrud.jsp',
            type: 'post',
            beforeSend: function () {
                //$("#resultado").html("Procesando, espere por favor...");
            },
            success: function (response) {
                llenadonotacredito(); // Rellenar la tabla después de anular
            }
        });
    });
</script>
<%@include file="footer.jsp" %>
