<%@ include file="header.jsp" %>

<!-- Contenido -->
<div class="container-fluid">
    <form id="habitacionForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-bed"></i> &nbsp; HABITACIONES</legend>
                    <a href="reporteVistaGeneral/reporteHabitacionGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habi_nombre" class="bmd-label-floating">Número de la Habitación</label>
                            <input type="number" class="form-control" id="habi_nombre" name="habi_nombre" maxlength="45">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habi_descripcion" class="bmd-label-floating">Descripción de la Habitación</label>
                            <input type="text" class="form-control" id="habi_descripcion" name="habi_descripcion" maxlength="45">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habi_estado" class="bmd-label-floating">Estado de la Habitación</label>
                            <select class="form-control" id="habi_estado" name="habi_estado">
                                <option value="">Seleccionar</option>
                                <option value="Disponible">Disponible</option>
                                <option value="Reservada">Reservada</option>
                                <option value="Ocupada">Ocupada</option>
                                <option value="Limpieza">Limpieza</option>
                                <option value="Mantenimiento">Mantenimiento</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habi_precio" class="bmd-label-floating">Precio de la Habitación</label>
                            <input type="number" class="form-control" id="habi_precio" name="habi_precio">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="pisos_idpisos" class="bmd-label-floating">Piso</label>
                            <select class="form-control" id="pisos_idpisos" name="pisos_idpisos">
                                <option value="">Seleccione Ciudad</option>
                                <!-- Opciones de la ciudad -->
                            </select>
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idhabitaciones" id="idhabitaciones">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarHabitacion" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeHabitacion"></div>
</div>

<!-- Tabla de Habitaciones -->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoHabitacion">
        <thead>
        <th>#</th>
        <th>NOMBRE</th>
        <th>DESCRIPCIÓN</th>
        <th>ESTADO</th>
        <th>PRECIO</th>
        <th>PISO</th>
        <th>OPCIÓN</th>
        </thead>
        <tbody>
            <!-- Los datos se rellenan con AJAX -->
        </tbody>
    </table>
</div>

<!-- Modal para eliminar habitaciones -->
<div class="modal fade" id="eliminarHabitacionModal" tabindex="-1" role="dialog" aria-labelledby="eliminarHabitacionModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarHabitacionModalLabel">Eliminar Habitación</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarHabitacion" value="eliminar">
                <input type="hidden" class="form-control" name="idhabitacion_e" id="idhabitacion_e">
                <p>¿Estás seguro/a que quieres eliminar esta habitación?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroHabitacion" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
