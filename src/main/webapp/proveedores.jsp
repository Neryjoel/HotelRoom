<%@include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="proveedorForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-building"></i> &nbsp; PROVEEDORES</legend>
                    <a href="reporteVistaGeneral/reporteProveedorGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="prov_nombre" class="bmd-label-floating">Nombre</label>
                            <input type="text" class="form-control" id="prov_nombre" name="prov_nombre" maxlength="45">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="prov_ruc" class="bmd-label-floating">RUC</label>
                            <input type="text" class="form-control" id="prov_ruc" name="prov_ruc" maxlength="15">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="prov_telefono" class="bmd-label-floating">Teléfono</label>
                            <input type="text" class="form-control" id="prov_telefono" name="prov_telefono" maxlength="14" placeholder="Ej: +595992-123456">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="prov_direccion" class="bmd-label-floating">Dirección</label>
                            <input type="text" class="form-control" id="prov_direccion" name="prov_direccion" maxlength="100">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="prov_email" class="bmd-label-floating">Email</label>
                            <input type="email" class="form-control" id="prov_email" name="prov_email" maxlength="100">
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
                    <input type="hidden" class="form-control" name="idproveedores" id="idproveedores">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarProveedor" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeProveedor"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm mx-auto" id="resultadoProveedor">
        <thead>
            <tr>
                <th>#</th>
                <th>NOMBRE</th>
                <th>RUC</th>
                <th>TELÉFONO</th>
                <th>DIRECCIÓN</th>
                <th>EMAIL</th>
                <th>CIUDAD</th>
                <th>OPCION</th>
            </tr>
        </thead>
        <tbody>
            <!-- Content for listing providers will go here -->
        </tbody>
    </table>

</div>

<!-- Modal for deleting providers -->
<div class="modal fade" id="eliminarProveedorModal" tabindex="-1" role="dialog" aria-labelledby="eliminarProveedorModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarProveedorModalLabel">Eliminar proveedor</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_EliminarProveedor" id="listar_EliminarProveedor" value="eliminar">
                <input type="hidden" class="form-control" name="idproveedores_e" id="idproveedores_e">
                <p>¿Estás seguro/a que quieres eliminar este proveedor?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroProveedor" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
