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


<div class="modal fade" id="modalPago" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <style>
                .modal-title-large {
                    font-size: 24px; /* Ajusta este valor al tamaño deseado */
                    font-weight: bold; /* Aplica negrita */
                }

                .form-control-small {
                    width: 150px; /* Ajuste del tamaño en el ancho a 150px */
                    height: 30px; /* Mantiene la altura */
                    margin-bottom: 10px; /* Espacio entre inputs */
                }

                .table-responsive {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                }

                .payment-table th, .payment-table td {
                    text-align: center;
                    vertical-align: middle;
                }

                .payment-table input, .payment-table select {
                    width: 140px; /* Ajuste del tamaño en el ancho a 150px */
                    margin: auto;
                }

                .payment-table td button {
                    display: block;
                    margin: auto;
                }

                .modal-footer {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding: 20px;
                }

                .difference, .total-container {
                    margin-bottom: 10px;
                }

                /* Eliminar scroll en el modal */
                .modal-content {
                    overflow-y: visible;
                }
            </style>
            <div class="modal-header">
                <h5 class="modal-title w-100 text-center modal-title-large" id="exampleModalLabel">Seleccione método de pago</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="table-responsive">
                    <form id="cobroForm">
                        <table class="payment-table">
                            <thead>
                                <tr>
                                    <th>Método de pago</th>
                                    <th>Monto</th>
                                    <th>Banco</th>
                                    <th>Tipo Trajeta</th>
                                    <th>Nro. Transacción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="clon">
                                    <td>
                                        <input type="hidden" id="codmetodo_pago" name="codtipo_pago">
                                        <select id="idmetodo_pago" name="idmetodo_pago" onchange="dividirmetodo_pago(this.value)" class="form-control-small"></select>
                                    </td>
                                    <td><input type="number" placeholder="Monto" id="monto" name="monto" class="form-control-small"></td>
                                    <td>
                                        <input type="hidden" id="codbancos" name="codbancos">
                                        <select id="idbancos" name="idbancos" onchange="dividirbanco(this.value)" class="form-control-small"></select>
                                    </td>
                                    <td>
                                        <input type="hidden" id="codtipo_tarjeta" name="codtipo_tarjeta">
                                        <select id="idtipo_tarjeta" name="idtipo_tarjeta" onchange="dividirtipo_tarjeta(this.value)" class="form-control-small"></select>
                                    </td>
                                    <td><input type="text" name="nro_transaccion" id="nro_transaccion" placeholder="Nro. de Transacción" class="form-control-small"></td>
                                    <td><button type="button" id="myButton"><i class="fas fa-plus" title="Agregar Más Métodos"></i></button></td>
                                            <%
                                                // Captura el ID de la factura desde la solicitud
                                                String idfactura = request.getParameter("idfactura");

                                                // Verifica si idfactura es nulo y asigna un valor predeterminado si es necesario
                                                if (idfactura == null) {
                                                    idfactura = "0"; // O cualquier valor predeterminado que desees
                                                }
                                            %>
                            <input type="hidden" id="idfactura" value="<%= idfactura%>">
                            </tr>
                            </tbody>
                        </table>
                    </form>
                </div>
            </div>
            <div class="modal-footer">
                <div>
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
        let datos = a.split(',');
        $("#codmetodo_pago").val(datos[0]);
        $("#descripcion").val(datos[1]);
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

    function dividirbanco(a) {
        let datos = a.split(',');
        $("#codbancos").val(datos[0]);
        $("#ban_descripcion").val(datos[1]);
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

    function dividirtipo_tarjeta(a) {
        let datos = a.split(',');
        $("#codtipo_tarjeta").val(datos[0]);
        $("#tar_descripcion").val(datos[1]);
    }

    $("#myButton").on("click", function () {
        let total = parseFloat($("#txtTotalCompra").val()); // Obtiene el total permitido
        let montoPagado = 0; // Inicializa el monto pagado

        // Recorre cada fila de la tabla de pagos para sumar los montos pagados
        $(".payment-table tbody tr").each(function () {
            let monto = parseFloat($(this).find("input[name='monto']").val());
            if (!isNaN(monto)) {
                montoPagado += monto;
            }
        });

        // Calcula la diferencia entre el total permitido y lo ya pagado
        let diferencia = total - montoPagado;

        // Permite agregar filas mientras la diferencia sea mayor a 0
        if (diferencia > 0) {
            var row = document.querySelector('tr.clon'); // Selecciona la fila con la clase "clon"
            var newRow = row.cloneNode(true); // Clona la fila
            var button = newRow.querySelector('button'); // Selecciona el botón dentro de la fila clonada
            button.parentNode.removeChild(button); // Elimina el botón de la fila clonada
            row.parentNode.appendChild(newRow); // Agrega la nueva fila debajo de la fila actual

            // Limpia los campos de la nueva fila
            $(newRow).find("input[name='monto']").val("");
            $(newRow).find("input[name='nro_transaccion']").val("");

            // Vuelve a calcular la diferencia
            calcularDiferencia();
        } else {
            // Si se iguala o supera el total, deshabilita el botón y actualiza la diferencia
            $("#myButton").prop("disabled", true);
            calcularDiferencia();
        }
    });

    $("#btnPagar").click(function () {
        // Llama a calcularDiferencia antes de mostrar el modal
        calcularDiferencia(); // Asegúrate de calcular antes de mostrar el modal

        // Captura los datos necesarios del modal
        let metodoPago = $("#idmetodo_pago").val();
        let monto = $("#monto").val();
        let banco = $("#idbancos").val();
        let tipoTarjeta = $("#idtipo_tarjeta").val();
        let nroTransaccion = $("#nro_transaccion").val();

        // Captura el ID de la factura
        let idfactura = $("#idfactura").val(); // Asegúrate de que este ID esté presente

        // Realiza la llamada AJAX para insertar en la tabla cobros
        $.ajax({
            url: 'jsp/cobrocrud.jsp', // URL del servlet o JSP que manejará la inserción
            type: 'post',
            data: {
                listar: 'insertarCobro', // Parámetro para identificar la acción
                idfactura: idfactura, // Incluye el ID de la factura
                metodoPago: metodoPago,
                monto: monto,
                banco: banco,
                tipoTarjeta: tipoTarjeta,
                nroTransaccion: nroTransaccion // Asegúrate de enviar este dato también
            },
            success: function (response) {
                alert("Pago registrado exitosamente.");
                $("#modalPago").modal("hide");
            },
            error: function (error) {
                alert("Error al registrar el pago: " + error);
            }
        });
    });

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

    }
