<%@ include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="metodoPagoForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-dollar-sign"></i> &nbsp; MÉTODO DE PAGO</legend>
                    <a href="reporteVistaGeneral/reporteMetodoPagoGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="form-group">
                            <label for="descripcion" class="bmd-label-floating">Descripción</label>
                            <input type="text" class="form-control" id="descripcion" name="descripcion" maxlength="45">
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idmetodo_pago" id="idmetodo_pago">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarMetodoPago" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeMetodoPago"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoMetodoPago">
        <thead>
        <th>#</th>
        <th>DESCRIPCIÓN</th>
        <th>OPCIÓN</th>
        </thead>
        <tbody>

        </tbody>
    </table>
</div>
</div>

</section>
</main>
<!-- Modal para eliminar datos -->
<div class="modal fade" id="eliminarMetodoPagoModal" tabindex="-1" role="dialog" aria-labelledby="eliminarMetodoPagoModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarMetodoPagoModalLabel">Eliminar método de pago</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarMetodoPago" value="eliminar">
                <input type="hidden" class="form-control" name="idMetodo_pago_e" id="idMetodo_pago_e">
                <p>¿Estás seguro/a que quieres eliminar este método de pago?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroMetodoPago" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>