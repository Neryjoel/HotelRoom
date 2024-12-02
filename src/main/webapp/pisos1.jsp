<%@include file="header.jsp" %>

<!-- Contenido -->
<div class="container-fluid">
    <form id="pisosForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-tag"></i> &nbsp; PISOS</legend>
                    <a href="reporteVistaGeneral/reporteCategoriaGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="pi_nombre" class="bmd-label-floating">Nombre de la CategorÌa</label>
                            <input type="text" class="form-control" id="pi_nombre" name="pi_nombre" maxlength="30">
                        </div>
                    </div>
                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idpisos" id="idpisos">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarCategoria" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajePiso"></div>
</div>

<!-- Contenido -->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm" id="resultadoPiso">
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
                <input type="hidden" class="form-control" name="idpisos_e" id="idpisos_e">
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
    var nombre = $("#pi_nombre").val().trim();

    // Permite con _
    var regex = /^[a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò_][a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò_]*( [a-zA-Z0-9¡…Õ”⁄‹—·ÈÌÛ˙¸Ò_]+)*$/;
    if (!regex.test(nombre)) {
        $("#pi_nombre").after('<span id="errorCatNombre" class="text-danger">No se permiten caracteres especiales o m·s de un espacio entre palabras.</span>');

        // Mostrar el mensaje durante 3 segundos y luego eliminarlo
        setTimeout(function () {
            $("#errorCatNombre").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);

        return; // Evitar el envÌo del formulario si el campo contiene caracteres especiales
    }

    // Si el campo no est· vacÌo y no tiene caracteres especiales, enviar el formulario
    var datosform = $("#pisosForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/pisocrud.jsp',
        type: 'post',
        success: function (response) {
            //console.log(response);
            if (response.trim() === 'piso_existe') {
                $("#pi_nombre").after('<span id="errorCatNombre" class="text-danger">El piso ya existe.</span>');

                // Mostrar el mensaje durante 3 segundos y luego eliminarlo
                setTimeout(function () {
                    $("#errorCatNombre").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajePiso").html(response);
                rellenarDatosCategoria();

                setTimeout(function () {
                    $("#mensajePiso").html("");
                    $("#pi_nombre").val("");
                    $("#pi_nombre").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroCategoria').on("click", function () {
    var listar = $("#listar_EliminarCategoria").val();
    var pk = $("#idpisos_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/pisocrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajePiso").html(response);
            rellenarDatosCategoria();

            setTimeout(function () {
                $("#mensajePiso").html("");
                $("#pi_nombre").val("");
                $("#pi_nombre").focus();
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosCategoria() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/pisocrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoPiso').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoPiso tbody").html(response); // Update table body with new data
            $('#resultadoPiso').DataTable({ // Reinitialize DataTable
                "paging": true,
                "searching": true,
                "info": false
            });
        }
    });
}


function rellenarEditarCategoria(a, b) {
    $("#idpisos").val(a);
    $("#pi_nombre").val(b);
    $("#listar").val("modificar");
}
</script>
