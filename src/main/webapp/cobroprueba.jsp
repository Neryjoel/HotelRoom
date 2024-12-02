<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ include file="header.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<style>
    /* Estilos personalizados para el modal de pago */
    #modalPago .modal-dialog {
        max-width: 95%;
        width: fit-content;
        margin: 1.75rem auto;
    }

    #modalPago .modal-content {
        width: auto;
        max-width: 100%;
    }

    .payment-table-responsive {
        overflow-x: auto;
        width: 100%;
    }

    .payment-table {
        width: 100%;
        min-width: 800px;
    }

    .modal-title-large {
        font-size: 24px;
        font-weight: bold;
    }

    .form-control-small {
        width: 150px;
        height: 44px;
        margin-bottom: 10px;
    }

    .payment-table th, .payment-table td {
        text-align: center;
        vertical-align: middle;
        padding: 8px;
    }

    .payment-table input,
    .payment-table select {
        width: 100%;
        max-width: 200px;
        box-sizing: border-box;
    }

    .payment-table td button {
        display: block;
        margin: auto;
    }

    .modal-footer {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        align-items: center;
        padding: 20px;
    }

    .difference,
    .total-container {
        margin-bottom: 10px;
    }

    .modal-content {
        overflow-y: visible;
    }

    /* Ajustes para dispositivos móviles */
    @media (max-width: 768px) {
        #modalPago .modal-dialog {
            margin: 1.75rem 10px;
            max-width: calc(100% - 20px);
        }

        .payment-table {
            min-width: 600px;
        }

        .form-control-small {
            width: 100px;
            font-size: 12px;
        }

        .modal-title-large {
            font-size: 18px;
        }
    }

    /* Contenedor flexible para información de pago */
    .payment-info-container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        justify-content: space-between;
        align-items: center;
    }


</style>

