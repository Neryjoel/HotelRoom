$(document).ready(function () {
    rellenarDatosHabitacion();
    obtenerPisos();
    $('#resultadoHabitacion').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarHabitacion').on("click", function () {
    $("#errorDescripcionHabitacion").remove();

    var descripcion = $("#habi_descripcion").val().trim();
    var nombre = $("#habi_nombre").val().trim();
    var estado = $("#habi_estado").val();
    var precio = $("#habi_precio").val(); // Capturar el precio de la habitación
    var piso = $("#pisos_idpisos").val();


    var errores = false;

    var regex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]+)*$/;
    if (!regex.test(descripcion)) {
        $("#habi_descripcion").after('<span id="errorDescripcionHabitacion" class="text-danger">Debe comenzar con mayúscula y no se permiten caracteres especiales o más de un espacio entre palabras.</span>');
        errores = true;
    }

    if (nombre === '') {
        $("#habi_nombre").after('<span id="errorEstadoHabitacion" class="text-danger">Por favor, ingrese un piso.</span>');
        errores = true;
    }

    if (estado === '') {
        $("#habi_estado").after('<span id="errorEstadoHabitacion" class="text-danger">Por favor, seleccione un estado.</span>');
        errores = true;
    }

    if (precio === '') {
        $("#habi_precio").after('<span id="errorEstadoHabitacion" class="text-danger">Por favor, seleccione un precio.</span>');
        errores = true;
    }

    if (piso === '') {
        $("#pisos_idpisos").after('<span id="errorEstadoHabitacion" class="text-danger">Por favor, seleccione un piso.</span>');
        errores = true;
    }
    if (errores) {
        setTimeout(function () {
            $(".text-danger").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
        return;
    }

    var datosform = $("#habitacionForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/habitacioncrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'habitacion_existe') {
                $("#habi_nombre").after('<span id="errorDescripcionHabitacion" class="text-danger">La piso ya existe.</span>');
                setTimeout(function () {
                    $("#errorDescripcionHabitacion").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeHabitacion").html(response);
                rellenarDatosHabitacion();
                setTimeout(function () {
                    $("#mensajeHabitacion").html("");
                    $("#habi_descripcion").val("");
                    $("#habi_nombre").val("");
                    $("#habi_estado").val("");
                    $("#habi_precio").val(""); // Limpiar también el precio
                    $("#habi_descripcion").focus();
                    $("#pisos_idpisos").val(""); // Limpiar selección de ciudad
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroHabitacion').on("click", function () {
    var listar = $("#listar_EliminarHabitacion").val();
    var pk = $("#idhabitacion_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/habitacioncrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeHabitacion").html(response);
            rellenarDatosHabitacion();
            setTimeout(function () {
                $("#mensajeHabitacion").html("");
                $("#habi_descripcion").val("");
                $("#habi_estado").val("");
                $("#habi_precio").val(""); // Limpiar también el precio
                $("#habi_descripcion").focus();
                $("#pisos_idpisos").val(""); // Limpiar selección de ciudad
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosHabitacion() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/habitacioncrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoHabitacion').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoHabitacion tbody").html(response);
            $('#resultadoHabitacion').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarHabitacion(id, nombre, descripcion, estado, precio,piso) {
    $("#idhabitaciones").val(id);
    $("#habi_nombre").val(nombre);
    $("#habi_descripcion").val(descripcion);
    $("#habi_estado").val(estado);
    $("#habi_precio").val(precio); // Establecer el valor del precio en el campo de precio
    obtenerPisos(piso);
    $("#listar").val("modificar");
    
}

function obtenerPisos(selectedCity = "") {
    $.ajax({
        url: 'jsp/obtenerPisos.jsp',
        type: 'post',
        success: function (response) {
            $("#pisos_idpisos").html('<option value="">Seleccione piso</option>' + response);
            if (selectedCity) {
                $("#pisos_idpisos option").filter(function () {
                    return $(this).text() === selectedCity;
                }).prop('selected', true);
            }
        }
    });
}

