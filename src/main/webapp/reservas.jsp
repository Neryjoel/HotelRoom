<%@ include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="reservasForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-calendar-alt"></i> &nbsp; RESERVAS</legend>
                    <a href="reporteVistaGeneral/reporteReservaGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="res_fecha_entrada" class="bmd-label-floating">Fecha y Hora de Entrada</label>
                            <input type="datetime-local" class="form-control" id="res_fecha_entrada" name="res_fecha_entrada">
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="res_fecha_salida" class="bmd-label-floating">Fecha y Hora de Salida</label>
                            <input type="datetime-local" class="form-control" id="res_fecha_salida" name="res_fecha_salida">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="estado" class="bmd-label-floating">Estado</label>
                            <select class="form-control" id="estado" name="estado">
                                <option value="">Seleccione Estado</option>
                                <option value="Confirmada">Confirmada</option>
                                <option value="Pendiente">Pendiente</option>
                                <option value="Cancelada">Cancelada</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="res_senia" class="bmd-label-floating">Seña</label>
                            <input type="number" class="form-control" id="res_senia" name="res_senia" value="0">
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="huespedes_idhuespedes" class="bmd-label-floating">Huésped</label>
                            <select class="form-control" id="huespedes_idhuespedes" name="huespedes_idhuespedes">
                                <option value="">Seleccione Huésped</option>
                                <!-- Opciones de huéspedes -->
                            </select>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habitacion_idhabitacion" class="bmd-label-floating">Habitación</label>
                            <select class="form-control" id="habitacion_idhabitacion" name="habitacion_idhabitacion">
                                <option value="">Seleccione Habitación</option>
                                <!-- Opciones de habitaciones -->
                            </select>
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idreservas" id="idreservas">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <!-- comment 
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;-->
            <button id="guardarReservas" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeReservas"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm mx-auto" id="resultadoReservas">
        <thead>
            <tr>
                <th>#</th>
                <th>FECHA DE ENTRADA</th>
                <th>FECHA DE SALIDA</th>
                <th>ESTADO</th>
                <th>SEÑA</th>
                <th>HUÉSPED</th>
                <th>HABITACIÓN</th>
                <th>OPCIÓN</th>
            </tr>
        </thead>
        <tbody>
            <!-- Aquí se cargarán las reservas -->
        </tbody>
    </table>
</div>


<!-- Modal para eliminar datos -->
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