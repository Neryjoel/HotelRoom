$(document).ready(function () {
    rellenarDatosMetodoPago();
        $('#resultadoMetodoPago').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarMetodoPago').on("click", function () {
    $(".errorMetodoPago").remove();

    var descripcion = $("#descripcion").val().trim();

    var error = false;

    var regex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]+)*$/;
    if (!regex.test(descripcion)) {
        $("#descripcion").after('<span class="errorMetodoPago text-danger">Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</span>');
        error = true;
    }

    if (descripcion === descripcion.toUpperCase()) {
        $("#descripcion").after('<span class="errorMetodoPago text-danger">El nombre no debe estar completamente en mayúsculas.</span>');
        error = true;
    }

    if (error) {
        setTimeout(function () {
            $(".errorMetodoPago").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
        return;
    }

    var datosform = $("#metodoPagoForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/metodo_pagocrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'metodo_pago_existe') {
                $("#descripcion").after('<span id="errorMetodoPagoDescripcion" class="text-danger">El método de pago ya existe.</span>');

                setTimeout(function () {
                    $("#errorMetodoPagoDescripcion").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeMetodoPago").html(response);
                rellenarDatosMetodoPago();

                setTimeout(function () {
                    $("#mensajeMetodoPago").html("");
                    $("#descripcion").val("");
                    $("#descripcion").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroMetodoPago').on("click", function () {
    var listar = $("#listar_EliminarMetodoPago").val();
    var pk = $("#idMetodo_pago_e").val();

    $.ajax({
        data: { listar: listar, idpk: pk },
        url: 'jsp/metodo_pagocrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeMetodoPago").html(response);
            rellenarDatosMetodoPago();

            setTimeout(function () {
                $("#mensajeMetodoPago").html("");
                $("#descripcion").val("");
                $("#descripcion").focus();
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosMetodoPago() {
    $.ajax({
        data: { listar: 'listar' },
        url: 'jsp/metodo_pagocrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoMetodoPago').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoMetodoPago tbody").html(response);
            $('#resultadoMetodoPago').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarMetodoPago(id, descripcion) {
    $("#idmetodo_pago").val(id);
    $("#descripcion").val(descripcion);
    $("#listar").val("modificar");
}
