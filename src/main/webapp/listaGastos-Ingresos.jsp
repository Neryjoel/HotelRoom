<%@include file="header.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();
    // Formatear la fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css"/>

<style>
    .tab-content {
        margin-top: 15px;
    }
    .table-container {
        padding: 0 5px; /* Espaciado interno */
    }
    .table {
        width: 100%;
        table-layout: fixed; /* Asegura que la tabla ocupe el 100% del contenedor */
    }
    .tab-pane {
        display: none;
    }
    .tab-pane.active {
        display: block;
    }
    .nav-tabs {
        border-bottom: 1px solid #ddd;
    }
    .nav-tabs .nav-link {
        border: none;
        border-radius: 0.25rem;
        padding: 0.3rem 1rem;
        font-weight: bold;
        color: #333;
        background-color: #f7f7f7;
        transition: background-color 0.2s ease;
    }
    .nav-tabs .nav-link.active {
        background-color: #007bff;
        color: #fff;
        border-bottom: 2px solid #007bff;
    }
    .nav-tabs .nav-link:hover {
        background-color: #f2f2f2;
        color: #333;
    }
    .dropdown-menu {
        border-radius: 0.5rem;
    }
    .dropdown-item:hover {
        background-color: #f8f9fa; /* Color de fondo al pasar el mouse */
        color: #007bff; /* Color del texto al pasar el mouse */
    }
    .dropdown-header {
        font-weight: bold;
        color: #6c757d;
    }
</style>

<div class="container-fluid" style="padding: 5px;">
    <legend><i class="fas fa-cash-register"></i> &nbsp;ADMINISTRAR CAJA - MOVIMIENTO DE CAJA</legend>
    <div class="container-fluid mt-2">
        <div class="tab-content" style="margin-left: -20px; margin-right: -20px">
            <div class="tab-pane active" id="ingresos">
                <div class="table-container">
                    <table class="table table-dark" id="tablaIngresos">
                        <thead>
                            <tr>
                                <th>Referencia</th>
                                <th>ID Movimiento Caja</th>
                                <th>Fecha</th>
                                <th>Tipo de Movimiento</th>
                                <th>Monto</th>
                                <th>Número de Factura</th>
                                <th>Usuario</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Rows will be appended here by JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        </div>
</div>

<script>
    $(document).ready(function () {
        llenadoCaja();
    });

    function llenadoCaja() {
        $.ajax({
            data: {listar: 'listarmovimientosdetalle'},
            url: 'jsp/movimientocrud.jsp',
            type: 'post',
            success: function (response) {
                // Destroy the existing DataTable if it exists
                if ($.fn.DataTable.isDataTable('#tablaIngresos')) {
                    $('#tablaIngresos').DataTable().clear().destroy();
                }

                // Clear the table body and append new rows
                $("#tablaIngresos tbody").empty().append(response); // Assuming response contains <tr> rows

                // Re-initialize the DataTable with the updated content
                $('#tablaIngresos').DataTable({
                    "paging": true,
                    "searching": true,
                    "info": false,
                    "ordering": true,
                    "autoWidth": false
                });
            },
            error: function (xhr, status, error) {
                console.error("AJAX Error: ", status, error);
            }
        });
    }
</script>

<%@include file="footer.jsp" %>