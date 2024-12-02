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
<!-- Asegúrate de que jQuery esté incluido -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<div class="container-fluid">
    <form id="detalleForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <legend><i class="fas fa-city"></i> &nbsp; DETALLE FACTURA</legend>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="fechafac" class="bmd-label-floating">FECHA DE FACTURA</label>
                            <input type="text" class="form-control" id="fechafac" name="fechafac" maxlength="45" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly="readonly">
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="idservicios" class="bmd-label-floating">DATOS DEL SERVICIOS</label>
                            <input type="hidden" id="codservicios" name="codservicios"><!<!-- va a contener el pk cuando se usa el split -->
                            <select id="idservicios" name="idservicios" class="form-control" onchange="dividirservicio(this.value)"></select>
                        </div>
                    </div>  

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="ser_precio" class="bmd-label-floating">PRECIO SERVICIO</label>
                            <input class="form-control" type="text" name="ser_precio" id="ser_precio" autocomplete="off" placeholder="precio" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
                        </div>
                    </div>
                    
                    <!--################## RESERVAS #################-->

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="idreservas" class="bmd-label-floating">DATOS DEL RESERVAS</label>
                            <input type="hidden" id="codreservas" name="codreservas"><!<!-- va a contener el pk cuando se usa el split -->
                            <select id="idreservas" name="idreservas" class="form-control" onchange="dividirreserva(this.value)"></select>
                        </div>
                    </div>  

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="res_fecha_entrada" class="bmd-label-floating">Fecha de Entrada</label>
                            <input type="date" id="res_fecha_entrada" name="res_fecha_entrada" class="form-control" placeholder="DD/MM/YYYY" readonly="readonly">
                        </div>
                    </div>

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="res_fecha_salida" class="bmd-label-floating">Fecha de Salida</label>
                            <input type="date" id="res_fecha_salida" name="res_fecha_salida" class="form-control" placeholder="DD/MM/YYYY" readonly="readonly">
                        </div>
                    </div>

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="estado" class="bmd-label-floating">Estado</label>
                            <input type="text" id="estado" name="estado" class="form-control" placeholder="Ingrese Estado" readonly="readonly">
                        </div>
                    </div>

                    <!--
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="senia" class="bmd-label-floating">Seña</label>
                            <input type="text" id="senia" name="senia" class="form-control" placeholder="Ingrese seña">
                        </div>
                    </div>
                    -->
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="huespedes_idhuespedes" class="bmd-label-floating">Huespedes</label>
                            <input type="text" id="huespedes_idhuespedes" name="huespedes_idhuespedes" class="form-control" placeholder="Ingrese Huesped" readonly="readonly">
                        </div>
                    </div>


                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="hues_ci" class="bmd-label-floating">CEDULA</label>
                            <input class="form-control" type="text" value="" name="hues_ci" id="hues_ci" onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" placeholder="Cedula" readonly="readonly" required>
                        </div>
                    </div>

                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habitacion_idhabitacion" class="bmd-label-floating">Habitación</label>
                            <input type="text" id="habitacion_idhabitacion" name="habitacion_idhabitacion" class="form-control" placeholder="Ingrese Habitación" readonly="readonly">
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="habi_precio" class="bmd-label-floating">Precio Habitación</label>
                            <input class="form-control" type="text" name="habi_precio" id="habi_precio" autocomplete="off" placeholder="precio" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
                        </div>
                    </div>
                </div>


                <!--################## Método de Pago #################-->
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="metodoPago" class="bmd-label-floating">Método de Pago</label>
                            <input type="hidden" id="codmetodo_pago" name="codmetodo_pago" class="form-control" placeholder="Ingrese Método de Pago">
                            <select id="idmetodo_pago" name="idmetodo_pago" class="form-control" onchange="dividirmetodo_pago(this.value)"></select>

                        </div>
                    </div>
                </div>

                <!--################## Articulos #################-->
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="articulos" class="bmd-label-floating">Artículos</label>
                            <input type="hidden" id="codarticulos" name="codarticulos" class="form-control" placeholder="Ingrese Artículo">
                            <select id="idarticulos" name="idarticulos" class="form-control" onchange="dividirarticulo(this.value)"></select>

                        </div>
                    </div>
                
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="art_precio_venta" class="bmd-label-floating">PRECIO ARTICULO</label>
                            <input class="form-control" type="text" name="art_precio_venta" id="art_precio_venta" autocomplete="off" placeholder="precio" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
                        </div>
                    </div>
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="cantidad" class="bmd-label-floating">CANTIDAD</label>
                            <input class="form-control number" value="1" type="text" name="cantidad" id="cantidad" onKeyUp="this.value = this.value.toUpperCase();" autocomplete="off" placeholder="Cantidad">
                        </div>
                    </div>
                </div>

            </div>
            <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
            </div>

        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button id="guardarfactura" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
        <div id="respuesta"></div>
    </form>
</div>

