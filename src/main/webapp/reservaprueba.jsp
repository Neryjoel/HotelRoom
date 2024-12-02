<%@ include file="header.jsp" %>

<fieldset style="display: flex; justify-content: space-between; align-items: center;margin-top: 10px;">
    <legend style="margin-left: 8px;"><i class="fas fa-calendar-alt"></i> &nbsp; Vista General Reserva</legend>
    <!-- Botón comentado para venta directa
    <button type="button" class="btn btn-primary" id="ventaDirectaBtn" onclick="window.location.href = 'factura_has_servicios.jsp'">
        <i class="fas fa-dollar-sign"></i> Venta Directa
    </button>
    -->
</fieldset>
<button type="button" class="btn custom-btn" data-toggle="modal" data-target="#modalReservacion">
    Nueva reservación
</button>

<style>
.custom-btn {
    background-color: #007bff; /* Color azul */
    color: white; /* Color del texto */
    border: none; /* Sin borde */
    padding: 5px 15px; /* Espaciado interno reducido */
    text-align: center; /* Centrar texto */
    text-decoration: none; /* Sin subrayado */
    display: inline-block; /* Mostrar como bloque en línea */
    font-size: 14px; /* Tamaño de fuente reducido */
    margin: 4px 2px; /* Margen */
    cursor: pointer; /* Cambiar cursor al pasar el mouse */
    border-radius: 5px; /* Bordes redondeados */
    transition: background-color 0.3s; /* Transición suave */
    margin-left: 5px; /* Mover el botón a la derecha */
}

.custom-btn:hover {
    background-color: #0056b3; /* Color azul más oscuro al pasar el mouse */
}
</style>
<div id="mensajeReservas"></div>

<!-- Unified Reservation Modal -->
<div class="modal fade" id="modalReservacion" tabindex="-1" role="dialog" aria-labelledby="modalReservacionLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">

            <!-- Modal Header -->
            <div class="modal-header">
                <h5 class="modal-title" id="modalReservacionLabel">Nueva Reservación</h5>
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
                        <div class="form-row">
                            <div class="form-group col-md-3">
                                <label for="habitacion_idhabitacion">Habitación</label>
                                <input type="hidden" id="codhabitaciones" name="codhabitaciones" class="form-control" required>
                                <select id="habitacion_idhabitacion" name="habitacion_idhabitacion" class="form-control" onchange="dividirhabitacion(this.value)">
                                    <option value="">Seleccionar</option>
                                </select>
                            </div>
                            <div class="form-group col-md-9">
                                <label for="habi_descripcion">Descripción</label>
                                <input type="text" id="habi_descripcion" name="habi_descripcion" class="form-control" disabled>
                            </div>
                            <div class="form-group col-md-2">
                                <label for="habi_precio">Precio</label>
                                <input type="number" id="habi_precio" name="habi_precio" class="form-control" disabled>
                            </div>
                            <div class="form-group col-md-3">
                                <label for="habi_estado">Estado</label>
                                <input type="text" id="habi_estado" name="habi_estado" class="form-control" disabled>
                            </div>
                            <div class="form-group col-md-1">
                                <label for="habi_capacidad">Cant.</label>
                                <input type="number" id="habi_capacidad" name="habi_capacidad" class="form-control" disabled>
                            </div>
                            <div class="form-group col-md-3">
                                <label for="habi_nombre">Nombre Hab.</label>
                                <input type="number" id="habi_nombre" name="habi_nombre" class="form-control" disabled>
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
                                <option value="Pendiente">Pendiente</option>
                                <option value="Confirmada">Confirmada</option>
                                <option value="Cancelada">Cancelada</option>
                            </select>
                        </div>
                    </div>
                </form>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                    <button type="button" class="btn btn-success" id="guardarReservas" data-dismiss="modal">Guardar Reservación</button>
                </div>
            </div>       

        </div>
    </div>
</div>
<!-- Reservations Table -->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm mx-auto" id="resultadoReservas">
        <thead>
            <tr>
                <th>#</th>
                <th>FECHA DE ENTRADA</th>
                <th>FECHA DE SALIDA</th>
                <th>ESTADO</th>
                <th>HUÉSPED</th>
                <th>HABITACIÓN</th>
                <th>SEÑA</th>
                <th>OPCIÓN</th>
            </tr>
        </thead>
        <tbody>
            <!-- Reservations will be loaded here -->
        </tbody>
    </table>
</div>
<div class="modal fade" id="eliminarReservasModal" tabindex="-1" role="dialog" aria-labelledby="eliminarReservasModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarReservasModalLabel">Eliminar reserva</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarReservas" value="eliminar">
                <input type="hidden" class="form-control" name="idreservas_e" id="idreservas_e">
                <p>¿Estás seguro/a que quieres eliminar esta reserva?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroReservas" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>
<%@ include file="footer.jsp" %>
