<%@include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="personalForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-user-tie"></i> &nbsp; PERSONAL</legend>
                    <a href="reporteVistaGeneral/reportePersonalGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="per_nombre" class="bmd-label-floating">Nombre</label>
                            <input type="text" class="form-control" id="per_nombre" name="per_nombre" maxlength="45">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="per_apellido" class="bmd-label-floating">Apellido</label>
                            <input type="text" class="form-control" id="per_apellido" name="per_apellido" maxlength="45">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="per_ci" class="bmd-label-floating">CI</label>
                            <input type="text" class="form-control" id="per_ci" name="per_ci" maxlength="9" placeholder="Ej: 1.234.567">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="per_telefono" class="bmd-label-floating">Teléfono</label>
                            <input type="text" class="form-control" id="per_telefono" name="per_telefono" maxlength="14" placeholder="Ej: +595992-123456">
                        </div>
                    </div>

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="ciudades_idciudades" class="bmd-label-floating">Ciudad</label>
                            <select class="form-control" id="ciudades_idciudades" name="ciudades_idciudades">
                                <option value="">Seleccione Ciudad</option>
                                <!-- Opciones de la ciudad -->
                            </select>
                        </div>
                    </div>

                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idpersonales" id="idpersonales">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarPersonal" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajePersonal"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm mx-auto" id="resultadoPersonal"">
        <thead>
            <tr>
                <th>#</th>
                <th>NOMBRE</th>
                <th>APELLIDO</th>
                <th>CI</th>
                <th>TELÉFONO</th>
                <th>CIUDAD</th>
                <th>OPCION</th>
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>

</div>

<!-- Modal para eliminar datos -->
<div class="modal fade" id="eliminarPersonalModal" tabindex="-1" role="dialog" aria-labelledby="eliminarPersonalModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarPersonalModalLabel">Eliminar personal</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_EliminarPersonal" id="listar_EliminarPersonal" value="eliminar">
                <input type="hidden" class="form-control" name="idpersonales_e" id="idpersonales_e">
                <p>¿Estás seguro/a que quieres eliminar este personal?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroPersonal" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
