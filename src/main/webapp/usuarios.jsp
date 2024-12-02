<%@include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="usuarioForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-user"></i> &nbsp; USUARIO</legend>
                    <a href="reporteVistaGeneral/reporteUsuarioGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
            </div>
            <div class="row">
                <div class="col-12 col-md-6">
                    <div class="form-group">
                        <label for="usu_nombre" class="bmd-label-floating">Nombre</label>
                        <input type="text" class="form-control" id="usu_nombre" name="usu_nombre" maxlength="45">
                    </div>
                </div>
                <div class="col-12 col-md-6">
                    <div class="form-group">
                        <label for="usu_contra" class="bmd-label-floating">Contraseña</label>
                        <input type="password" class="form-control" id="usu_contra" name="usu_contra" maxlength="20">
                    </div>
                </div>

                <div class="col-12 col-md-6">
                    <div class="form-group">
                        <label for="usu_estado" class="bmd-label-floating">Estado de Usuario</label>
                        <select class="form-control" id="usu_estado" name="usu_estado">
                            <!-- <option value="">Seleccione Estado</option>-->
                            <option>Activo</option>
                            <option>Inactivo</option>
                        </select>
                    </div>
                </div>

                <div class="col-12 col-md-6">
                    <div class="form-group">
                        <label for="personales_idpersonales" class="bmd-label-floating">Personales</label>
                        <select class="form-control" id="personales_idpersonales" name="personales_idpersonales">
                            <option value="">Seleccione Personales</option>
                            <!-- Opciones de personales -->
                        </select>
                    </div>
                </div>
                <div class="col-12 col-md-6">
                    <div class="form-group">
                        <label for="roles_idroles" class="bmd-label-floating">Rol</label>
                        <select class="form-control" id="roles_idroles" name="roles_idroles">
                            <option value="">Seleccione Rol</option>
                            <!-- Opciones de roles -->
                        </select>
                    </div>
                </div>
                
                <div class="col-12 col-md-6">
                    <div class="form-group">
                        <label for="cajas_idcajas" class="bmd-label-floating">Caja</label>
                        <select class="form-control" id="cajas_idcajas" name="cajas_idcajas">
                            <option value="">Seleccione Caja</option>
                            <!-- Opciones de roles -->
                        </select>
                    </div>
                </div>

                <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                <input type="hidden" class="form-control" name="idusuarios" id="idusuarios">
            </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarUsuario" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeUsuario"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm mx-auto" id="resultadoUsuario">
        <thead>
            <tr>
                <th>#</th>
                <th>NOMBRE</th>
                <th>CONTRASEÑA</th>
                <th>ESTADO</th>
                <th>PERSONAL</th>
                <th>ROL</th>
                <th>CAJA</th>
                <th>OPCION</th>
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>

</div>

<!-- Modal para eliminar datos -->
<div class="modal fade" id="eliminarUsuarioModal" tabindex="-1" role="dialog" aria-labelledby="eliminarUsuarioModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarUsuarioModalLabel">Eliminar usuario</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_EliminarUsuario" id="listar_EliminarUsuario" value="eliminar">
                <input type="hidden" class="form-control" name="idusuarios_e" id="idusuarios_e">
                <p>¿Estás seguro/a que quieres eliminar este usuario?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarUsuario" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>
