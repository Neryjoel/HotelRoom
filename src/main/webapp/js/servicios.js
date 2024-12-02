$(document).ready(function () {
    rellenarDatosServicio();
    $('#resultadoServicio').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
    
});

$('#guardarServicio').on("click", function () {
    // Limpiar mensajes de error previos
    $("#errorServicioDescripcion").remove();

    // Obtener el valor del campo
    var descripcion = $("#serv_descripcion").val().trim();

    // Verificar si el campo contiene caracteres especiales o más de un espacio entre palabras
    var regex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]+)*$/;
    if (!regex.test(descripcion)) {
        $('<span id="errorServicioDescripcion" class="text-danger">Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</span>').insertAfter("#serv_descripcion");

        // Resto del código para mostrar y luego eliminar el mensaje
        setTimeout(function () {
            $("#errorServicioDescripcion").fadeOut('slow', function() {
                $(this).remove();
            });
        }, 2000);

        return; // Evitar el envío del formulario si el campo contiene caracteres especiales
    }

    // Si el campo pasa las validaciones, enviar el formulario
    var datosform = $("#servicioForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/serviciocrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'servicio_existe') {
                $("#serv_descripcion").after('<span id="errorServicioDescripcion" class="text-danger">El servicio ya existe.</span>');

                // Resto del código para mostrar y luego eliminar el mensaje
                setTimeout(function () {
                    $("#errorServicioDescripcion").fadeOut('slow', function() {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeServicio").html(response);
                rellenarDatosServicio();

                setTimeout(function () {
                    $("#mensajeServicio").html("");
                    $("#serv_descripcion").val("");
                    $("#serv_descripcion").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroServicio').on("click", function () {
    var listar = $("#listar_EliminarServicio").val();
    var pk = $("#idservicio_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/serviciocrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeServicio").html(response);
            rellenarDatosServicio();

            setTimeout(function () {
                $("#mensajeServicio").html("");
                $("#serv_descripcion").val("");
                $("#serv_descripcion").focus();
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosServicio() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/serviciocrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoServicio').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoServicio tbody").html(response);
            $('#resultadoServicio').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarServicio(a, b) {
    $("#idservicios").val(a);
    $("#serv_descripcion").val(b);
    $("#listar").val("modificar");
}
