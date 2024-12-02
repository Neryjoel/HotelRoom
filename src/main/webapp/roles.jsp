<%@include file="header.jsp" %>

<!-- Contenido -->
<div class="container-fluid">
    <form id="rolForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>

            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-user-tag"></i> &nbsp; ROLES</legend>
                    <a href="reporteVistaGeneral/reporteRolGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="rol_descripcion" class="bmd-label-floating">Descripción del Rol</label>
                            <input type="text" class="form-control" id="rol_descripcion" name="rol_descripcion" maxlength="30">
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idrol" id="idrol">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarRol" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeRol"></div>
</div>

<!-- Contenido -->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoRol">
        <thead>
        <th>#</th>
        <th>DESCRIPCIÓN</th>
        <th>OPCIÓN</th>
        </thead>
        <tbody>

        </tbody>
    </table>
</div>

<!-- Modal para eliminar roles -->
<div class="modal fade" id="eliminarRolModal" tabindex="-1" role="dialog" aria-labelledby="eliminarRolModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarRolModalLabel">Eliminar rol</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarRol" value="eliminar">
                <input type="hidden" class="form-control" name="idrol_e" id="idrol_e">
                <p>¿Estás seguro/a que quieres eliminar este rol?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroRol" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>