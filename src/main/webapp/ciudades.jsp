<%@include file="header.jsp" %>

<div class="container-fluid">
    <form id="ciudadForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>

            <div class="container-fluid">
                <!-- Contenedor Flexbox para alinear el legend y el botón -->
                <div class="d-flex justify-content-between align-items-center">
                    <legend class="mb-0"><i class="fas fa-city"></i> CIUDADES</legend>
                    <!-- Aplicar margen superior al botón para bajarlo un poco -->
                    <a href="reporteVistaGeneral/reporteCiudadGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <label for="ciu_nombre" class="bmd-label-floating">Nombre de la Ciudad</label>
                        <input type="text" class="form-control" id="ciu_nombre" name="ciu_nombre" maxlength="45">
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idciudades" id="idciudades">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> LIMPIAR</button>
            <button id="guardarCiudad" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> GUARDAR</button>
        </p>
    </form>
    <div id="mensajeCiudad"></div>
</div>



<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoCiudad">
        <thead>
            <tr>
                <th>#</th>
                <th>NOMBRE</th>
                <th>OPCIÓN</th>
            </tr>
        </thead>
        <tbody>
            <!-- Aquí se cargarán las filas dinámicamente -->
        </tbody>
    </table>
</div>



<!-- Modal para eliminar ciudades -->
<div class="modal fade" id="eliminarCiudadModal" tabindex="-1" role="dialog" aria-labelledby="eliminarCiudadModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarCiudadModalLabel">Eliminar ciudad</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarCiudad" value="eliminar">
                <input type="hidden" class="form-control" name="idciudades_e" id="idciudades_e">
                <p>¿Estás seguro/a que quieres eliminar esta ciudad?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroCiudad" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>