<div class="table-responsive" style="text-align: center;">
    <table class="table table-dark table-sm" id="resultadodetalle">
        <thead>
        <th>
            <div align="center">Acción</div>
        </th>
        <th>
            <div align="center">Articulo</div>
        </th>
        <th>
            <div align="center">Cantidad</div>
        </th>
        <th>
            <div align="center">Precio</div>
        </th>
        <th>
            <div align="center">Total</div>
        </th>
        </thead>
        <tbody id="resultados">

        </tbody>
    </table>
    <table width="302" id="carritototal">

        <tr>
            <td><span class="Estilo9"><label>Total:</label></span></td>

            <td>
                <div align="right" class="Estilo9">
                    <label id="lbltotal" name="lbltotal"></label>
                    <input type="hidden" name="txtTotal" id="txtTotal" value="0.00" />
                    <input type="hidden" name="txtTotalCompra" id="txtTotalCompra" value="" />
                </div>
            </td>
        </tr>
    </table>
    <div class="modal-footer">
        <button class="btn btn-danger" type="reset" onclick="#" id="cancelar-compra"><span class="fa fa-times"></span> Cancelar</button>
        <button type="button" name="btn-submit" id="final-compra" class="btn btn-primary" onclick="#"><span class="fa fa-save"></span> Registrar</button>
    </div>
</div>

<!-- Modal -->
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
        buscarservicio();
        buscarmetodo_pago();
        buscarreserva();
    });
   
    function buscarservicio() {
        $.ajax({
            data: {listar: 'buscarservicio'},
            url: 'jsp/obtenerFactura.jsp',
            type: 'post',
            success: function (response) {
                $("#idservicios").html(response);
            }
        });
    }

    function buscarreserva() {
        $.ajax({
            data: {listar: 'buscarreserva'},
            url: 'jsp/obtenerFactura.jsp',
            type: 'post',
            success: function (response) {
                $("#idreservas").html(response);
            }
        });
    }

    function buscarmetodo_pago() {
        $.ajax({
            data: {listar: 'buscarmetodo_pago'},
            url: 'jsp/obtenerFactura.jsp',
            type: 'post',
            success: function (response) {
                $("#idmetodo_pago").html(response);
            }
        });
    }

    function buscararticulo() {
        $.ajax({
            data: {listar: 'buscararticulo'},
            url: 'jsp/obtenerFactura.jsp',
            type: 'post',
            success: function (response) {
                $("#idarticulos").html(response);
            }
        });
    }

    function dividirarticulo(a) {
        let datos = a.split(',');
        $("#codarticulos").val(datos[0]);
        $("#art_precio_venta").val(datos[1]);
    }

    function dividirservicio(a) {
        let datos = a.split(',');
        $("#codservicios").val(datos[0]);
        $("#ser_precio").val(datos[1]);
    }

    function dividirreserva(a) {
        let datos = a.split(',');
        $("#codreservas").val(datos[0]);
        $("#res_fecha_entrada").val(datos[1]);
        $("#res_fecha_salida").val(datos[2]);
        $("#estado").val(datos[3]);
        $("#huespedes_idhuespedes").val(datos[4]);
        $("#hues_ci").val(datos[5]);
        $("#habitacion_idhabitacion").val(datos[6]);
        $("#habi_precio").val(datos[7]);
    }

    function dividirmetodo_pago(a) {
        let datos = a.split(',');
        $("#codmetodo_pago").val(datos[0]);
        $("#descripcion").val(datos[1]);
    }

    function validarSeleccionarCamposVacios(callback) {
        let valid = true;
        $(".error-msg").remove();
        $("#idhuespedes, #idservicios, #idreservas, #idmetodo_pago").each(function () {
            let errorMsg = $("<span class='error-msg' style='color:red;'>Este campo es obligatorio</span>").hide();
            if ($(this).val() === "") {
                valid = false;
                $(this).after(errorMsg);
                errorMsg.fadeIn().delay(500).fadeOut(function () {
                    $(this).remove();
                });
            }
        });
        if (valid) {
            setTimeout(callback, 500);
        }
    }

    $("#guardarfactura").click(function () {
        validarSeleccionarCamposVacios(function () {
            let datosform = $("#detalleForm").serialize();
            $.ajax({
                data: datosform,
                url: 'jsp/facturacrud.jsp',
                type: 'post',
                success: function (response) {
                    $("#respuesta").html(response);
                    cargardetalle();
                }
            });
        });
    });

    function cargardetalle() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/facturacrud.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
                sumador();
            }
        });
    }

    function sumador() {
        $.ajax({
            data: {listar: 'listarsuma'},
            url: 'jsp/facturacrud.jsp',
            type: 'post',
            success: function (response) {
                $("#lbltotal").html(response);
                $("#txtTotalCompra").val(response);
            }
        });
    }

    $("#delcompra").click(function () {
        let pkd = $("#pkdel").val();
        validarSeleccionarCamposVacios(function () {
            $.ajax({
                data: {listar: 'elimregcompra', pkd: pkd},
                url: 'jsp/facturacrud.jsp',
                type: 'post',
                success: function (response) {
                    cargardetalle();
                    sumador();
                }
            });
        });
    });

    $("#cancelar-compra").click(function () {
        validarSeleccionarCamposVacios(function () {
            $.ajax({
                data: {listar: 'cancelcompra'},
                url: 'jsp/facturacrud.jsp',
                type: 'post',
                success: function (response) {
                    location.href = 'facturas.jsp';
                }
            });
        });
    });

    $("#final-compra").click(function () {
        let total = $("#txtTotalCompra").val();
        validarSeleccionarCamposVacios(function () {
            $.ajax({
                data: {listar: 'finalcompra', total: total},
                url: 'jsp/facturacrud.jsp',
                type: 'post',
                success: function (response) {
                    location.href = 'facturas.jsp';
                }
            });
        });
    });

</script>

<%@include file="footer.jsp" %>
<td>Reserva: </td>
        <td><input class="form-control" type="text" id="lbltotalReserva" value="0" readonly="readonly"></td>