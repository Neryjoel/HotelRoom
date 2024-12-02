<%@include file="header.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Obtener la fecha y hora actual
    Timestamp fechaActual = new Timestamp(System.currentTimeMillis());
    // Formatear la fecha en el formato requerido
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
    .container-fluid {
        padding-left: 15px;
        padding-right: 15px;
    }

    .tab-content {
        margin-top: 15px;
    }

    .table-container {
        padding-left: 5px;
        padding-right: 5px;
    }

    .table {
        width: 100%;
        table-layout: fixed;

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
        padding: 0.5rem 1rem;
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
</style>
<input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
<div class="container-fluid" style="padding: 5px;">
    <legend><i class="fas fa-cash-register"></i> &nbsp;ADMINISTRAR CAJA - MOVIMIENTO DE CAJA</legend>



    <div class="dropdown">
        <button class="btn btn-raised btn-info btn-sm dropdown-toggle" type="button" id="dropdownMenuButton" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-cog" style="margin-right: 5px;"></i> Opciones
        </button>
        <div class="dropdown-menu dropdown-menu-left" aria-labelledby="dropdownMenuButton" style="width: 120px;">

            <a class="dropdown-item" href="#" id="abrirCajaButton" data-toggle="modal" data-target="#abrirCajaModal" style="display: none;">
                <i class="fas fa-folder-open"></i> Abrir Caja
            </a>

            <a class="dropdown-item" href="#" id="cerrarCajaButton" style="display: none;">
                <i class="fas fa-folder-minus"></i> Cerrar Caja
            </a>

            <a class="dropdown-item" href="#">
                <i class="fas fa-balance-scale"></i> Ajuste Saldo
            </a>

        </div>
        <a href="reporteVistaGeneral/reporteCiudadGeneral.jsp" class="btn btn-raised btn-dark btn-sm report-button">
            <i class="fas fa-file-alt mr-2"></i> Reporte
        </a>
    </div>

<!-- Modal for Opening Caja -->
<div class="modal fade" id="abrirCajaModal" tabindex="-1" aria-labelledby="abrirCajaModalLabel" aria-hidden="true">
    <div class="modal-dialog"> <!-- Usar modal-lg para un tamaño más grande -->
        <div class="modal-content">
            <div class="modal-header" style="background-color: rgba(0, 0, 0, 0.85);"> <!-- Cambiado a negro opaco -->
                <h5 class="modal-title" id="abrirCajaModalLabel" style="color: white;">Abrir Caja</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="cajaForm">
                    <table class="payment-table" style="width: 100%;">
                        <thead>
                            <tr>
                                <th>Fecha</th>
                                <th>Saldo Inicial</th>
                                <th>Caja</th> <!-- Añadir un campo para ID de caja -->
                                <th>Usuario</th> <!-- Añadir un campo para ID de usuario -->
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="clon">
                                <td>
                                    <input type="datetime-local" class="form-control" id="fecha_apertura" name="fecha_apertura" value="<%= fechaFormateada %>" required>
                                </td>
                                <td>
                                    <input type="number" placeholder="Monto" id="saldo_inicial" name="saldo_inicial" class="form-control" required>
                                </td>
                                <td>
                                    <input type="hidden" id="codcajas" name="codcajas" class="form-control" placeholder="Ingrese Caja">
                                    <select id="cajas_idcajas" name="cajas_idcajas" class="form-control" onchange="dividircaja(this.value)">
                                        <!-- Aquí se cargarán las cajas vinculadas al usuario -->
                                    </select>
                                </td>
                                <td>
                                    <input type="hidden" id="codusuarios" name="codusuarios" class="form-control" placeholder="Ingrese Usuario">
                                    <select id="usuarios_idusuarios" name="usuarios_idusuarios" class="form-control" onchange="dividirusuario(this.value)">
                                        <!-- Aquí se cargará el usuario logueado -->
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="guardarCaja">Apertura</button>
            </div>
        </div>
    </div>
</div>

<style>
    .modal-dialog {
    max-width: 600px; /* Ajusta este valor según tus necesidades */
}
    .payment-table input[type="datetime-local"],
    .payment-table input[type="number"],
    .payment-table select {
        width: 98%; /* Ajusta el ancho para que sea un poco más pequeño */
        height: 36px; /* Ajusta la altura */
        padding: 8px; /* Asegura un padding uniforme */
        border: 1px solid #ced4da; /* Asegura que el borde sea el mismo */
        border-radius: 0.25rem; /* Coincide con los bordes del input */
        margin-bottom: 15px; /* Ajusta el margen inferior para mayor separación */
        font-size: 14px; /* Ajusta el tamaño de la fuente */
    }

    .modal-body {
        padding: 20px; /* Aumenta el padding del cuerpo del modal */
    }

    .modal-header {
        background-color: rgba(0, 0, 0, 0.85); /* Cambiado a negro opaco */
        color: white; /* Cambia el color del texto del encabezado a blanco */
    }

    .modal-footer {
        background-color: #f7f7f7; /* Cambia el color de fondo del pie del modal */
    }

    .modal-title {
        font-weight: bold; /* Aumenta el peso de la fuente del título */
        font-size: 1.25rem; /* Aumenta el tamaño de la fuente del título */
    }

    /* Estilo adicional para los botones */
    .btn-primary {
                background-color: #343a40; /* Color de fondo del botón (negro opaco) */
        border: none; /* Sin borde */
    }

    .btn-primary:hover {
        background-color: #23272b; /* Color de fondo al pasar el mouse (más oscuro) */
    }

    .btn-secondary {
        background-color: #6c757d; /* Color de fondo del botón secundario */
        border: none; /* Sin borde */
    }

    .btn-secondary:hover {
        background-color: #5a6268; /* Color de fondo al pasar el mouse */
    }
</style>

    <script>
        $(document).ready(function () {
            // Manejar el evento de clic para mostrar/ocultar el menú desplegable
            $('#dropdownMenuButton').on('click', function (e) {
                e.preventDefault(); // Evitar el comportamiento por defecto
                $('.dropdown-menu').toggleClass('show'); // Alternar la visibilidad del menú
            });

            // Asegurarse de que el dropdown se cierre al hacer clic fuera
            $(document).on('click', function (e) {
                if (!$(e.target).closest('.dropdown').length) {
                    $('.dropdown-menu').removeClass('show'); // Cerrar el menú si se hace clic fuera
                }
            });

            // Ocultar el menú desplegable al abrir el modal
            $('#abrirCajaModal').on('show.bs.modal', function () {
                buscarcaja(); // Cargar las cajas vinculadas al usuario
                buscarusuario(); // Cargar el usuario logueado
                $('.dropdown-menu').removeClass('show'); // Asegúrate de ocultar el menú
            });
        });

    </script>

    <style>
        .dropdown-menu {
            border-radius: 0.5rem;
            padding: 0.5rem 0; /* Espaciado interno para el menú */
        }

        .dropdown-item {
            padding: 0.25rem 1rem; /* Espaciado interno para los ítems */
        }

        .dropdown-item:hover {
            background-color: #f8f9fa; /* Color de fondo al pasar el mouse */
            color: #007bff; /* Color del texto al pasar el mouse */
        }

        .dropdown-header {
            font-weight: bold;
            color: #6c757d;
            padding: 0.5rem 1rem; /* Espaciado para el encabezado */
        }
    </style>

    <style>
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

    <div class="table-container mt-2" style="margin-left: -5px; margin-right: -5px">
        <table class="table table-dark" id="resultadoTablaFacturas">
            <thead>
                <tr>
                    <th>ID</th> <!-- idmovimiento_caja -->
                    <th>Caja</th>               <!-- cajas_idcajas (referencia a otra tabla) -->
                    <th>Fecha Apertura</th>     <!-- fecha_apertura -->
                    <th>Fecha Cierre</th>       <!-- fecha_cierre -->
                    <th>Saldo Inicial</th>      <!-- saldo_inicial -->
                    <th>Total</th>   <!-- saldo_disponible -->
                    <th>Estado</th> 
                    <th>Usuario</th> 
                </tr>
            </thead>

            <tbody id="resultadoFacturas">
                <!-- Aquí se cargarán las facturas -->
            </tbody>
        </table>
    </div>
    <div id="respuesta"></div>
</div>

<script>
    $(document).ready(function () {
        cargarTabla();
        verificarCaja();
        buscarcaja();
        buscarusuario();

        // Log de depuración
        console.log("Página cargada, verificando estado de caja");
    });

    // Variable para indicar si la tabla ya ha sido inicializada
    var tablaInicializada = false;

// Función para cargar los datos en la tabla
    function cargarTabla() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/cajacrud.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoTablaFacturas tbody").html(response);
                // Inicializar la tabla como un DataTable si no ha sido inicializada antes
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

    function verificarCaja() {
        $.ajax({
            data: {listar: 'verificar'},
            url: 'jsp/cajacrud.jsp',
            type: 'post',
            success: function (response) {
                console.log("Estado de caja recibido:", response.trim());

                // Limpiar cualquier espacio en blanco
                response = response.trim();

                // Verificación más detallada
                if (response === "abierta") {
                    console.log("Caja está abierta - Ocultando botón de abrir, mostrando botón de cerrar");
                    $("#abrirCajaButton")
                            .hide()
                            .css('display', 'none');

                    $("#cerrarCajaButton")
                            .show()
                            .css('display', 'block');
                } else if (response === "cerrada") {
                    console.log("Caja está cerrada - Mostrando botón de abrir, ocultando botón de cerrar");
                    $("#abrirCajaButton")
                            .show()
                            .css('display', 'block');

                    $("#cerrarCajaButton")
                            .hide()
                            .css('display', 'none');
                } else {
                    console.warn("Respuesta inesperada:", response);
                    // Manejar caso por defecto
                    $("#abrirCajaButton").show();
                    $("#cerrarCajaButton").hide();
                }
            },
            error: function (xhr, status, error) {
                console.error("Error en verificarCaja:", error);
                console.log("Respuesta del servidor:", xhr.responseText);

                // En caso de error, mostrar botón de abrir por defecto
                $("#abrirCajaButton").show();
                $("#cerrarCajaButton").hide();
            }
        });
    }

// Función para manejar la apertura de caja
    $('#guardarCaja').on("click", function () {
        var datosform = $("#cajaForm").serialize() + "&listar=guardar";

        $.ajax({
            data: datosform,
            url: 'jsp/cajacrud.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta al abrir caja:", response);

                $("#respuesta").html(response);
                cargarTabla();

                // Llamar a verificarCaja después de un breve retraso
                setTimeout(function () {
                    verificarCaja();
                }, 500);

                // Cerrar el modal manualmente
                $('#abrirCajaModal').modal('hide');
            },
            error: function (xhr, status, error) {
                console.error("Error al abrir caja:", error);
                console.log("Respuesta del servidor:", xhr.responseText);
            }
        });
    });

