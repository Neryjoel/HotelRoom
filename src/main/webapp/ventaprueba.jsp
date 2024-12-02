<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="header.jsp" %>
<%
    // Obtener la fecha actual
    Date fechaActual = new Date();

    // Crear un formateador de fecha
    SimpleDateFormat formateadorFecha = new SimpleDateFormat("dd-MM-yyyy");

    // Formatear la fecha
    String fechaFormateada = formateadorFecha.format(fechaActual);
%>
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
                    <button type="button" class="btn btn-primary" id="btnPagar">Pagar</button>
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
        success: function(response) {
            console.log('Respuesta del servidor:', response);
            if (response.trim().includes('Error')) {
                console.error('Error en la inserción:', response);
                alert(response); // Mostrar mensaje de error al usuario
            } else {
                console.log('Cobro insertado exitosamente');
            }
        },
        error: function(xhr, status, error) {
            console.error('Error en la solicitud AJAX:', {
                status: status,
                error: error,
                responseText: xhr.responseText
            });
            alert('Error al insertar cobro: ' + error);
        }
    });
}

// En la función de pago
$("#btnPagar").click(function () {
    let total = $("#txtTotalCompra").val();
    let tipoPago = $("#idtipo_pago").val();
    let reservationId = $("#reservationId").val();
    let userId = $("#userId").val();

    $.ajax({
        data: {
            listar: 'finalcompra', 
            total: total, 
            codtipo_pago: tipoPago, 
            reservationId: reservationId, 
            userId: userId
        },
        url: 'jsp/ventacrud.jsp',
        type: 'post',
        success: function (response) {
            console.log('Respuesta de finalizar compra:', response);

            // Obtener el ID de la factura recién creada
            $.ajax({
                url: 'jsp/obtenerUltimaFactura.jsp',
                type: 'POST',
                data: {
                    reservationId: reservationId,
                    userId: userId
                },
                success: function(facturaResponse) {
                    let facturaId = facturaResponse.trim();
                    console.log('ID de factura obtenido:', facturaId);

                    // Recorrer métodos de pago
                    $(".payment-table tbody tr").each(function() {
                        let metodoPagoId = $(this).find("#codmetodo_pago").val();
                        let monto = $(this).find("input[name='monto']").val();
                        let bancoId = $(this).find("#codbancos").val();
                        let tipoTarjetaId = $(this).find("#codtipo_tarjeta").val();
                        let nroTransaccion = $(this).find("input[name='nro_transaccion']").val();

                        // Depuración de valores
                        console.log('Datos de pago:', {
                            metodoPagoId: metodoPagoId,
                            monto: monto,
                            bancoId: bancoId,
                            tipoTarjetaId: tipoTarjetaId,
                            nroTransaccion: nroTransaccion
                        });

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

                    //location.href = 'ventas.jsp';
                },
                error: function(xhr, status, error) {
                    console.error('Error al obtener ID de factura:', error);
                    alert('No se pudo obtener el ID de la factura');
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
    .is-invalid {
        border-color: red !important;
        box-shadow: 0 0 5px rgba(255, 0, 0, 0.5) !important;
    }


    .info-section {
        display: flex;
        justify-content: space-between;
        margin-bottom: 20px;
    }
    .info-card {
        width: 45%;
        padding: 10px;
        background: #e9ecef;
        border-radius: 10px;
        font-family: Arial, sans-serif;
        background-color: #f8f9fa;
    }
    .info-card h3 {
        margin: 0 0 10px 0;
        font-size: 18px;
    }
    .info-card p {
        margin: 5px 0;
        font-size: 14px;
    }

    select, button {
        padding: 10px;
        margin-right: 10px;
        border-radius: 5px;
        border: 1px solid #ced4da;
    }
    button {
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }
    button:hover {
        background-color: #0056b3;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    th, td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }
    th {
        background-color: #343a40;
        color: white;
    }
    td button {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 5px 10px;
        border-radius: 5px;
        cursor: pointer;
    }
    td button:hover {
        background-color: #c82333;
    }
</style>
<style>
    .final-compra-btn {
        background-color: #28a745;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 20px;
        float: right;
    }
    .final-compra-btn:hover {
        background-color: #218838;
    }
    .cancelar-compra-btn {
        background-color: #dc3545;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 20px;
        float: right;
        margin-left: 10px;
    }
    .cancelar-compra-btn:hover {
        background-color: #c82333;
    }
</style>

<div class="container-fluid">
    <form id="detalleForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <h1>Proceso de venta</h1>
        <div class="info-section">
            <%
                String reservationId = request.getParameter("reservationId");
                String roomId = request.getParameter("roomId");
                String roomName = request.getParameter("roomName");
                String roomDescription = request.getParameter("roomDescription");
                String roomPrice = request.getParameter("roomPrice");
                String guestFullName = request.getParameter("guestFullName");
                String guestCI = request.getParameter("guestCI");
                String guestEmail = request.getParameter("guestEmail");
                String checkInDate = request.getParameter("checkInDate");

                // Asegúrate de que estas variables estén definidas y tengan valores válidos
                String numTimbrado = request.getParameter("numTimbrado");
                String idTimbrado = request.getParameter("idTimbrado"); // Obtener ID del timbrado
                String fechaInicio = request.getParameter("fechaInicio");
                String fechaFin = request.getParameter("fechaFin");
                String numeroFactura = request.getParameter("numeroFactura");

                String idMovimientoActual = request.getParameter("idMovimientoActual"); // Obtener el ID del movimiento

                // Obtener ID y nombre de usuario
                String userId = request.getParameter("userId");
                String userName = request.getParameter("userName");
                String cajaId = request.getParameter("cajaId");

            %>

            <div class="info-card">
                <h3>Datos de la habitación</h3>
                <p><strong>Nombre:</strong> <%= roomName != null ? roomName : "N/A"%></p>
                <p><strong>Descripción:</strong> <%= roomDescription != null ? roomDescription : "N/A"%></p>
                <p><strong>Costo:</strong> Gs.<%= roomPrice != null ? roomPrice : "0"%></p>
            </div>

            <div class="info-card">
                <h3>Datos del cliente</h3>
                <p><strong>Nombre:</strong> <%= guestFullName != null ? guestFullName : "N/A"%></p>
                <p><strong>Documento:</strong> <%= guestCI != null ? guestCI : "N/A"%></p>
                <p><strong>Correo:</strong> <%= guestEmail != null ? guestEmail : "N/A"%></p>
                <p><strong>Fecha/Hora entrada:</strong> <%= checkInDate != null ? checkInDate : "N/A"%></p>
            </div>

            <div class="info-card">
                <h3>Datos de la factura</h3>
                <p><strong>Timbrado:</strong> <%= numTimbrado != null ? numTimbrado : "N/A"%></p>
                <p><strong>Fecha inicio:</strong> <%= fechaInicio != null ? fechaInicio : "N/A"%></p>
                <p><strong>Fecha fin:</strong> <%= fechaFin != null ? fechaFin : "N/A"%></p>
                <p><strong>Responsable:</strong> <%= userName != null ? userName : "N/A"%></p>
                <!-- comment 
                <p><strong>ID Caja:</strong><input type="hidden" id="cajaId"  value="<%= cajaId%>"></p>
                <p><strong>Nro Factura:</strong> <input type="hidden" id="numeroFactura"  value="<%= numeroFactura%>"></p>
                <p><strong>ID Timbrado:</strong> <%= idTimbrado != null ? idTimbrado : "N/A"%></p>
                <p><strong>ID Movimiento:</strong> <%= idMovimientoActual != null ? idMovimientoActual : "N/A"%></p>
                -->
            </div>
        </div>


        <div class="row align-items-end">
            <div class="col-12 col-md-2">
                <div class="form-group">
                   
                   
                    <input type="hidden" id="userId"  value="<%= userId%>">
                    <input type="hidden" name="codreservas" id="reservationId"  value="<%= reservationId%>">
                    <input type="hidden"  id="roomId"  value="<%= roomId%>">
                    <label for="fechafac" class="bmd-label-floating">FECHA DE FACTURA</label>
                    <input type="text" class="form-control" id="fechafac" name="fechafac" maxlength="45" 
                           autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly="readonly">
                </div>
            </div>

            <div class="col-12 col-md-6">
                <div class="form-group">
                    <label for="idarticulos" class="bmd-label-floating">Artículos</label>
                    <input type="hidden" id="codarticulos" name="codarticulos" class="form-control" 
                           placeholder="Ingrese Artículo" disabled>
                    <select id="idarticulos" name="idarticulos" class="form-control" 
                            onchange="dividirarticulo(this.value)">
                        <!-- Opciones de artículos aquí -->
                    </select>
                </div>
            </div>

            <div class="col-12 col-md-1">
                <div class="form-group">
                    <label for="art_precio_venta" class="bmd-label-floating">Precio</label>
                    <input class="form-control" type="text" name="art_precio_venta" id="art_precio_venta" 
                           autocomplete="off" placeholder="Precio" required 
                           onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" 
                           readonly="readonly">
                </div>
            </div>

            <div class="col-12 col-md-1">
                <div class="form-group">
                    <label for="cantidad" class="bmd-label-floating">CANTIDAD</label>
                    <input class="form-control number" value="1" type="text" name="cantidad" id="cantidad" 
                           onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" 
                           placeholder="Cantidad">
                </div>
            </div>

            <div class="col-12 col-md-1">
                <div class="form-group">
                    <button id="guardarfactura">Agregar</button>
                </div>
            </div>
        </div>
        <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
        <div id="respuesta"></div>
    </form>
    <table >
        <thead>
            <tr>
                <th>Descripcion</th>
                <th>Cantidad</th>
                <th>Precio Unit.</th>
                <th>Precio Total</th>
                <th>Opcion</th>
            </tr>
        </thead>
        <tbody id="resultados">

        </tbody>
    </table>

    <div style="display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center;margin-top: 32px;">
            <strong><label style="font-size: 20px; position: relative; top: 4px;">Total:</label></strong>
            <strong id="lbltotal" name="lbltotal" style="margin-left: 10px; font-size: 20px;"></strong>
            <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
        </div>

        <div style="display: flex; align-items: center; gap: 20px;">
            <div style="display: flex; flex-direction: column;">
                <label for="idtipo_pago" class="bmd-label-floating" style="position: relative; top: 12px;left: -2px;">Tipo de Pago</label>
                <select id="idtipo_pago" name="idtipo_pago" class="form-control" 
                        onchange="dividirtipo_pago(this.value)" style="margin-top: 5px;">
                </select>
            </div>

            <div style="display: flex; gap: 10px;">
                <button class="final-compra-btn" id="final-compra">Terminar venta</button>
                <button class="cancelar-compra-btn" id="cancelar-compra">Cancelar</button>
            </div>
        </div>
    </div>

</div>

<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Eliminar Registro</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Esta seguro de querer eliminar el registro?
                <input type="hidden" name="pkdel" id="pkdel"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="delcompra">SI</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        buscararticulo();
        buscartipo_pago();
        cargardetalle();
    });

    function buscararticulo() {
        $.ajax({
            data: {listar: 'buscararticulo'}, // Cambia 'buscararticulo' según sea necesario
            url: 'jsp/obtenerVentas.jsp',
            type: 'post',
            success: function (response) {
                $("#idarticulos").html(response);
            }
        });
    }

    function buscartipo_pago() {
        $.ajax({
            data: {listar: 'buscartipo_pago'},
            url: 'jsp/obtenerVentas.jsp',
            type: 'post',
            success: function (response) {
                $("#idtipo_pago").html(response);
            }
        });
    }

    function dividirarticulo(a) {
        // Si se selecciona "Seleccionar", limpiar campos
        if (a === "" || a === "Seleccionar") {
            $("#codarticulos").val("");
            $("#art_precio_venta").val("");
            return;
        }

        datos = a.split('|');
        $("#codarticulos").val(datos[0]);

        // Llamada AJAX para obtener el precio de venta del artículo seleccionado
        $.ajax({
            data: {listar: 'obtenerPrecio', idarticulo: datos[0]},
            url: 'jsp/obtenerVentas.jsp',
            type: 'post',
            success: function (response) {
                $("#art_precio_venta").val(response);
            },
            error: function () {
                $("#art_precio_venta").val("");
            }
        });
    }

    function dividirtipo_pago(a) {
        datos = a.split(',');
        $("#codtipo_pago").val(datos[0]);
    }

</script>

<script>
    function sumador(reservationId) {
        $.ajax({
            data: {listar: 'listarsuma',
                reservationId: reservationId},
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            success: function (response) {
                $("#lbltotal").html(response);
                $("#txtTotalCompra").val(response);
            }
        });
    }

    function validarSeleccionarCamposVacios(callback, esFinalizarCompra = false) {
        let valid = true;
        $(".error-msg").remove();

        // Validar el campo idarticulos siempre
        if ($("#idarticulos").val() === "") {
            valid = false;
            let errorMsg = $("<span class='error-msg' style='color:red;'>Este campo es obligatorio</span>").hide();
            $("#idarticulos").after(errorMsg);
            errorMsg.fadeIn().delay(500).fadeOut(function () {
                $(this).remove();
            });
        }

        // Si estamos finalizando la compra, validar el tipo de pago
        if (esFinalizarCompra) {
            // Solo validar el tipo de pago cuando se finaliza la compra
            if ($("#idtipo_pago").val() === "") {
                valid = false;
                let errorMsg = $("<span class='error-msg' style='color:red;'>El tipo de pago es obligatorio</span>").hide();
                $("#idtipo_pago").after(errorMsg);
                errorMsg.fadeIn().delay(1000).fadeOut(function () {
                    $(this).remove();
                });
            }
        }
        // Si todos los campos son válidos, ejecutar el callback
        if (valid) {
            setTimeout(callback, 500);
    }
    }
    $("#guardarfactura").click(function () {
        validarSeleccionarCamposVacios(function () {
            let datosform = $("#detalleForm").serialize();
            $.ajax({
                data: datosform,
                url: 'jsp/ventacrud.jsp',
                type: 'post',
                success: function (response) {
                    $("#respuesta").html(response);
                    cargardetalle();

                    // Limpiar campos después de agregar
                    $("#idarticulos").val(""); // Restablecer a la opción por defecto
                    $("#art_precio_venta").val(""); // Limpiar precio
                    $("#cantidad").val("1"); // Restablecer cantidad a 1

                    setTimeout(function () {
                        $("#respuesta").fadeOut();
                    }, 2000);
                },
                error: function (xhr, status, error) {
                    console.error("Error en la solicitud:", error);
                }
            });
        }, false);
    });

$("#final-compra").click(function () {
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

    // Si el tipo de pago es "Despues"
    if (tipoPago.trim() === "2") { // Suponiendo que "2" corresponde a "Despues"
        console.log("Insertando datos porque el tipo de pago es 'Despues'");

        // Obtener el total y otros datos necesarios
        let total = $("#txtTotalCompra").val();
        let reservationId = $("#reservationId").val();
        let userId = $("#userId").val();

        // Realizar la inserción directamente
        $.ajax({
            data: {
                listar: 'finalcompra', 
                total: total, 
                codtipo_pago: tipoPago, 
                reservationId: reservationId, 
                userId: userId
            },
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            success: function (response) {
                console.log('Respuesta de finalizar compra:', response);
                // Aquí puedes manejar la respuesta, por ejemplo, redirigir o mostrar un mensaje
                alert('Venta finalizada con éxito.');
                // Redirigir o recargar la página si es necesario
                // location.href = 'ventas.jsp';
            },
            error: function (error) {
                alert("Error al finalizar la compra: " + error);
            }
        });
        return; // Detener el proceso aquí, ya que hemos manejado la inserción
    }

    // Si el tipo de pago no es "Despues", se puede mostrar el modal
    console.log("Mostrando el modal de pago");
    $("#modalPago").modal("show");    
});

    
    function cargardetalle() {
        var reservationId = $("#reservationId").val(); // Obtener el ID de reserva del campo oculto
        var userId = $("#userId").val(); // Obtener el ID de usuario

        $.ajax({
            data: {
                listar: 'listar', // Parámetro que indica qué acción realizar
                reservationId: reservationId, // Enviar el ID de reserva
                userId: userId // Enviar el ID de usuario
            },
            url: 'jsp/ventacrud.jsp', // URL a la que se envía la solicitud
            type: 'post', // Método HTTP
            success: function (response) {
                // Verificar si la respuesta está vacía
                if (response.trim() === "") {
                    $("#resultados").html("<tr><td colspan='4'>No hay datos disponibles.</td></tr>");
                } else {
                    // Actualizar la tabla con los resultados
                    $("#resultados").html(response);
                }
                sumador(reservationId); // Pasar el reservationId a la función sumador
            },
            error: function () {
                // Manejo de errores en la solicitud AJAX
                $("#resultados").html("<tr><td colspan='4'>Error al cargar los detalles.</td></tr>");
            }
        });
    }
    $("#delcompra").click(function () {
        let pkd = $("#pkdel").val();
        $.ajax({
            data: {listar: 'elimregcompra', pkd: pkd},
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            success: function (response) {
                cargardetalle();
                sumador();
            }
        });
    });

    $("#cancelar-compra").click(function () {
        // Evitar múltiples clics
        $(this).prop("disabled", true);
        // Realiza la llamada AJAX para cancelar la compra
        $.ajax({
            data: {
                listar: 'cancelcompra',
                reservationId: $("#reservationId").val(), // Enviar el ID de reserva
                userId: $("#userId").val() // Enviar el ID del usuario
            },
            url: 'jsp/ventacrud.jsp',
            type: 'post',
            success: function (response) {
                // Redirigir o actualizar la interfaz según sea necesario
                location.href = 'ventas.jsp';
            },
            error: function (error) {
                alert("Error al cancelar la compra: " + error);
            },
            complete: function () {
                // Rehabilitar el botón después de la operación
                $("#cancelar-compra").prop("disabled", false);
            }
        });
    });

</script>

<%@ include file="footer.jsp" %> 