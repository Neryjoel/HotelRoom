<%@include file="header.jsp" %>

<!-- Contenido -->
<div class="container-fluid">
    <form id="huespedForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">

                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-user-tag"></i> &nbsp; HU�SPEDES</legend>
                    <!-- Aplicar margen superior al bot�n para bajarlo un poco -->
                    <a href="reporteVistaGeneral/reporteHuespedesGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>

                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="hues_nombre" class="bmd-label-floating">Nombre</label>
                            <input type="text" class="form-control" id="hues_nombre" name="hues_nombre" maxlength="50">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="hues_apellido" class="bmd-label-floating">Apellido</label>
                            <input type="text" class="form-control" id="hues_apellido" name="hues_apellido" maxlength="50">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="hues_ci" class="bmd-label-floating">C�dula de Identidad</label>
                            <input type="text" class="form-control" id="hues_ci" name="hues_ci" maxlength="9" placeholder="Ej: 1.234.567">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="hues_telefono" class="bmd-label-floating">Tel�fono</label>
                            <input type="text" class="form-control" id="hues_telefono" name="hues_telefono" maxlength="14" placeholder="Ej: +595992-123456">
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idhuespedes" id="idhuespedes">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarHuesped" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeHuesped"></div>
</div>

<!-- Contenido -->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoHuesped">
        <thead>
        <th>#</th>
        <th>NOMBRE</th>
        <th>APELLIDO</th>
        <th>C�DULA DE IDENTIDAD</th>
        <th>TEL�FONO</th>
        <th>OPCI�N</th>
        </thead>
        <tbody>

        </tbody>
    </table>

</div>

<!-- Modal para eliminar hu�spedes -->
<div class="modal fade" id="eliminarHuespedModal" tabindex="-1" role="dialog" aria-labelledby="eliminarHuespedModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarHuespedModalLabel">Eliminar hu�sped</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarHuesped" value="eliminar">
                <input type="hidden" class="form-control" name="idhuespedes_e" id="idhuespedes_e">
                <p>�Est�s seguro/a que quieres eliminar a este hu�sped?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroHuesped" data-dismiss="modal">S�</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
