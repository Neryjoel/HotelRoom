$(document).ready(function () {
    rellenarDatosPersonal();
    obtenerCiudades();
    $('#resultadoPersonal').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarPersonal').on("click", function () {
    // Limpiar mensajes de error anteriores
    $(".errorPersonal").remove();

    // Obtener valores de los campos
    var nombre = $("#per_nombre").val().trim();
    var apellido = $("#per_apellido").val().trim();
    var ci = $("#per_ci").val().trim();
    var telefono = $("#per_telefono").val().trim();
    var ciudad = $("#ciudades_idciudades").val().trim();

    // Validar campos
    var error = false;
    var nombreRegex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]+)*$/; // Comienza con mayúscula, no contiene caracteres especiales, ni más de un espacio entre palabras
    if (!nombreRegex.test(nombre) || / {2,}/.test(nombre)) {
        $("#per_nombre").after('<span class="errorPersonal text-danger">El nombre debe comenzar con mayúscula, no contener caracteres especiales o varios espacios.</span>');
        error = true;
        setTimeout(function () {
            $(".errorPersonal").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    var apellidoRegex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]+)*$/; // Comienza con mayúscula, no contiene caracteres especiales, ni más de un espacio entre palabras
    if (!apellidoRegex.test(apellido) || / {2,}/.test(apellido)) {
        $("#per_apellido").after('<span class="errorPersonal text-danger">El apellido debe comenzar con mayúscula, no contener caracteres especiales o varios espacios.</span>');
        error = true;
        setTimeout(function () {
            $(".errorPersonal").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    var ciRegex = /^\d{1}\.\d{3}\.\d{3}$/; // Formato 1.234.567
    if (!ciRegex.test(ci)) {
        $("#per_ci").after('<span class="errorPersonal text-danger">Ingrese el formato válido 1.234.567.</span>');
        error = true;
        setTimeout(function () {
            $(".errorPersonal").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    var telefonoRegex = /^\+595\d{3}-\d{6}$/;
    if (!telefonoRegex.test(telefono)) {
        $("#per_telefono").after('<span class="errorPersonal text-danger">Ingrese el formato válido +595992-123456.</span>');
        error = true;
        setTimeout(function () {
            $(".errorPersonal").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    if (ciudad === "") {
        $("#ciudades_idciudades").after('<span class="errorPersonal text-danger">Seleccione una ciudad.</span>');
        error = true;
        setTimeout(function () {
            $(".errorPersonal").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    // Si hay errores, detener el proceso
    if (error) {
        return;
    }

    // Si no hay errores, enviar el formulario
    var datosform = $("#personalForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/personalcrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'personal_existe') {
                $("#per_ci").after('<span class="errorPersonal text-danger">El personal ya existe.</span>');
                setTimeout(function () {
                    $(".errorPersonal").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajePersonal").html(response);
                rellenarDatosPersonal();

                setTimeout(function () {
                    $("#mensajePersonal").html("");
                    $("#per_nombre, #per_apellido, #per_ci, #per_telefono").val("");
                    $("#per_nombre").focus();
                    $("#ciudades_idciudades").val(""); // Limpiar selección de ciudad
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroPersonal').on("click", function () {
    var listar = $("#listar_EliminarPersonal").val();
    var pk = $("#idpersonales_e").val();

    $.ajax({
        data: { listar: listar, idpk: pk },
        url: 'jsp/personalcrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajePersonal").html(response);
            rellenarDatosPersonal();

            setTimeout(function () {
                $("#mensajePersonal").html("");
                $("#per_nombre, #per_apellido, #per_ci, #per_telefono").val("");
                $("#per_nombre").focus();
                $("#ciudades_idciudades").val(""); // Limpiar selección de ciudad
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosPersonal() {
    $.ajax({
        data: { listar: 'listar' },
        url: 'jsp/personalcrud.jsp',
        type: 'post',
        success: function (response) {
             var table = $('#resultadoPersonal').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoPersonal tbody").html(response);
            $('#resultadoPersonal').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarPersonal(id, nombre, apellido, ci, telefono, ciudad) {
    $("#idpersonales").val(id);
    $("#per_nombre").val(nombre);
    $("#per_apellido").val(apellido);
    $("#per_ci").val(ci);
    $("#per_telefono").val(telefono);
    obtenerCiudades(ciudad);
    $("#listar").val("modificar");
}

function obtenerCiudades(selectedCity = "") {
    $.ajax({
        url: 'jsp/obtenerCiudades.jsp',
        type: 'post',
        success: function (response) {
            $("#ciudades_idciudades").html('<option value="">Seleccione ciudad</option>' + response);
            if (selectedCity) {
                $("#ciudades_idciudades option").filter(function () {
                    return $(this).text() === selectedCity;
                }).prop('selected', true);
            }
        }
    });
}
