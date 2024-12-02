<%@ include file="header.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<fieldset style="display: flex; justify-content: space-between; align-items: center;margin-top: 10px;">
    <legend style="margin-left: 20px;"><i class="fas fa-concierge-bell"></i> &nbsp; Vista General Recepción</legend>
    <!-- Botón comentado para venta directa
    <button type="button" class="btn btn-primary" id="ventaDirectaBtn" onclick="window.location.href = 'factura_has_servicios.jsp'">
        <i class="fas fa-dollar-sign"></i> Venta Directa
    </button>
    -->
</fieldset>
<div class="container-fluid">
    <style>
        /* Container Styles */
        .room-cards-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            padding: 10px;
            border-left: 1px solid transparent;
            border-right: 1px solid transparent;
            overflow-x: auto;
            position: relative;
            margin-left: -27px;
            margin-top: -60px;
            margin-right: -27px;
        }

        /* Card Styles */
        .room-card {
            color: #333;
            border-radius: 8px;
            padding: 10px 10px 35px 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            position: relative;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 110px;
            flex: 0 0 calc(16.66% - 20px);
            margin: 10px;
            display: flex;
            flex-direction: column;
        }

        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        /* Icon Overlay */
        .room-card::before {
            content: "\f236";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            font-size: 2em;
            color: rgba(0, 0, 0, 0.1);
            position: absolute;
            top:-6px;
            right: 8px;
        }

        /* Room Card Status Colors */
        .room-card.Ocupada {
            background-color: #ffcccc;
        }

        .room-card.Limpieza {
            background-color: #ffffcc;
        }

        .room-card.Mantenimiento {
            background-color: #ccffcc;
        }

        .room-card.Reservada {
            background-color: #ccccff;
        }

        .room-card.Disponible {
            background-color: #ccffff;
        }

        /* Text Styles */
        .room-card h6 {
            font-size: 1.1em;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .description-text {
            font-size: 0.8em;
            color: #555;
            margin-bottom: 5px;
            flex-grow: 1;
        }

        /* Button Styles */
        .status-btn {
            width: 100%;
            border: none;
            padding: 8px;
            font-weight: bold;
            background-color: transparent;
            color: rgba(0, 0, 0, 0.8) !important;
            transition: opacity 0.3s;
            cursor: pointer;
            position: absolute;
            bottom: 0;
            left: 0;
            margin: 0;
            border-radius: 0 0 8px 8px;
            height: 35px;
            font-size: 0.9em;
        }

        .status-btn:not(.disabled):hover {
            opacity: 0.8;
        }

        /* Estados específicos para los botones */
        .room-card.Ocupada .status-btn {
            color: rgba(0, 0, 0, 0.8) !important;
        }

        .room-card.Limpieza .status-btn {
            color: rgba(0, 0, 0, 0.8) !important;
        }

        .room-card.Mantenimiento .status-btn {
            color: rgba(0, 0, 0, 0.8) !important;
        }

        .room-card.Reservada .status-btn {
            color: rgba(0, 0, 0, 0.8) !important;
        }

        .room-card.Disponible .status-btn {
            color: rgba(0, 0, 0, 0.8) !important;
        }

        /* Button Group Styles */
        .btn-group {
            margin: 0;
            padding: 5px 5px 0;
            margin-left: -8px;
        }

        .btn-group .btn {
            font-weight: bold;
            color: #333;
            background-color: #f7f7f7;
            border: none;
            border-radius: 0.25rem;
            padding: 0.3rem 1rem;
            transition: background-color 0.2s ease, color 0.2s ease;
            cursor: pointer;
        }

        .btn-group .btn.active {
            background-color: #007bff;
            color: #fff;
            border-bottom: 2px solid #007bff;
        }

        .btn-group .btn:hover {
            background-color: #f2f2f2;
            color: #333;
        }

        /* Loading Indicator Styles */
        .loading-indicator {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .loading-indicator img {
            width: 50px;
            height: 50px;
        }

        /* Responsive Styles */
        @media (max-width: 1200px) {
            .room-card {
                flex: 0 0 calc(33.33% - 20px);
            }
        }

        @media (max-width: 768px) {
            .room-card {
                flex: 0 0 calc(50% - 20px);
            }
        }

        @media (max-width: 480px) {
            .room-card {
                flex: 0 0 calc(100% - 20px);
            }
        }
    </style>

    <style>
        .modal-content {
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background-color: #f8f9fa;
            border-radius: 8px 8px 0 0;
        }

        .modal-footer {
            background-color: #f8f9fa;
            border-radius: 0 0 8px 8px;
        }

    </style>

    <title>Vista General Recepción</title>

    <!-- Loading Indicator -->
    <div class="loading-indicator" id="loadingIndicator">
        <img src="assets/img/loading.gif" alt="Cargando...">
        <p>Cargando habitaciones, por favor espere...</p>
    </div>

    <!-- Navigation Buttons -->
    <div class="btn-group mb-4" role="group" aria-label="Level Selector" id="botonesPisos">
        <button type="button" class="btn" onclick="navigateLevel(this, 'all')">Todos</button>
        <!-- Dynamic buttons for each floor will be added here -->
    </div>

    <!-- Room Cards Container -->
    <div class="room-cards-container" id="roomCardsContainer">
        <!-- Room cards will be dynamically added here based on database records -->
    </div>
</div>

<!-- Modal para Limpieza -->
<div class="modal fade" id="limpiezaModal" tabindex="-1" role="dialog" aria-labelledby="limpiezaModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="limpiezaModalLabel">Confirmación de Limpieza</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿La limpieza de la habitación ha sido completada?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-secondary" id="confirmarLimpieza">Sí</button>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="modalDisponible" tabindex="-1" role="dialog" aria-labelledby="modalDisponibleLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <!-- Modal Header -->
            <div class="modal-header">
                <h5 class="modal-title" id="modalDisponibleLabel">Nuevo Registro</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <!-- Modal Body -->
            <div class="modal-body">
                <form id="reservasForm" class="form-neon" autocomplete="off">
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idreservas" id="idreservas">

                    <!-- Client Information Section -->
                    <h6 class="font-weight-bold">Datos del Cliente</h6>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="huespedes_idhuespedes">Nombre</label>
                            <input type="hidden" id="codhuespedes" name="codhuespedes" class="form-control" required>                            
                            <select id="huespedes_idhuespedes" name="huespedes_idhuespedes" class="form-control" onchange="dividirhuesped(this.value)">
                                <option value="">Seleccionar</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="hues_apellido">Apellido</label>
                            <input type="text" id="hues_apellido" name="hues_apellido" class="form-control" disabled>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="hues_ci">Cédula de Identidad (CI)</label>
                            <input type="text" id="hues_ci" name="hues_ci" class="form-control" disabled>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="hues_telefono">Teléfono</label>
                            <input type="text" id="hues_telefono" name="hues_telefono" class="form-control" disabled>
                        </div>
                        <div class="form-group col-md-4">
                            <label for="hues_correo">Correo</label>
                            <input type="email" id="hues_correo" name="hues_correo" class="form-control" disabled>
                        </div>       
                    </div>

                    <!-- Accommodation Details Section -->
                    <hr class="my-3">
                    <h6 class="font-weight-bold">Datos del Alojamiento</h6>
                    <div class="form-row">
<input type="hidden" class="form-control" name="idhabitaciones" id="idhabitaciones">                        <!-- 
                        <div class="form-group col-md-3">
                            <label for="habitacion_idhabitacion">Habitación</label>
                            <input type="hidden" id="habitacion_idhabitacion" name="habitacion_idhabitacion" class="form-control" required>
                        </div>
                        -->
                        <div class="form-group col-md-2">
                            <label for="habi_nombre">Nombre Hab.</label>
                            <input type="number" id="habi_nombre" name="habi_nombre" class="form-control" disabled>
                        </div>
                        <div class="form-group col-md-8">
                            <label for="habi_descripcion">Descripción</label>
                            <input type="text" id="habi_descripcion" name="habi_descripcion" class="form-control" disabled>
                        </div>
                        <div class="form-group col-md-2">
                            <label for="habi_precio">Precio</label>
                            <input type="number" id="habi_precio" name="habi_precio" class="form-control" disabled>
                        </div>
                        <div class="form-group col-md-2">
                            <label for="habi_estado">Estado</label>
                            <input type="text" id="habi_estado" name="habi_estado" class="form-control" disabled>
                        </div>
                        <div class="form-group col-md-1">
                            <label for="habi_capacidad">Cant.</label>
                            <input type="number" id="habi_capacidad" name="habi_capacidad" class="form-control" disabled>
                        </div>

                        <div class="form-group col-md-3">
                            <label for="pi_nombre">Piso</label>
                            <input type="text" id="pi_nombre" name="pi_nombre" class="form-control" disabled>
                        </div>     

                        <div class="form-group col-md-3">
                            <label for="res_fecha_entrada">Fecha y hora entrada</label>
                            <input type="datetime-local" class="form-control" id="res_fecha_entrada" name="res_fecha_entrada" required>
                        </div>

                        <div class="form-group col-md-3">
                            <label for="res_fecha_salida">Fecha y hora salida:</label>
                            <input type="datetime-local" class="form-control" id="res_fecha_salida" name="res_fecha_salida">
                        </div>
                    </div>

                    <!-- Payment Section -->
                    <hr class="my-3">
                    <h6 class="font-weight-bold">Costo</h6>
                    <div class="form-row">
                        <div class="form-group col-md-4">
                            <label for="res_senia">Seña</label>
                            <input type="number" class="form-control" id="res_senia" name="res_senia" value="0" placeholder="Gs.">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="res_total">Total a pagar:</label>
                            <input type="text" class="form-control" id="res_total" name="res_total" value="0" placeholder="Gs.">
                        </div>
                        <div class="form-group col-md-4">
                            <label for="estado">Estado</label>
                            <select class="form-control" id="estado" name="estado">
                                <option value="Confirmada">Confirmada</option>
                            </select>
                        </div>
                    </div>
                </form>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-success" id="guardarEntrada" data-dismiss="modal" onclick="registrarEntrada()">Registrar</button>
                </div>
            </div>       
        </div>
    </div>
</div>



<!-- JavaScript for Filtering Rooms by Floor -->
<script>
    $(document).ready(function () {
        actualizarBotonesPisos(); // Load the buttons on initialization
        cargarHabitaciones(); // Load room cards on initialization
    });

    function navigateLevel(button, level) {
        document.querySelectorAll('.btn-group .btn').forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');

        const allCards = document.querySelectorAll('.room-card');
        allCards.forEach(card => {
            card.style.display = (level === 'all' || card.dataset.level === level) ? 'block' : 'none';
        });
    }

    function actualizarBotonesPisos() {
        $("#loadingIndicator").show(); // Show the loading indicator

        $.ajax({
            data: {listar: 'listar'}, // Call to get the list of floors
            url: 'jsp/pisocrud.jsp',
            type: 'post',
            success: function (response) {
                $("#botonesPisos").html(response); // Update the button group with new buttons
                $("#loadingIndicator").hide(); // Hide the loading indicator
            },
            error: function () {
                $("#loadingIndicator").hide(); // Hide loading indicator on error
                alert("Error al cargar los pisos. Intente nuevamente.");
            }
        });
    }

    function cargarHabitaciones() {
        $("#loadingIndicator").show(); // Show loading indicator

        $.ajax({
            data: {listar: 'listarHabitaciones'}, // Call to get the list of rooms
            url: 'jsp/habitacioncrud.jsp',
            type: 'post',
            success: function (response) {
                $("#roomCardsContainer").html(response); // Update room cards container
                $("#loadingIndicator").hide(); // Hide loading indicator
            },
            error: function () {
                $("#loadingIndicator").hide(); // Hide loading indicator on error
                alert("Error al cargar las habitaciones. Intente nuevamente.");
            }
        });
    }

    function handleRoomStatus(status, roomId, roomName) {
        if (status.toLowerCase() === 'limpieza') {
            $('#limpiezaModal').modal('show');

            $('#confirmarLimpieza').off('click').on('click', function () {
                actualizarEstadoHabitacion(roomId, 'Disponible');
                $('#limpiezaModal').modal('hide');
            });
        } else if (status.toLowerCase() === 'disponible') {
            cargarDatosHabitacion(roomId);
            $('#modalDisponible').modal('show');
        }
    }

    function actualizarEstadoHabitacion(roomId, newStatus) {
        console.log("Actualizando estado:", roomId, newStatus); // Para debugging
        $("#loadingIndicator").show();

        $.ajax({
            url: 'jsp/habitacioncrud.jsp',
            type: 'post',
            data: {
                listar: 'actualizarEstado',
                idhabitacion: roomId,
                estado: newStatus
            },
            success: function (response) {
                //sconsole.log("Respuesta:", response); // Para debugging
                $("#loadingIndicator").hide();
                if (response.trim() === 'success') {
                    cargarHabitaciones();
                } else {
                    alert('Error al actualizar el estado de la habitación');
                }
            },
            error: function (xhr, status, error) {
                console.error("Error:", error); // Para debugging
                $("#loadingIndicator").hide();
                alert('Error en la comunicación con el servidor');
            }
        });
    }

    function cargarDatosHabitacion(roomId) {
        $.ajax({
            url: 'jsp/obtenerHabitacionCompleto1.jsp',
            type: 'post',
            data: {
                listar: 'obtenerDatosHabitacion',
                idhabitacion: roomId
            },
            success: function (response) {
                var datos = response.split('|');
                $("#codhabitaciones").val(datos[0]);
                $("#habitacion_idhabitacion").val(datos[0]);
                $("#idhabitaciones").val(datos[0]);
                $("#habi_descripcion").val(datos[1]);
                $("#habi_estado").val(datos[2]);
                $("#habi_precio").val(datos[3]);
                $("#habi_capacidad").val(datos[4]);
                $("#habi_nombre").val(datos[5]);
                $("#pi_nombre").val(datos[6]);
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar datos de la habitación:", error);
            }
        });
    }

function registrarEntrada() {
    var roomId = $("#idhabitaciones").val(); // Asegúrate de que este campo tenga el ID de la habitación
    if (roomId) {
        actualizarEstadoHabitacion(roomId, 'Ocupada');
    } else {
        alert("No se pudo obtener el ID de la habitación.");
    }
}

function actualizarEstadoHabitacion(roomId, newStatus) {
    console.log("Actualizando estado:", roomId, newStatus); // Para debugging
    $("#loadingIndicator").show();

    $.ajax({
        url: 'jsp/habitacioncrud.jsp',
        type: 'post',
        data: {
            listar: 'actualizarEstado',
            idhabitacion: roomId,
            estado: newStatus
        },
        success: function (response) {
            $("#loadingIndicator").hide();
            if (response.trim() === 'success') {
                cargarHabitaciones(); // Recargar las habitaciones
            } else {
                alert('Error al actualizar el estado de la habitación');
            }
        },
        error: function (xhr, status, error) {
            console.error("Error:", error); // Para debugging
            $("#loadingIndicator").hide();
            alert('Error en la comunicación con el servidor');
        }
    });
}
</script>
<%@ include file="footer.jsp" %>
