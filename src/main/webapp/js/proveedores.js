$(document).ready(function () {
    rellenarDatosProveedor();
    obtenerCiudades();
    $('#resultadoProveedor').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarProveedor').on("click", function () {
    // Limpiar mensajes de error anteriores
    $(".errorProveedor").remove();

    // Obtener valores de los campos
    var nombre = $("#prov_nombre").val().trim();
    var ruc = $("#prov_ruc").val().trim();
    var telefono = $("#prov_telefono").val().trim();
    var direccion = $("#prov_direccion").val().trim();
    var email = $("#prov_email").val().trim();
    var ciudad = $("#ciudades_idciudades").val().trim();

    // Validar campos
    var error = false;
    var nombreRegex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]+)*$/;
    if (!nombreRegex.test(nombre) || / {2,}/.test(nombre)) {
        $("#prov_nombre").after('<span class="errorProveedor text-danger">El nombre debe comenzar con mayúscula, no contener caracteres especiales o varios espacios.</span>');
        error = true;
    }

    var rucRegex = /^\d{3,}-\d{1,3}$/; // Ejemplo de validación RUC
    if (!rucRegex.test(ruc)) {
        $("#prov_ruc").after('<span class="errorProveedor text-danger">Ingrese un RUC válido (ej. 123-4).</span>');
        error = true;
    }

    var telefonoRegex = /^\+595\d{3}-\d{6}$/;
    if (!telefonoRegex.test(telefono)) {
        $("#prov_telefono").after('<span class="errorProveedor text-danger">Ingrese el formato válido válido +595992-123456</span>');
        error = true;
    }
    
    var direccionRegex = /^[A-ZÁÉÍÓÚÜÑ][a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]*( [a-zA-ZÁÉÍÓÚÜÑáéíóúüñ]+)*$/;
    if (!direccionRegex.test(direccion)) {
        $("#prov_direccion").after('<span class="errorProveedor text-danger">Ingrese el formato .</span>');
        error = true;
    }

    var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
        $("#prov_email").after('<span class="errorProveedor text-danger">Ingrese un email válido.</span>');
        error = true;
    }

    if (ciudad === "") {
        $("#ciudades_idciudades").after('<span class="errorProveedor text-danger">Seleccione una ciudad.</span>');
        error = true;
    }

    // Si hay errores, detener el proceso
    if (error) {
        setTimeout(function () {
            $(".errorProveedor").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
        return;
    }

    // Si no hay errores, enviar el formulario
    var datosform = $("#proveedorForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/proveedorcrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'proveedor_existe') {
                $("#prov_ruc").after('<span class="errorProveedor text-danger">El proveedor ya existe.</span>');
                setTimeout(function () {
                    $(".errorProveedor").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeProveedor").html(response);
                rellenarDatosProveedor();

                setTimeout(function () {
                    $("#mensajeProveedor").html("");
                    $("#prov_nombre, #prov_ruc, #prov_telefono, #prov_direccion, #prov_email").val("");
                    $("#prov_nombre").focus();
                    $("#ciudades_idciudades").val(""); // Limpiar selección de ciudad
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroProveedor').on("click", function () {
    var listar = $("#listar_EliminarProveedor").val();
    var pk = $("#idproveedores_e").val();

    $.ajax({
        data: { listar: listar, idpk: pk },
        url: 'jsp/proveedorcrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeProveedor").html(response);
            rellenarDatosProveedor();

            setTimeout(function () {
                $("#mensajeProveedor").html("");
                $("#prov_nombre, #prov_ruc, #prov_telefono, #prov_direccion, #prov_email").val("");
                $("#prov_nombre").focus();
                $("#ciudades_idciudades").val(""); // Limpiar selección de ciudad
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

function rellenarDatosProveedor() {
    $.ajax({
        data: { listar: 'listar' },
        url: 'jsp/proveedorcrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoProveedor').DataTable();
            table.clear().destroy(); // Clear and destroy the DataTable
            $("#resultadoProveedor tbody").html(response);
            $('#resultadoProveedor').DataTable(); // Reinitialize DataTable

        }
    });
}

function rellenarEditarProveedor(id, nombre, ruc, telefono, direccion, email, ciudad) {
    $("#idproveedores").val(id);
    $("#prov_nombre").val(nombre);
    $("#prov_ruc").val(ruc);
    $("#prov_telefono").val(telefono);
    $("#prov_direccion").val(direccion);
    $("#prov_email").val(email);
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
