function inicializarDataTable(tablaId, opcionesAdicionales = {}) {
    $(tablaId).DataTable({
        destroy: true,
        language: {
            "decimal": "",
            "emptyTable": "No hay datos disponibles en la tabla",
            "info": "Mostrando _START_ a _END_ de _TOTAL_ registros", // Cambiar START y END a _START_ y _END_
            "infoEmpty": "Mostrando 0 a 0 de 0 registros",
            "infoFiltered": "(filtrado de _MAX_ registros totales)", // Cambiar MAX a _MAX_
            "thousands": ",",
            "lengthMenu": "Mostrar _MENU_ registros",
            "loadingRecords": "Cargando...",
            "processing": "Procesando...",
            "search": "Buscar:",
            "zeroRecords": "No se encontraron coincidencias",
            "paginate": {
                "first": "Primero",
                "last": "Último",
                "next": "Siguiente",
                "previous": "Anterior"
            },
            "aria": {
                "sortAscending": ": activar para ordenar la columna de manera ascendente",
                "sortDescending": ": activar para ordenar la columna de manera descendente"
            }
        },
        lengthMenu: [10, 25, 50, 100],
        pageLength: 10,
        ...opcionesAdicionales
    });
}
$(document).ready(function () {
    rellenarDatosCiudad();
    inicializarDataTable('#resultadoCiudad', {
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarCiudad').on("click", function () {
    $("#errorCiudadNombre").remove();
    var nombre = $("#ciu_nombre").val().trim();

    if (nombre === '') {
        $("#ciu_nombre").after('<span id="errorCiudadNombre" class="text-danger">Por favor, complete este campo.</span>');
        setTimeout(function () {
            $("#errorCiudadNombre").fadeOut('slow', function() {
                $(this).remove();
            });
        }, 2000);
        return; 
    }

    var regex = /^[A-Z0-9ÁÉÍÓÚÜÑáéíóúüñ][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]+)*$/;
    var regexMayusculas = /^[A-ZÁÉÍÓÚÜÑ\s]+$/;

    if (!regex.test(nombre)) {
        $("#ciu_nombre").after('<span id="errorCiudadNombre" class="text-danger">Debe comenzar con mayúscula o números y no se permiten caracteres especiales.</span>');
        setTimeout(function () {
            $("#errorCiudadNombre").fadeOut('slow', function() {
                $(this).remove();
            });
        }, 2000);
        return; 
    }

    if (regexMayusculas.test(nombre.replace(/\s/g, ''))) {
        $("#ciu_nombre").after('<span id="errorCiudadNombre" class="text-danger">El nombre no puede estar completamente en mayúsculas.</span>');
        setTimeout(function () {
            $("#errorCiudadNombre").fadeOut('slow', function() {
                $(this).remove();
            });
        }, 2000);
        return;
    }

    var datosform = $("#ciudadForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/ciudadcrud.jsp',
        type: 'post',
        success: function (response) {
            console.log(response);
            if (response.trim() === 'ciudad_existe') {
                $("#ciu_nombre").after('<span id="errorCiudadNombre" class="text-danger">La ciudad ya existe.</span>');
                setTimeout(function () {
                    $("#errorCiudadNombre").fadeOut('slow', function() {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeCiudad").html(response);
                rellenarDatosCiudad();
                setTimeout(function () {
                    $("#mensajeCiudad").html("");
                    $("#ciu_nombre").val("");
                    $("#ciu_nombre").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        }
    });
});

$('#eliminarRegistroCiudad').on("click", function () {
    var listar = $("#listar_EliminarCiudad").val();
    var pk = $("#idciudades_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/ciudadcrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeCiudad").html(response);
            rellenarDatosCiudad();
            setTimeout(function () {
                $("#mensajeCiudad").html("");
                $("#ciu_nombre").val("");
                $("#ciu_nombre").focus();
                $("#listar").val("cargar");
            }, 2000);
                    }
    });
});

function rellenarDatosCiudad() {
    $.ajax({
        data: { listar: 'listar' },
        url: 'jsp/ciudadcrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoCiudad').DataTable();
            table.clear().destroy(); // Limpiar y destruir la DataTable
            $('#resultadoCiudad tbody').html(response); // Actualizar el cuerpo de la tabla
            inicializarDataTable('#resultadoCiudad'); // Re-inicializar DataTable
        }
    });
}

function rellenarEditarCiudad(a, b) {
    $("#idciudades").val(a);
    $("#ciu_nombre").val(b);
    $("#listar").val("modificar");
}