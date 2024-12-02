$(document).ready(function () {
    rellenarDatosCategoria();
    $('#resultadoCategoria').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarCategoria').on("click", function () {
    // Clear previous error messages
    $("#errorCatNombre").remove();

    // Obtener el valor del campo
    var nombre = $("#cat_nombre").val().trim();

    // Permite con _
    var regex = /^[a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_][a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_]*( [a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_]+)*$/;
    if (!regex.test(nombre)) {
        $("#cat_nombre").after('<span id="errorCatNombre" class="text-danger">No se permiten caracteres especiales o más de un espacio entre palabras.</span>');

        // Mostrar el mensaje durante 3 segundos y luego eliminarlo
        setTimeout(function () {
            $("#errorCatNombre").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);

        return; // Evitar el envío del formulario si el campo contiene caracteres especiales
    }

    // Si el campo no está vacío y no tiene caracteres especiales, enviar el formulario
    var datosform = $("#categoriaForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/categoriacrud.jsp',
        type: 'post',
        success: function (response) {
            //console.log(response);
            if (response.trim() === 'categoria_existe') {
                $("#cat_nombre").after('<span id="errorCatNombre" class="text-danger">La categoría ya existe.</span>');

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
            $("#resultadoCategoria tbody").html(response);
            $('#resultadoCategoria').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarCategoria(a, b) {
    $("#idcategoria").val(a);
    $("#cat_nombre").val(b);
    $("#listar").val("modificar");
}