</script>                            

<style>
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
        <p><strong>ID Timbrado:</strong> <%= idTimbrado != null ? idTimbrado : "N/A"%></p>
        <p><strong>Timbrado:</strong> <%= numTimbrado != null ? numTimbrado : "N/A"%></p>
        <p><strong>Fecha inicio:</strong> <%= fechaInicio != null ? fechaInicio : "N/A"%></p>
        <p><strong>Fecha fin:</strong> <%= fechaFin != null ? fechaFin : "N/A"%></p>
        <p><strong>Nro Factura:</strong> <%= numeroFactura != null ? numeroFactura : "N/A"%></p>
        <p><strong>ID Movimiento:</strong> <%= idMovimientoActual != null ? idMovimientoActual : "N/A"%></p> <!-- Mostrar ID del movimiento -->
        <p><strong>Responsable:</strong> <%= userName != null ? userName : "N/A"%></p>
    </div>
</div>
    

        <div class="row align-items-end">
            <div class="col-12 col-md-2">
                <div class="form-group">
                    <input type="" id="userId"  value="<%= userId%>">
                    <input type="" name="codreservas" id="reservationId"  value="<%= reservationId%>">
                    <input type=""  id="roomId"  value="<%= roomId%>">
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
    // Validar específicamente el tipo de pago
    if ($("#idtipo_pago").val() === "") {
        let errorMsg = $("<span class='error-msg' style='color:red;'>Seleccione un tipo de pago</span>").hide();
        $("#idtipo_pago").after(errorMsg);
        errorMsg.fadeIn().delay(1000).fadeOut(function () {
            $(this).remove();
        });
        return; // Detener el proceso si no hay tipo de pago
    }

    // Si el tipo de pago está seleccionado, continuar con el proceso
    let total = $("#txtTotalCompra").val();
    let tipoPago = $("#idtipo_pago").val();
    let reservationId = $("#reservationId").val(); // Obtener el ID de reserva
    let userId = $("#userId").val(); // Obtener el ID de usuario

    // Llama a calcularDiferencia antes de mostrar el modal
    calcularDiferencia();
    $("#modalPago").modal("show");

    // Realiza la llamada AJAX para finalizar la compra
    $.ajax({
        data: {listar: 'finalcompra', total: total, codtipo_pago: tipoPago, reservationId: reservationId, userId: userId}, // Asegúrate de incluir userId
        url: 'jsp/ventacrud.jsp',
        type: 'post',
        success: function (response) {
            // Aquí puedes manejar la respuesta si es necesario
            //alert("Compra finalizada exitosamente."); // Mensaje de éxito
            //location.href = 'ventas.jsp'; // Redirigir a otra página si es necesario
        },
        error: function (error) {
            alert("Error al finalizar la compra: " + error);
        }
    });
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
        complete: function() {
            // Rehabilitar el botón después de la operación
            $("#cancelar-compra").prop("disabled", false);
        }
    });
});

</script>

<%@ include file="footer.jsp" %> 