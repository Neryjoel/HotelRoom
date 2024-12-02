$(document).ready(function () {
    llenadohuesped();
    llenadohabitacion();
});

function llenadohuesped() {
    $.ajax({
        data: { listar: 'listarHuespedes' },
        url: 'jsp/obtenerHuespedCompleto.jsp',
        type: 'post',
        success: function (response) {
            $("#huespedes_idhuespedes").html(response);
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar la lista de huéspedes: " + error);
        }
    });
}

function dividirhuesped(a) {
    if (!a) return; // Si no hay valor, salir de la función
    
    var datos = a.split(',');
    $("#codhuespedes").val(datos[0]); // ID del huésped
    $("#hues_apellido").val(datos[2]);
    $("#hues_ci").val(datos[3]);
    $("#hues_telefono").val(datos[4]);
    $("#hues_correo").val(datos[5]);
}

function llenadohabitacion() {
    $.ajax({
        data: {listar: 'listarHabitaciones'},
        url: 'jsp/obtenerHabitacionCompleto.jsp',
        type: 'post',
        success: function (response) {
            $("#habitacion_idhabitacion").html(response);
        },
        error: function (xhr, status, error) {
            console.error("Error al cargar la lista de habitaciones: " + error);
        }
    });
}

function dividirhabitacion(a) {
    if (!a) return;

    var datos = a.split(',');
    $("#codhabitaciones").val(datos[0]); // ID de la habitación
    $("#habi_descripcion").val(datos[1]);
    $("#habi_estado").val(datos[2]);
    $("#habi_precio").val(datos[3]);
    $("#habi_capacidad").val(datos[4]);
    $("#habi_nombre").val(datos[6]);
    $("#pi_nombre").val(datos[7]);
}


$(document).ready(function () {
    // Set current date and time adjusted to the local timezone
    var ahora = new Date();
    ahora.setHours(ahora.getHours() - 3); // Adjust for timezone (UTC-3)
    var fechaHoraActual = ahora.toISOString().slice(0, 16); // Format YYYY-MM-DDTHH:MM
    $("#res_fecha_entrada").val(fechaHoraActual); // Set entry date

    // Load guest and room data
    rellenarDatosReservas();

    // Initialize DataTable
    $('#resultadoCategoria').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });

    // Validate on save reservation
    $('#guardarReservas').on("click", function () {
        $(".errorReservas").remove();

        var fechaEntradaVal = $("#res_fecha_entrada").val();
        var fechaSalidaVal = $("#res_fecha_salida").val();
        var estado = $("#estado").val();
        var huesped = $("#huespedes_idhuespedes").val();
        var habitacion = $("#habitacion_idhabitacion").val();

        var error = false;

        if (fechaEntradaVal === '') {
            $("#res_fecha_entrada").after('<span class="errorReservas text-danger">Por favor ingrese la fecha de entrada.</span>');
            error = true;
        }

        if (fechaSalidaVal === '') {
            $("#res_fecha_salida").after('<span class="errorReservas text-danger">Por favor ingrese la fecha de salida.</span>');
            error = true;
        }

        if (estado === '') {
            $("#estado").after('<span class="errorReservas text-danger">Por favor seleccione el estado de la reserva.</span>');
            error = true;
        }

        if (huesped === '') {
            $("#huespedes_idhuespedes").after('<span class="errorReservas text-danger">Por favor seleccione el huésped.</span>');
            error = true;
        }

        if (habitacion === '') {
            $("#habitacion_idhabitacion").after('<span class="errorReservas text-danger">Por favor seleccione la habitación.</span>');
            error = true;
        }

        if (!error) {
    var formData = {
        res_fecha_entrada: $("#res_fecha_entrada").val(),
        res_fecha_salida: $("#res_fecha_salida").val(),
        estado: $("#estado").val(),
        huespedes_idhuespedes: $("#huespedes_idhuespedes").val(),
        habitacion_idhabitacion: $("#habitacion_idhabitacion").val(),
        res_senia: $("#res_senia").val(),
        codhuespedes: $("#codhuespedes").val(),
        codhabitaciones: $("#codhabitaciones").val(),
        listar: $("#listar").val(), // Asegúrate de que este campo tenga el valor correcto
        idreservas: $("#idreservas").val() // Asegúrate de incluir el ID aquí

    };

    guardarReserva(formData);
}
        // Remove error messages after 2 seconds
        setTimeout(function () {
            $(".errorReservas").fadeOut("slow", function () {
                $(this).remove();
            });
        }, 2000);
    });

    // Logic for deleting reservation record
    $('#eliminarRegistroReservas').on("click", function () {
        var listar = "eliminar";
        var pk = $("#idreservas_e").val();

        $.ajax({
            data: {listar: listar, idpk: pk},
            url: 'jsp/reservascrud.jsp',
            type: 'post',
            success: function (response) {
                $("#mensajeReservas").html(response);
                rellenarDatosReservas();

                setTimeout(function () {
                    $("#mensajeReservas").html("");
                    $("#res_fecha_entrada").val("");
                    $("#res_fecha_salida").val("");
                    $("#estado").val("");
                    $("#huespedes_idhuespedes").val("");
                    $("#habitacion_idhabitacion").val("");
                    $("#res_fecha_salida").focus();
                    $("#listar").val("cargar");
                }, 2000);
            }
        });
    });
});

