<%@include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="servicioForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <legend><i class="fas fa-cogs"></i> &nbsp; SERVICIOS</legend>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="serv_descripcion" class="bmd-label-floating">Descripción del Servicio</label>
                            <input type="text" class="form-control" id="serv_descripcion" name="serv_descripcion" maxlength="45">
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idservicios" id="idservicios">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarServicio" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeServicio"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoServicio">
        <thead>
            <th>#</th>
            <th>DESCRIPCIÓN</th>
            <th>OPCIÓN</th>
        </thead>
        <tbody>
            
        </tbody>
    </table>

</div>

<!-- Modal para eliminar datos -->
<div class="modal fade" id="eliminarServicioModal" tabindex="-1" role="dialog" aria-labelledby="eliminarServicioModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarServicioModalLabel">Eliminar servicio</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarServicio" value="eliminar">
                <input type="hidden" class="form-control" name="idservicio_e" id="idservicio_e">
                <p>¿Estás seguro/a que quieres eliminar este servicio?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroServicio" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
