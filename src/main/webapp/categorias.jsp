<%@include file="header.jsp" %>

<!-- Contenido -->
<div class="container-fluid">
    <form id="categoriaForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-tag"></i> &nbsp; CATEGORÕAS</legend>
                    <a href="reporteVistaGeneral/reporteCategoriaGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="cat_nombre" class="bmd-label-floating">Nombre de la CategorÌa</label>
                            <input type="text" class="form-control" id="cat_nombre" name="cat_nombre" maxlength="30">
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idcategoria" id="idcategoria">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarCategoria" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeCategoria"></div>
</div>

<!-- Contenido -->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoCategoria">
        <thead>
        <th>#</th>
        <th>NOMBRE</th>
        <th>OPCI”N</th>
        </thead>
        <tbody>

        </tbody>
    </table>

</div>

<!-- Modal para eliminar categorÌas -->
<div class="modal fade" id="eliminarCategoriaModal" tabindex="-1" role="dialog" aria-labelledby="eliminarCategoriaModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarCategoriaModalLabel">Eliminar categorÌa</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_Eliminar" id="listar_EliminarCategoria" value="eliminar">
                <input type="hidden" class="form-control" name="idcategoria_e" id="idcategoria_e">
                <p>øEst·s seguro/a que quieres eliminar esta categorÌa?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroCategoria" data-dismiss="modal">SÌ</button>
            </div>
        </div>
    </div>
</div>
<%@include file="footer.jsp" %>
<script>
$(document).ready(function () {
    rellenarDatosCategoria();

});


$('#guardarCategoria').on("click", function () {
    // Clear previous error messages
    $("#errorCatNombre").remove();

    // Obtener el valor del campo
    var nombre = $("#cat_nombre").val().trim();

    // Permite con _
    var regex = /^[a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò_][a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò_]*( [a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò_]+)*$/;
    if (!regex.test(nombre)) {
        $("#cat_nombre").after('<span id="errorCatNombre" class="text-danger">No se permiten caracteres especiales o m·s de un espacio entre palabras.</span>');

        // Mostrar el mensaje durante 3 segundos y luego eliminarlo
        setTimeout(function () {
            $("#errorCatNombre").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);

        return; // Evitar el envÌo del formulario si el campo contiene caracteres especiales
    }

    // Si el campo no est· vacÌo y no tiene caracteres especiales, enviar el formulario
    var datosform = $("#categoriaForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/categoriacrud.jsp',
        type: 'post',
        success: function (response) {
            //console.log(response);
            if (response.trim() === 'categoria_existe') {
                $("#cat_nombre").after('<span id="errorCatNombre" class="text-danger">La categorÌa ya existe.</span>');

                // Mostrar el mensaje durante 3 segundos y luego eliminarlo
                setTimeout(function () {
                    $("#errorCatNombre").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeCategoria").html(response);
                rellenarDatosCategoria();

                setTimeout(function () {
                    $("#mensajeCategoria").html("");
                    $("#cat_nombre").val("");
                    $("#cat_nombre").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroCategoria').on("click", function () {
    var listar = $("#listar_EliminarCategoria").val();
    var pk = $("#idcategoria_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/categoriacrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeCategoria").html(response);
            rellenarDatosCategoria();

            setTimeout(function () {
                $("#mensajeCategoria").html("");
                $("#cat_nombre").val("");
                $("#cat_nombre").focus();
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosCategoria() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/categoriacrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoCategoria').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoCategoria tbody").html(response); // Update table body with new data
            $('#resultadoCategoria').DataTable({ // Reinitialize DataTable
                "paging": true,
                "searching": true,
                "info": false
            });
        }
    });
}


function rellenarEditarCategoria(a, b) {
    $("#idcategoria").val(a);
    $("#cat_nombre").val(b);
    $("#listar").val("modificar");
}
</script>
