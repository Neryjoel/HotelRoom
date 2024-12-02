$(document).ready(function () {
    rellenarDatosRol();
    $('#resultadoRol').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarRol').on("click", function () {
    // Clear previous error messages
    $("#errorRolDescripcion").remove();

    // Obtener el valor del campo
    var descripcion = $("#rol_descripcion").val().trim();

    // Permite con _
    
    //var regex = /^[a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]+)*$/;
    
    // Verificar si el campo contiene caracteres especiales o más de un espacio entre palabras
    var regex = /^[a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ_]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ_]+)*$/;
    if (!regex.test(descripcion)) {
        $("#rol_descripcion").after('<span id="errorRolDescripcion" class="text-danger">No se permiten caracteres especiales o más de un espacio entre palabras.</span>');

        // Mostrar el mensaje durante 3 segundos y luego eliminarlo
        setTimeout(function () {
            $("#errorRolDescripcion").fadeOut('slow', function() {
                $(this).remove();
            });
        }, 2000);

        return; // Evitar el envío del formulario si el campo contiene caracteres especiales
    }

    // Si el campo no está vacío y no tiene caracteres especiales, enviar el formulario
    var datosform = $("#rolForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/rolcrud.jsp',
        type: 'post',
        success: function (response) {
            //console.log(response);
            if (response.trim() === 'rol_existe') {
                $("#rol_descripcion").after('<span id="errorRolDescripcion" class="text-danger">El rol ya existe.</span>');

                // Mostrar el mensaje durante 3 segundos y luego eliminarlo
                setTimeout(function () {
                    $("#errorRolDescripcion").fadeOut('slow', function() {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeRol").html(response);
                rellenarDatosRol();

                setTimeout(function () {
                    $("#mensajeRol").html("");
                    $("#rol_descripcion").val("");
                    $("#rol_descripcion").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroRol').on("click", function () {
    var listar = $("#listar_EliminarRol").val();
    var pk = $("#idrol_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/rolcrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeRol").html(response);
            rellenarDatosRol();

            setTimeout(function () {
                $("#mensajeRol").html("");
                $("#rol_descripcion").val("");
                $("#rol_descripcion").focus();
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosRol() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/rolcrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoRol').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoRol tbody").html(response);
            $('#resultadoRol').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarRol(a, b) {
    $("#idrol").val(a);
    $("#rol_descripcion").val(b);
    $("#listar").val("modificar");
}