// Función para manejar el cierre de caja
    $('#cerrarCajaButton').on("click", function () {
        $.ajax({
            data: {listar: 'cerrar'},
            url: 'jsp/cajacrud.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta al cerrar caja:", response);

                $("#respuesta").html(response);
                cargarTabla();

                // Llamar a verificarCaja después de un breve retraso
                setTimeout(function () {
                    verificarCaja();
                }, 500);
            },
            error: function (xhr, status, error) {
                console.error("Error al cerrar caja:", error);
                console.log("Respuesta del servidor:", xhr.responseText);
            }
        });
    });

// Asegurar que los botones estén ocultos inicialmente
    $(document).ready(function () {
        console.log("Documento listo - Verificando estado inicial de caja");

        // Ocultar ambos botones inicialmente
        $("#abrirCajaButton, #cerrarCajaButton").hide();

        // Verificar el estado de la caja
        verificarCaja();
    });

    function buscarcaja() {
        $.ajax({
            data: {listar: 'buscarcaja'},
            url: 'jsp/obtenerCaja.jsp',
            type: 'post',
            success: function (response) {
                $("#cajas_idcajas").html(response);
            }
        });
    }

    function buscarusuario() {
        $.ajax({
            data: {listar: 'buscarusuario'},
            url: 'jsp/obtenerCaja.jsp',
            type: 'post',
            success: function (response) {
                $("#usuarios_idusuarios").html(response);
            }
        });
    }

    function dividircaja(a) {
        datos = a.split(',');
        $("#codcajas").val(datos[0]);
        $("#caja_nombre").val(datos[1]);
    }

    function dividirusuario(a) {
        datos = a.split(',');
        $("#codusuarios").val(datos[0]);
        $("#usu_nombre").val(datos[1]);
    }
    
    function mostrarAlerta(mensaje, tipo) {
    var alertDiv = $("<div class='alert alert-" + tipo + "' role='alert'>" + mensaje + "</div>");
    $("#respuesta").append(alertDiv);
    
    // Desvanecer la alerta después de 2 segundos
    setTimeout(function () {
        alertDiv.fadeOut(2000, function() {
            $(this).remove(); // Eliminar la alerta del DOM después de desvanecerse
        });
    }, 2000);
}
</script>


<%@include file="footer.jsp" %>