<div class="modal fade" id="modalPago" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title w-100 text-center modal-title-large" id="exampleModalLabel">
                    Seleccione método de pago
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="payment-table-responsive">
                    <form id="cobroForm">
                        <table class="payment-table">
                            <thead>
                                <tr>
                                    <th>Método de pago</th>
                                    <th>Monto</th>
                                    <th>Banco</th>
                                    <th>Tipo Tarjeta</th>
                                    <th>Nro. Transacción</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="clon">
                                    <td>
                                        <input type="hidden" id="codmetodo_pago" name="codtipo_pago">
                                        <select id="idmetodo_pago" name="idmetodo_pago" 
                                                onchange="dividirmetodo_pago(this.value)" 
                                                class="form-control-small">
                                            <!-- Opciones de método de pago -->
                                        </select>
                                    </td>

                                    <td>
                                        <input type="number" placeholder="Monto" 
                                               id="monto" name="monto" 
                                               class="form-control-small" disabled>
                                    </td>
                                    <td>
                                        <input type="hidden" id="codbancos" name="codbancos">
                                        <select id="idbancos" name="idbancos" 
                                                onchange="dividirbanco(this.value)" 
                                                class="form-control-small" disabled>
                                            <!-- Opciones de bancos -->
                                        </select>
                                    </td>
                                    <td>
                                        <input type="hidden" id="codtipo_tarjeta" name="codtipo_tarjeta">
                                        <select id="idtipo_tarjeta" name="idtipo_tarjeta" 
                                                onchange="dividirtipo_tarjeta(this.value)" 
                                                class="form-control-small" disabled>
                                            <!-- Opciones de tipo de tarjeta -->
                                        </select>
                                    </td>
                                    <td>
                                        <input type="text" name="nro_transaccion" 
                                               id="nro_transaccion" 
                                               placeholder="Nro. de Transacción" 
                                               class="form-control-small" disabled>
                                    </td>
                                    <td>
                                        <button type="button" id="myButton" style="margin-top: -10px;">
                                            <i class="fas fa-plus" title="Agregar Más Métodos"></i>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>

                        <%
                            // Captura el ID de la factura desde la solicitud
                            String idfactura = request.getParameter("idfactura");

                            // Verifica si idfactura es nulo y asigna un valor predeterminado si es necesario
                            if (idfactura == null) {
                                idfactura = "0"; // O cualquier valor predeterminado que desees
                            }
                        %>
                        <input type="hidden" id="idfactura" value="<%= idfactura%>">
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <div class="payment-info-container">
                    <div class="difference">
                        <label>Monto de diferencia:</label>
                        <span id="difference-value">$0.00</span>
                    </div>
                    <div class="total-container">
                        <label>Total a pagar:</label>
                        <span id="total-value">$0.00</span>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" id="btnCobrar">Pagar</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        buscarmetodo_pago();
        buscartipo_tarjeta();
        buscarbanco();
    });

    function insertarCobros(facturaId, metodoPagoId, monto, bancoId, tipoTarjetaId, nroTransaccion) {
        console.log("Datos a insertar:", {
            facturaId: facturaId,
            metodoPagoId: metodoPagoId,
            monto: monto,
            bancoId: bancoId || 'null',
            tipoTarjetaId: tipoTarjetaId || 'null',
            nroTransaccion: nroTransaccion || 'null'
        });

        $.ajax({
            url: 'jsp/insertarCobros.jsp',
            type: 'POST',
            data: {
                listar: 'insertarCobro',
                facturaId: facturaId,
                metodoPagoId: metodoPagoId,
                monto: monto,
                bancoId: bancoId || '', // Enviar cadena vacía si es nulo
                tipoTarjetaId: tipoTarjetaId || '', // Enviar cadena vacía si es nulo
                nroTransaccion: nroTransaccion || '' // Enviar cadena vacía si es nulo
            },
            success: function (response) {
                console.log('Respuesta del servidor:', response);
                if (response.trim().includes('Error')) {
                    console.error('Error en la inserción:', response);
                    alert(response); // Mostrar mensaje de error al usuario
                } else {
                    console.log('Cobro insertado exitosamente');
                }
            },
            error: function (xhr, status, error) {
                console.error('Error en la solicitud AJAX:', {
                    status: status,
                    error: error,
                    responseText: xhr.responseText
                });
                alert('Error al insertar cobro: ' + error);
            }
        });
    }

    $("#btnCobrar").click(function () {
        let total = $("#txtTotalCompra").val();
        let tipoPago = $("#idtipo_pago").val();
        let reservationId = $("#reservationId").val();
        let userId = $("#userId").val();

        $.ajax({
            data: {
                listar: 'finalcobro',
                total: total,
                codtipo_pago: tipoPago,
                reservationId: reservationId,
                userId: userId
            },
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            success: function (response) {
                console.log('Respuesta de finalizar compra:', response);

                // Actualizar el estado de TODAS las facturas de la reserva a 'Finalizado'
                $.ajax({
                    url: 'jsp/actualizarEstadoFactura.jsp',
                    type: 'POST',
                    data: {
                        reservationId: reservationId,
                        nuevoEstado: 'Finalizado'
                    },
                    success: function (updateResponse) {
                        console.log('Estado de las facturas actualizado:', updateResponse);

                        // Obtener el ID de la factura recién creada
                        $.ajax({
                            url: 'jsp/obtenerUltimaFactura.jsp',
                            type: 'POST',
                            data: {
                                reservationId: reservationId,
                                userId: userId
                            },
                            success: function (facturaResponse) {
                                console.log('Respuesta cruda de obtenerUltimaFactura:', facturaResponse);

                                // Trim y validar la respuesta
                                let facturaId = facturaResponse.trim();

                                // Validación adicional
                                if (facturaId === '' || isNaN(facturaId)) {
                                    console.error('ID de factura inválido:', facturaId);
                                    alert('No se pudo obtener un ID de factura válido');
                                    return;
                                }

                                console.log('ID de factura obtenido:', facturaId);

                                // Recorrer métodos de pago
                                $(".payment-table tbody tr").each(function () {
                                    let metodoPagoId = $(this).find("#codmetodo_pago").val();
                                    let monto = $(this).find("input[name='monto']").val();
                                    let bancoId = $(this).find("#codbancos").val();
                                    let tipoTarjetaId = $(this).find("#codtipo_tarjeta").val();
                                    let nroTransaccion = $(this).find("input[name='nro_transaccion']").val();

                                    // Solo insertar si hay un método de pago
                                    if (metodoPagoId && monto) {
                                        insertarCobros(
                                                facturaId,
                                                metodoPagoId,
                                                monto,
                                                bancoId,
                                                tipoTarjetaId,
                                                nroTransaccion
                                                );
                                    }
                                });

                                alert('Pago completado exitosamente');
                            },
                            error: function (xhr, status, error) {
                                console.error('Error al obtener ID de factura:', {
                                    status: status,
                                    error: error,
                                    responseText: xhr.responseText
                                });
                                alert('No se pudo obtener el ID de la factura');
                            }
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error('Error al actualizar estado de facturas:', error);
                        alert('Error al actualizar estado de facturas');
                    }
                });
            },
            error: function (error) {
                alert("Error al finalizar la compra: " + error);
            }
        });
    });
    function buscarmetodo_pago() {
        $.ajax({
            data: {listar: 'buscarmetodo_pago'},
            url: 'jsp/obtenerCobros.jsp',
            type: 'post',
            success: function (response) {
                $("#idmetodo_pago").html(response);
            }
        });
    }


    function dividirmetodo_pago(a) {
        // Encontrar la fila padre del select
        var row = $(event.target).closest('tr');

        // Limpiar campos ocultos de esta fila específica
        row.find("#codmetodo_pago").val('');
        row.find("#descripcion").val('');

        // Si se selecciona "Seleccionar", limpiar campos
        if (a === "" || a === "Seleccionar") {
            row.find("#codmetodo_pago").val("");
            row.find("#descripcion").val("");
            return;
        }

        // Dividir los datos del método de pago
        let datos = a.split(',');
        row.find("#codmetodo_pago").val(datos[0]);
        row.find("#descripcion").val(datos[1]);

        // Habilitar/deshabilitar campos según el método de pago
        if (datos[1] === 'Efectivo') {
            row.find("#idbancos, #idtipo_tarjeta, #nro_transaccion")
                    .prop('disabled', true)
                    .val(''); // Limpiar valores

            // Limpiar campos ocultos
            row.find("#codbancos, #codtipo_tarjeta").val('');
        } else {
            // Si no es efectivo, habilitar los campos
            row.find("#idbancos, #monto, #idtipo_tarjeta, #nro_transaccion").prop('disabled', false);
        }
    }

// Modificar de manera similar las otras funciones
    function dividirbanco(a) {
        // Encontrar la fila padre del select
        var row = $(event.target).closest('tr');

        // Si se selecciona "Seleccionar", limpiar campos
        if (a === "" || a === "Seleccionar") {
            row.find("#codbancos").val("");
            row.find("#ban_descripcion").val("");
            return;
        }

        let datos = a.split(',');
        row.find("#codbancos").val(datos[0]);
        row.find("#ban_descripcion").val(datos[1]);
    }

    function dividirtipo_tarjeta(a) {
        // Encontrar la fila padre del select
        var row = $(event.target).closest('tr');

        // Si se selecciona "Seleccionar", limpiar campos
        if (a === "" || a === "Seleccionar") {
            row.find("#codtipo_tarjeta").val("");
            row.find("#tar_descripcion").val("");
            return;
        }

        let datos = a.split(',');
        row.find("#codtipo_tarjeta").val(datos[0]);
        row.find("#tar_descripcion").val(datos[1]);
    }
    function buscarbanco() {
        $.ajax({
            data: {listar: 'buscarbanco'},
            url: 'jsp/obtenerCobros.jsp',
            type: 'post',
            success: function (response) {
                $("#idbancos").html(response);
            }
        });
    }


    function buscartipo_tarjeta() {
        $.ajax({
            data: {listar: 'buscartipo_tarjeta'},
            url: 'jsp/obtenerCobros.jsp',
            type: 'post',
            success: function (response) {
                $("#idtipo_tarjeta").html(response);
            }
        });
    }



    // Función para calcular la diferencia y habilitar/deshabilitar el botón
    function calcularDiferencia() {
        let total = parseFloat($("#txtTotalCompra").val()); // Obtiene el total
        let montoPagado = 0; // Inicializa el monto pagado

        // Recorre cada fila de la tabla de pagos
        $(".payment-table tbody tr").each(function () {
            let monto = parseFloat($(this).find("input[name='monto']").val());
            if (!isNaN(monto)) { // Solo suma el monto si es un número válido
                montoPagado += monto;
            }
        });

        // Calcula la diferencia
        let diferencia = total - montoPagado;

        // Actualiza el monto de diferencia en el modal
        $("#difference-value").html("$" + diferencia.toFixed(2));
        $("#total-value").html("$" + total.toFixed(2)); // Asegúrate de mostrar el total aquí

        // Habilita o deshabilita el botón según la diferencia
        if (diferencia <= 0) {
            // Deshabilitar todos los botones "Efectivo" si la diferencia es cero o menor
            $(".payment-table tbody tr").find("button").prop("disabled", true);
        } else {
            // Habilitar los botones "Efectivo" si la diferencia es mayor que cero
            $(".payment-table tbody tr").find("button").prop("disabled", false);
        }
    }

    $("#myButton").off("click").on("click", function () {
        // Encontrar todas las filas de pago
        var paymentRows = $(".payment-table tbody tr");

        // Obtener la última fila
        var lastRow = paymentRows.last();

        // Función para validar si una fila está completamente llena
        function isRowComplete(row) {
            var isComplete = true;

            // Función para mostrar error de color
            function showColorError(element) {
                element.addClass('is-invalid');
                setTimeout(() => {
                    element.removeClass('is-invalid');
                }, 2000);
                isComplete = false;
            }

            // Validar método de pago
            var metodoPagoSelect = row.find("#idmetodo_pago");
            if (metodoPagoSelect.val() === "") {
                showColorError(metodoPagoSelect);
            }

            // Validar monto
            var montoInput = row.find("input[name='monto']");
            if (montoInput.val() === "") {
                showColorError(montoInput);
            }

            // Obtener el método de pago seleccionado
            var metodoPago = metodoPagoSelect.find("option:selected").text();

            // Si no es efectivo, validar campos adicionales
            if (metodoPago !== 'Efectivo') {
                // Validar banco
                var bancoSelect = row.find("#idbancos");
                if (bancoSelect.val() === "") {
                    showColorError(bancoSelect);
                }

                // Validar tipo de tarjeta
                var tipoTarjetaSelect = row.find("#idtipo_tarjeta");
                if (tipoTarjetaSelect.val() === "") {
                    showColorError(tipoTarjetaSelect);
                }

                // Validar número de transacción
                var nroTransaccionInput = row.find("input[name='nro_transaccion']");
                if (nroTransaccionInput.val() === "") {
                    showColorError(nroTransaccionInput);
                }
            }

            return isComplete;
        }

        // Verificar si la última fila está completamente llena
        if (!isRowComplete(lastRow)) {
            return;
        }

        // Calcular la diferencia
        calcularDiferencia();

        // Verificar la diferencia
        let diferencia = parseFloat($("#difference-value").text().replace('$', '').replace(',', ''));
        if (diferencia <= 0) {
            // Cambiar color del área de diferencia
            $("#difference-value")
                    .css('color', 'red')
                    .delay(2000)
                    .queue(function (next) {
                        $(this).css('color', '');
                        next();
                    });

            // Deshabilitar la última fila
            lastRow.find('select, input, button')
                    .prop('disabled', true)
                    .css({
                        'opacity': '0.6',
                        'cursor': 'not-allowed'
                    });

            return;
        }

        // Crear una nueva fila
        var newRow = lastRow.clone(true);

        // Limpiar los campos de la nueva fila
        newRow.find("select").val('');
        newRow.find("input").val("").prop('disabled', false);

        // Deshabilitar la última fila
        lastRow.find('select, input')
                .prop('disabled', true)
                .css({
                    'opacity': '0.6',
                    'cursor': 'not-allowed'
                });

        // Agregar la nueva fila al final de la tabla, pero sin el botón de agregar
        newRow.find("#myButton").remove(); // Eliminar el botón de la fila clonada
        lastRow.parent().append(newRow);

        // Recargar los métodos de pago para la nueva fila
        $.ajax({
            data: {listar: 'buscarmetodo_pago'},
            url: 'jsp/obtenerCobros.jsp',
            type: 'post',
            success: function (response) {
                newRow.find("#idmetodo_pago").html(response);
            }
        });

        // Recalcular la diferencia
        calcularDiferencia();
    });

</script>




<style>
    .section-title {
        background-color: #333333; /* Cambiar el fondo a un negro más opaco */
        padding: 10px;
        font-weight: bold;
        color: white; /* Cambiar el texto a blanco */
    }
    .card-header {
        background-color: #333333; /* Cambiar el fondo a un negro más opaco */
        font-weight: bold;
        color: white; /* Cambiar el texto a blanco */
    }
    .card-body {
        padding: 10px;
        color: black; /* Asegúrate de que el texto en el cuerpo sea negro */
    }
    .section {
        border: 1px solid #ddd;
        margin-bottom: 15px;
    }
    .section input, .section select {
        width: 100%;
        padding: 5px;
    }
    .total {
        font-weight: bold;
        color: red;
    }
    .btn-action {
        margin: 10px;
    }
    .text-danger {
        color: #dc3545;
    }
    /* Nueva regla para el color del texto de los encabezados de la tabla */
    .section table th {
        color: black; /* Cambiar el color del texto a negro */
        background-color: white; /* Fondo blanco para los encabezados de la tabla */
    }
</style>

<div class="container-fluid mt-3">
    <!-- Room and Client Information -->
    <%
        String reservationId = request.getParameter("reservationId");
        String roomId = request.getParameter("roomId");
        String roomName = request.getParameter("roomName");
        String roomDescription = request.getParameter("roomDescription");
        String roomPrice = request.getParameter("roomPrice");
        String guestFullName = request.getParameter("guestFullName");
        String guestCI = request.getParameter("guestCI");
        String guestPhone = request.getParameter("guestPhone"); // Nuevo campo
        String guestEmail = request.getParameter("guestEmail"); // Nuevo campo
        String checkInDate = request.getParameter("checkInDate");
        String checkOutDate = request.getParameter("checkOutDate"); // Nuevo campo
        String deposit = request.getParameter("deposit"); // Nuevo campo
%>

    <div class="row">
        <div class="col-md-4 section">
            <div class="card-header">Datos de la habitación</div>
            <div class="card-body">
                <p><strong>Nombre:</strong> <%= roomName != null ? roomName : "N/A"%></p>
                <p><strong>Descripción:</strong> <%= roomDescription != null ? roomDescription : "N/A"%></p>
                <p><strong>Costo:</strong> Gs. <%= roomPrice != null ? roomPrice : "0"%></p>
                <p><strong>Seña:</strong> Gs. <%= deposit != null ? deposit : "Ninguno"%></p> <!-- Mostrar seña -->
                <input type="hidden" id="roomId" name="roomId" value="<%= roomId != null ? roomId : ""%>">
                <input type="hidden" id="reservationId" name="reservationId" value="<%= reservationId != null ? reservationId : ""%>">
            </div>
        </div>
        <div class="col-md-4 section">
            <div class="card-header">Datos del cliente</div>
            <div class="card-body">
                <p><strong>Nombre:</strong> <%= guestFullName != null ? guestFullName : "N/A"%></p>
                <p><strong>Documento:</strong> <%= guestCI != null ? guestCI : "N/A"%></p>
                <p><strong>Teléfono:</strong> <%= guestPhone != null ? guestPhone : "N/A"%></p> <!-- Mostrar teléfono -->
                <p><strong>Correo:</strong> <%= guestEmail != null ? guestEmail : "N/A"%></p> <!-- Mostrar correo -->
            </div>
        </div>
        <div class="col-md-4 section">
            <div class="card-header">Datos hospedaje</div>
            <div class="card-body">
                <p><strong>Fecha/Hora entrada:</strong> <%= checkInDate != null ? checkInDate : "N/A"%></p>
                <p><strong>Fecha y hora de salida:</strong> <%= checkOutDate != null ? checkOutDate : "N/A"%></p> <!-- Mostrar fecha de salida -->
                <p><strong>Tiempo estimado:</strong> 1 día(s) 0 horas 0 minutos</p> <!-- Este campo debe ser calculado según tus reglas de negocio -->
                <p><strong>Tiempo Rebasado:</strong> Sin tiempo rebasado</p> <!-- Este campo también debe ser calculado -->
            </div>
        </div>
    </div>
        

    <%
        // Convertir fechas a objetos Date
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date checkIn = sdf.parse(checkInDate);
Date checkOut = sdf.parse(checkOutDate);

// Calcular el tiempo de estancia en días
long diffInMillies = checkOut.getTime() - checkIn.getTime();
long diffInDays = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);

        // Calcular el costo total
        double pricePerDay = Double.parseDouble(roomPrice);
        double depositAmount = deposit != null ? Double.parseDouble(deposit) : 0.0; // Seña
        double totalCost = (pricePerDay * diffInDays) + depositAmount;

        // Formatear el costo total
        DecimalFormat decimalFormat = new DecimalFormat("#,###.##");
        String formattedTotalCost = decimalFormat.format(totalCost);

        // También pasa el total como un número sin formatear
        double totalCostForJavaScript = totalCost; // Este es el total sin formatear
%>
        <%
    System.out.println("Precio por día: " + pricePerDay);
    System.out.println("Monto de la seña: " + depositAmount);
    System.out.println("Días de estancia: " + diffInDays);
    System.out.println("Costo total: " + totalCost);
    System.out.println("Costo total formateado: " + formattedTotalCost);
%>

    <!-- Costo calculado -->
    <div class="section mt-3">
        <div class="section-title">Costo del alojamiento</div>
        <div class="card-body">
            <div class="row">
                <div class="col">
                    <strong>Costo calculado:</strong>
                    <div>Gs. <%= formattedTotalCost%></div> <!-- Muestra el total debajo -->
                </div>
                <div class="col">
                    <strong>Mora/Penalidad:</strong>
                    <input type="text" placeholder="--">
                </div>
                <div class="col">
                    <strong>Por pagar:</strong>
                    <div>Gs. <%= formattedTotalCost%></div> <!-- Muestra el total debajo -->
                </div>
                <div class="col">
                    <strong>Responsable:</strong>
                    <div>Dayana</div> <!-- Muestra el nombre debajo -->
                </div>
            </div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">Servicio al cuarto</div>
        <div class="card-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Producto/Servicio</th>
                        <th>Cantidad</th>
                        <th>Precio unitario</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody id="resultadoscobro">

                </tbody>
            </table>
        </div>
    </div>

    <style>
        .final-compra-btn {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
        .final-compra-btn:hover {
            background-color: #c82333;
        }
        .cancelar-compra-btn {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
            margin-left: 20px; /* Aumentar el margen izquierdo */
        }
        .cancelar-compra-btn:hover {
            background-color: #218838;
        }


    </style>
    <!-- Payment Section -->
    <div class="section" style="display: flex; flex-direction: column; align-items: flex-start; width: 100%;">
    <div class="card-body" style="width: 100%; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap;">
        <div class="col-md-4" style="font-size: 20px; display: flex; align-items: center; flex: 1;">
            <span>TOTAL: Gs.</span>
            <strong class="total" id="lbltotal" name="lbltotal" style="margin-left: 5px;"></strong>
            <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
        </div>
        <div style="display: flex; align-items: center; flex: 1; justify-content: flex-end; margin: 10px;">
            <div style="display: flex; flex-direction: column; align-items: flex-end; margin-right: 20px;">
                <label for="idtipo_pago" class="bmd-label-floating" style="margin-bottom: -10px; margin-left: -1px; margin-top: 20px;">Tipo de Pago</label>
                <select id="idtipo_pago" name="idtipo_pago" class="form-control" 
                        onchange="dividirtipo_pago(this.value)" style="width: 85px; margin-top: 10px;">
                    <!-- Opciones del select -->
                </select>
            </div>
            <button class="final-compra-btn" style="margin-right: 5px;">Regresar</button>
            <button class="cancelar-compra-btn" id="final-cobro">Culminar</button>
        </div>
    </div>
</div>
</div>

<script>
    $(document).ready(function () {
        cargardetalle();
        buscartipo_pago();
    });

    function buscartipo_pago() {
        $.ajax({
            data: {listar: 'buscartipo_pago'},
            url: 'jsp/obtenerCobros.jsp',
            type: 'post',
            success: function (response) {
                $("#idtipo_pago").html(response);
            }
        });
    }

    function dividirtipo_pago(a) {
        datos = a.split(',');
        $("#codtipo_pago").val(datos[0]);
    }


    function cargardetalle() {
        var reservationId = $("#reservationId").val(); // Obtener el ID de reserva del campo oculto

        $.ajax({
            data: {
                listar: 'listarcobro', // Parámetro que indica qué acción realizar
                reservationId: reservationId // Enviar el ID de reserva
            },
            url: 'jsp/cobrocrud.jsp', // URL a la que se envía la solicitud
            type: 'post', // Método HTTP
            success: function (response) {
                // Verificar si la respuesta está vacía
                if (response.trim() === "") {
                    $("#resultadoscobro").html("<tr><td colspan='4'>No hay datos disponibles.</td></tr>");
                } else {
                    // Actualizar la tabla con los resultados
                    $("#resultadoscobro").html(response);
                }
                sumador(reservationId); // Pasar el reservationId a la función sumador
            },
            error: function () {
                // Manejo de errores en la solicitud AJAX
                $("#resultadoscobro").html("<tr><td colspan='4'>Error al cargar los detalles.</td></tr>");
            }
        });
    }

    function formatNumberWithThousandsSeparator(number) {
        // Redondear a 2 decimales y convertir a número para eliminar ceros finales
        let formattedNumber = parseFloat(number.toFixed(2));

        // Convertir a string y formatear con separador de miles
        return formattedNumber.toLocaleString('es-PY', {
            minimumFractionDigits: 0,
            maximumFractionDigits: 2
        });
    }

    function sumador(reservationId) {
        $.ajax({
            data: {
                listar: 'listarsuma',
                reservationId: reservationId
            },
            url: 'jsp/cobrocrud.jsp',
            type: 'post',
            success: function (response) {
                console.log("Total calculado de servicios:", response);

                var totalCalculated = parseFloat(response);
                var formattedTotalCost = <%= totalCostForJavaScript%>;

                var finalTotal = totalCalculated + formattedTotalCost;

                // Formatear con separador de miles
                var displayTotal = formatNumberWithThousandsSeparator(finalTotal);

                $("#lbltotal").html(displayTotal);
                $("#txtTotalCompra").val(finalTotal.toFixed(2)); // Mantener valor original para cálculos
            },
            error: function () {
                console.error("Error al calcular el total");
            }
        });
    }
    $("#final-cobro").click(function () {
        calcularDiferencia();

        let tipoPago = $("#idtipo_pago").val();
        console.log("Tipo de pago seleccionado: ", tipoPago);

        if (tipoPago === "") {
            let errorMsg = $("<span class='error-msg' style='color:red;'>Seleccione un tipo de pago</span>").hide();
            $("#idtipo_pago").after(errorMsg);
            errorMsg.fadeIn().delay(1000).fadeOut(function () {
                $(this).remove();
            });
            return; // Detener el proceso si no hay tipo de pago
        }

        // Si el tipo de pago no es "Despues", se puede mostrar el modal
        console.log("Mostrando el modal de pago");
        $("#modalPago").modal("show");
    });

</script>            

<%@include file="footer.jsp" %>
