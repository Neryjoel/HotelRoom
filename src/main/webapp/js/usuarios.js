$(document).ready(function () {
    rellenarDatosUsuario();
    obtenerPersonales();
    obtenerRoles();
    obtenerCajas();
    $('#resultadoUsuario').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarUsuario').on("click", function () {
    // Limpiar mensajes de error anteriores
    $(".errorUsuario").remove();

    // Obtener valores de los campos
    var nombre = $("#usu_nombre").val().trim();
    var contra = $("#usu_contra").val().trim();
    var estado = $("#usu_estado").val();
    var personal = $("#personales_idpersonales").val();
    var rol = $("#roles_idroles").val();
    var caja = $("#cajas_idcajas").val();

    // Validar campos
    var error = false;
    //Sin _
    //var nombreRegex = /^[a-zA-ZÁÉÍÓÚÜÑáéíóúüñ][a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]+)*$/;
    
    var nombreRegex = /^[a-zA-Z0-9ÁÉÍÓÚÜÑáéíóúüñ_][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ_]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ_]+)*$/;
    if (!nombreRegex.test(nombre) || / {2,}/.test(nombre)) {
        $("#usu_nombre").after('<span class="errorUsuario text-danger">El nombre debe comenzar con mayúscula, no contener caracteres especiales o varios espacios.</span>');
        error = true;
        setTimeout(function () {
            $(".errorUsuario").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    if (contra.length < 6) {
        $("#usu_contra").after('<span class="errorUsuario text-danger">La contraseña debe tener al menos 6 caracteres.</span>');
        error = true;
        setTimeout(function () {
            $(".errorUsuario").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }
    /*
    if (estado === "") {
        $("#usu_estado").after('<span class="errorUsuario text-danger">El estado no puede estar vacío.</span>');
        error = true;
        setTimeout(function () {
            $(".errorUsuario").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }
    */
    if (personal === "") {
        $("#personales_idpersonales").after('<span class="errorUsuario text-danger">Seleccione un personal.</span>');
        error = true;
        setTimeout(function () {
            $(".errorUsuario").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    if (rol === "") {
        $("#roles_idroles").after('<span class="errorUsuario text-danger">Seleccione un rol.</span>');
        error = true;
        setTimeout(function () {
            $(".errorUsuario").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    // Si hay errores, detener el proceso
    if (error) {
        return;
    }

    // Si no hay errores, enviar el formulario
    var datosform = $("#usuarioForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/usuariocrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'usuario_existe') {
                $("#usu_nombre").after('<span class="errorUsuario text-danger">El usuario ya existe.</span>');
                setTimeout(function () {
                    $(".errorUsuario").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeUsuario").html(response);
                rellenarDatosUsuario();

                setTimeout(function () {
                    $("#mensajeUsuario").html("");
                    $("#usu_nombre, #usu_contra").val("");
                    $("#usu_estado").val("Activo");
                    $("#usu_nombre").focus();
                    $("#personales_idpersonales").val(""); // Limpiar selección de personal
                    $("#roles_idroles").val(""); // Limpiar selección de rol
                    $("#cajas_idcajas").val(""); // Limpiar selección de personal
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarUsuario').on("click", function () {
    var listar = $("#listar_EliminarUsuario").val();
    var pk = $("#idusuarios_e").val();

    $.ajax({
        data: { listar: listar, idpk: pk },
        url: 'jsp/usuariocrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeUsuario").html(response);
            rellenarDatosUsuario();

            setTimeout(function () {
                $("#mensajeUsuario").html("");
                $("#usu_nombre, #usu_contra").val("");
                $("#usu_estado").val("Activo");
                $("#usu_nombre").focus();
                $("#personales_idpersonales").val(""); // Limpiar selección de personal
                $("#roles_idroles").val(""); // Limpiar selección de rol
                $("#cajas_idcajas").val(""); // Limpiar selección de personal
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosUsuario() {
    $.ajax({
        data: { listar: 'listar' },
        url: 'jsp/usuariocrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoUsuario').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoUsuario tbody").html(response);
            $('#resultadoUsuario').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarUsuario(id, nombre, contra, estado, personal, rol,caja) {
    $("#idusuarios").val(id);
    $("#usu_nombre").val(nombre);
    $("#usu_contra").val(contra);
    $("#usu_estado").val(estado);
    obtenerPersonales(personal);
    obtenerRoles(rol);
    obtenerCajas(caja);
    $("#listar").val("modificar");
}

function obtenerPersonales(selectedPersonal = "") {
    $.ajax({
        url: 'jsp/obtenerPersonales.jsp',
        type: 'post',
        success: function (response) {
            $("#personales_idpersonales").html('<option value="">Seleccione Personal</option>' + response);
            if (selectedPersonal) {
                $("#personales_idpersonales option").filter(function () {
                    return $(this).text() === selectedPersonal;
                }).prop('selected', true);
            }
        }
    });
}

function obtenerRoles(selectedRol = "") {
    $.ajax({
        url: 'jsp/obtenerRoles.jsp',
        type: 'post',
        success: function (response) {
            $("#roles_idroles").html('<option value="">Seleccione Rol</option>' + response);
            if (selectedRol) {
                $("#roles_idroles option").filter(function () {
                    return $(this).text() === selectedRol;
                }).prop('selected', true);
            }
        }
    });
}
function obtenerCajas(selectedRol = "") {
    $.ajax({
        url: 'jsp/obtenerCajas.jsp',
        type: 'post',
        success: function (response) {
            $("#cajas_idcajas").html('<option value="">Seleccione Caja</option>' + response);
            if (selectedRol) {
                $("#cajas_idcajas option").filter(function () {
                    return $(this).text() === selectedRol;
                }).prop('selected', true);
            }
        }
    });
}