function rellenarDatosReservas() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/reservascrud.jsp',
        type: 'post',
        success: function (response) {
            var table = $('#resultadoReservas').DataTable();
            table.clear().destroy(); // Clear and destroy DataTable
            $("#resultadoReservas tbody").html(response);
            $('#resultadoReservas').DataTable(); // Reinitialize DataTable
        }
    });
}

function rellenarEditarReservas(id, fechaEntrada, fechaSalida, estado, huesped, habitacion, senia) {
    $("#idreservas").val(id);
    $("#res_fecha_entrada").val(convertDateToISO(fechaEntrada));
    $("#res_fecha_salida").val(convertDateToISO(fechaSalida));
    $("#estado").val(estado);
    $("#res_senia").val(senia);

    // Cargar huéspedes
    $.ajax({
        data: { listar: 'listarHuespedes' },
        url: 'jsp/obtenerHuespedCompleto.jsp',
        type: 'post',
        success: function (response) {
            $("#huespedes_idhuespedes").html(response);
            $("#huespedes_idhuespedes option").filter(function() {
                return $(this).text().trim() === huesped.trim();
            }).prop('selected', true);
            
            var selectedValue = $("#huespedes_idhuespedes").val();
            dividirhuesped(selectedValue);
        }
    });
    
    // Cargar habitaciones
    $.ajax({
        data: { 
            listar: 'listarHabitaciones',
            idHabitacionEditar: habitacion.split('|')[0].trim() // Enviar el número de habitación
        },
        url: 'jsp/obtenerHabitacionCompleto.jsp',
        type: 'post',
        success: function (response) {
            $("#habitacion_idhabitacion").html(response);
            
            // Seleccionar la habitación correcta
            $("#habitacion_idhabitacion option").filter(function() {
                return $(this).text().trim() === habitacion.trim();
            }).prop('selected', true);
            
            var selectedValue = $("#habitacion_idhabitacion").val();
            dividirhabitacion(selectedValue);
        }
    });

    $("#listar").val("modificar");
    $('#modalReservacion').modal('show');
}

function obtenerIdHabitacion(habitacionString) {
    // Suponiendo que habitacionString es algo como "101 | Piso 1"
    try {
        // Dividir el string en el separador '|'
        var partes = habitacionString.split('|');
        // Obtener el número de habitación y eliminar espacios
        var numeroHabitacion = partes[0].trim();
        
        // Realizar una búsqueda en el select de habitaciones para obtener el ID correcto
        var idHabitacion = null;
        $('#habitacion_idhabitacion option').each(function() {
            if ($(this).text().trim() === habitacionString.trim()) {
                // Obtener el primer valor (ID) del value del option
                idHabitacion = $(this).val().split(',')[0];
                return false; // Salir del loop
            }
        });
        
        return idHabitacion;
    } catch (error) {
        console.error("Error al obtener ID de habitación:", error);
        return null;
    }
}


function guardarReserva(formData) {
    $.ajax({
        data: formData,
        url: 'jsp/reservascrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeReservas").html(response);
            rellenarDatosReservas();

            // Limpiar todos los campos del formulario
            limpiarCamposFormulario();

            // Cerrar el modal
            $('#modalReservacion').modal('hide');

            // Mostrar mensaje de éxito
            setTimeout(function () {
                $("#mensajeReservas").html("");
            }, 2000);
        }
    });
}

// Nueva función para limpiar los campos
function limpiarCamposFormulario() {
    // Limpiar campos de cliente
    $("#huespedes_idhuespedes").val("");
    $("#codhuespedes").val("");
    $("#hues_apellido").val("");
    $("#hues_ci").val("");
    $("#hues_telefono").val("");
    $("#hues_correo").val("");

    // Limpiar campos de alojamiento
    $("#habitacion_idhabitacion").val("");
    $("#codhabitaciones").val("");

    
    // Establecer fecha actual para fecha de entrada
    var ahora = new Date();
    ahora.setHours(ahora.getHours() - 3); // Ajuste de zona horaria
    var fechaHoraActual = ahora.toISOString().slice(0, 16);
    $("#res_fecha_entrada").val(fechaHoraActual);
    
    // Limpiar fecha de salida
    $("#res_fecha_salida").val("");

    // Limpiar campos de costo
    $("#res_senia").val("0");
    
    // Restablecer estado a "Pendiente"
    $("#estado").val("Pendiente");

    // Restablecer el valor de listar a "cargar"
    $("#listar").val("cargar");
    
    // Limpiar ID de reserva
    $("#idreservas").val("");
}

// También podemos agregar un evento para limpiar el formulario cuando se abre el modal para una nueva reserva
$(document).ready(function() {
    // Cuando se hace clic en el botón "Nueva reservación"
    $('[data-target="#modalReservacion"]').click(function() {
        limpiarCamposFormulario();
        $("#modalReservacionLabel").text("Nueva Reservación");
    });
});

function convertDateToISO(dateStr) {
    var parts = dateStr.split(' '); // Split date and time
    var fecha = parts[0].split('/'); // Split DD, MM, YYYY
    var hora = parts[1] ? parts[1] : "00:00"; // Default time if not provided

    // Return in ISO format: YYYY-MM-DDTHH:MM
    return `${fecha[2]}-${fecha[1]}-${fecha[0]}T${hora}`; // Change time if needed
}
