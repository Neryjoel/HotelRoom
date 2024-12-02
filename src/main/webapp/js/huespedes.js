$(document).ready(function () {
    rellenarDatosHuesped();
    $('#resultadoHuesped').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });

    // Evento click del botón Guardar
    $('#guardarHuesped').on("click", function () {
        // Limpiar mensajes de error anteriores
        $(".errorHuesped").remove();

        // Obtener los valores de los campos
        var nombre = $("#hues_nombre").val().trim();
        var apellido = $("#hues_apellido").val().trim();
        var ci = $("#hues_ci").val().trim();
        var telefono = $("#hues_telefono").val().trim();

        // Validar los campos
        var error = false;

        // Expresiones regulares
        var nombreRegex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*(\s[a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*){0,1}$/;
        var telefonoRegex = /^\+595\d{3}-\d{6}$/;

        // Validar Nombre
        if (!nombreRegex.test(nombre)) {
            $("#hues_nombre").after('<span class="errorHuesped text-danger">El nombre debe comenzar con mayúscula y no tener caracteres especiales o más de un espacios entre palabras.</span>');
            error = true;
            setTimeout(function () {
                $(".errorHuesped").fadeOut('slow', function () {
                    $(this).remove();
                });
            }, 2000);
        }

        // Validar Apellido
        if (!nombreRegex.test(apellido)) {
            $("#hues_apellido").after('<span class="errorHuesped text-danger">El apellido debe comenzar con mayúscula y no tener caracteres especiales o más de un espacios entre palabras.</span>');
            error = true;
            setTimeout(function () {
                $(".errorHuesped").fadeOut('slow', function () {
                    $(this).remove();
                });
            }, 2000);
        }

        // Validar Cédula de Identidad
        var ciRegex = /^\d{1}\.\d{3}\.\d{3}$/;
        if (!ciRegex.test(ci)) {
            $("#hues_ci").after('<span class="errorHuesped text-danger">Ingrese el formato válido 1.234.567.</span>');
            error = true;
            setTimeout(function () {
                $(".errorHuesped").fadeOut('slow', function () {
                    $(this).remove();
                });
            }, 2000);
        }

        // Validar Teléfono
        if (!telefonoRegex.test(telefono)) {
            $("#hues_telefono").after('<span class="errorHuesped text-danger">Ingrese el formato válido +595992-123456.</span>');
            error = true;
            setTimeout(function () {
                $(".errorHuesped").fadeOut('slow', function () {
                    $(this).remove();
                });
            }, 2000);
        }

        if (error) {
            return;
        }

        // Si no hay errores, enviar el formulario
        var datosform = $("#huespedForm").serialize();

        $.ajax({
            data: datosform,
            url: 'jsp/huespedcrud.jsp',
            type: 'post',
            success: function (response) {
                //console.log(response);
                if (response.trim() === 'huesped_existe') {
                    $("#hues_ci").after('<span class="errorHuesped text-danger">La cédula ya existe.</span>');
                    setTimeout(function () {
                        $(".errorHuesped").fadeOut('slow', function () {
                            $(this).remove();
                        });
                    }, 2000);
                } else {
                    $("#mensajeHuesped").html(response);
                    rellenarDatosHuesped();

                    setTimeout(function () {
                        $("#mensajeHuesped").html("");
                        $("#hues_nombre, #hues_apellido, #hues_ci, #hues_telefono").val("");
                        $("#hues_nombre").focus();
                        $("#listar").val("cargar");
                    }, 2000);
                }
            }
        });
    });

    // Evento click del botón Eliminar
    $('#eliminarRegistroHuesped').on("click", function () {
        var listar = $("#listar_EliminarHuesped").val();
        var pk = $("#idhuespedes_e").val();

        $.ajax({
            data: {listar: listar, idpk: pk},
            url: 'jsp/huespedcrud.jsp',
            type: 'post',
            success: function (response) {
                $("#mensajeHuesped").html(response);
                rellenarDatosHuesped();

                setTimeout(function () {
                    $("#mensajeHuesped").html("");
                    $("#hues_nombre, #hues_apellido, #hues_ci, #hues_telefono").val("");
                    $("#hues_nombre").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        });
    });

    // Restringir entrada en Nombre, Apellido y Cédula
    $('#hues_nombre, #hues_apellido').on('input', function () {
        var sanitized = $(this).val().replace(/[^A-Za-zÁÉÍÓÚÜÑáéíóúüñ\s]/g, '');
        $(this).val(sanitized);
    });

    $('#hues_ci').on('input', function () {
        var sanitized = $(this).val().replace(/[^0-9.]/g, ''); // Permitir solo números y puntos
        $(this).val(sanitized);
    });

    // Restringir entrada en Teléfono
    $('#hues_telefono').on('input', function () {
        var sanitized = $(this).val().replace(/[^0-9+\-]/g, '');
        $(this).val(sanitized);
    });

    // Función para rellenar los datos de los huéspedes
    function rellenarDatosHuesped() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/huespedcrud.jsp',
            type: 'post',
            success: function (response) {
                var table = $('#resultadoHuesped').DataTable();
                table.clear().destroy(); // Clear and destroy the DataTable
                $("#resultadoHuesped tbody").html(response);
                $('#resultadoHuesped').DataTable(); // Reinitialize DataTable

            }
        });
    }
});
function rellenarEditarHuesped(id, nombre, apellido, ci, telefono) {
    $("#idhuespedes").val(id);
    $("#hues_nombre").val(nombre);
    $("#hues_apellido").val(apellido);
    $("#hues_ci").val(ci);
    $("#hues_telefono").val(telefono);
    $("#listar").val("modificar");
}
