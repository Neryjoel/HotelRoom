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
    <form id="detalleFormCompra" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <legend><i class="fas fa-shopping-cart"></i> &nbsp; DETALLE COMPRA</legend>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-6">
                        <div class="form-group">
                            <label for="fechacompra" class="bmd-label-floating">FECHA DE COMPRA</label>
                            <input type="text" class="form-control" id="fechacompra" name="fechacompra" maxlength="45" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly="readonly">
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="idproveedores" class="bmd-label-floating">PROVEEDOR</label>
                            <input type="hidden" id="codproveedores" name="codproveedores">
                            <select id="idproveedores" name="idproveedores" class="form-control" onchange="dividirproveedor(this.value)"></select>
                        </div>
                    </div>  

                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="prov_ruc" class="bmd-label-floating">RUC</label>
                            <input class="form-control" type="text" name="prov_ruc" id="prov_ruc" autocomplete="off" placeholder="Ruc" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
                        </div>
                    </div>


                    <!--################## ARTÍCULOS #################-->

                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="idarticulos" class="bmd-label-floating">ARTÍCULOS</label>
                            <input type="hidden" id="codarticulos" name="codarticulos">
                            <select id="idarticulos" name="idarticulos" class="form-control" onchange="dividirarticulo(this.value)"></select>
                        </div>
                    </div>  

                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="art_precio_compra" class="bmd-label-floating">PRECIO ARTÍCULO</label>
                            <input class="form-control" type="text" name="art_precio_compra" id="art_precio_compra" autocomplete="off" placeholder="Precio" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
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
            <button id="guardarcompra" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
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
            <div align="center">Artículo</div>
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

    <div class="col-12 col-md-4">
        <div class="form-group">
            <label for="idtipo_pago" class="bmd-label-floating">Tipo de Pago</label>
            <input type="hidden" id="codtipo_pago" name="codtipo_pago" class="form-control" placeholder="Ingrese tipo de Pago">
            <select id="idtipo_pago" name="idtipo_pago" class="form-control" onchange="dividirtipo_pago(this.value)"></select>

        </div>
    </div>
    <div class="modal-footer">
        <button class="btn btn-danger" type="reset" id="cancelar-compra"><span class="fa fa-times"></span> Cancelar</button>
        <button type="button" name="btn-submit" id="final-compra" class="btn btn-primary">
            <span class="fa fa-save"></span> Registrar
        </button>    
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
        buscarproveedor();
        cargardetalle();
        buscartipo_pago();
    });

    function buscarproveedor() {
        $.ajax({
            data: {listar: 'buscarproveedor'},
            url: 'jsp/obtenerCompras.jsp',
            type: 'post',
            success: function (response) {
                $("#idproveedores").html(response);
            }
        });
    }

    function buscararticulo() {
        $.ajax({
            data: {listar: 'buscararticulo'},
            url: 'jsp/obtenerCompras.jsp',
            type: 'post',
            success: function (response) {
                $("#idarticulos").html(response);
            }
        });
    }

    function buscartipo_pago() {
        $.ajax({
            data: {listar: 'buscartipo_pago'},
            url: 'jsp/obtenerCompras.jsp',
            type: 'post',
            success: function (response) {
                $("#idtipo_pago").html(response);
            }
        });
    }

    function dividirarticulo(a) {
        let datos = a.split(',');
        $("#codarticulos").val(datos[0]);
        $("#art_precio_compra").val(datos[1]);
    }

    function dividirproveedor(a) {
        let datos = a.split(',');
        $("#codproveedores").val(datos[0]); // ID del proveedor
        $("#prov_ruc").val(datos[2]); // RUC del proveedor
    }

    function dividirtipo_pago(a) {
        datos = a.split(',');
        $("#codtipo_pago").val(datos[0]);
        $("#tipo_descripcion").val(datos[1]);
    }

    function validarSeleccionarCamposVacios(callback, esFinalizarCompra = false, esRegistrarCompra = false) {
        let valid = true;
        $(".error-msg").remove();

        // Validar el campo idarticulos solo si no es un registro
        if (!esRegistrarCompra && $("#idarticulos").val() === "") {
            valid = false;
            let errorMsg = $("<span class='error-msg' style='color:red;'>Este campo es obligatorio</span>").hide();
            $("#idarticulos").after(errorMsg);
            errorMsg.fadeIn().delay(500).fadeOut(function () {
                $(this).remove();
            });
        }

        // Validar el campo idproveedores solo si no es un registro
        if (!esRegistrarCompra && $("#idproveedores").val() === "") {
            valid = false;
            let errorMsg = $("<span class='error-msg' style='color:red;'>Este campo es obligatorio</span>").hide();
            $("#idproveedores").after(errorMsg);
            errorMsg.fadeIn().delay(500).fadeOut(function () {
                $(this).remove();
            });
        }

        // Si estamos finalizando la compra, validar el tipo de pago
        if (esFinalizarCompra) {
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
    $("#guardarcompra").click(function () {
        // Validar solo los campos de artículo y proveedor
        validarSeleccionarCamposVacios(function () {
            let datosform = $("#detalleFormCompra").serialize();
            $.ajax({
                data: datosform,
                url: 'jsp/compracrud.jsp',
                type: 'post',
                success: function (response) {
                    $("#respuesta").html(response);
                    cargardetalle();

                    // Limpiar campos después de agregar
                    $("#idarticulos").val(""); // Restablecer a la opción por defecto
                    $("#art_precio_compra").val("");
                    // $("#prov_ruc").val("");
                    //$("#idproveedores").val("");  Limpiar proveedor
                    $("#cantidad").val("1"); // Restablecer cantidad a 1

                    setTimeout(function () {
                        $("#respuesta").fadeOut();
                    }, 2000);
                },
                error: function (xhr, status, error) {
                    console.error("Error en la solicitud:", error);
                }
            });
        }, false); // Pasar false ya que no estamos finalizando la compra
    });

function cargardetalle() {
    $.ajax({
        data: {listar: 'listar'},
        url: 'jsp/compracrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === "" || response.trim() === "0") {
                // Si no hay detalles, mostrar mensaje
                $("#resultados").html('<tr><td colspan="5">No hay detalles disponibles para esta compra.</td></tr>');
                $("#lbltotal").text("0");
                $("#txtTotalCompra").val("0");
            } else {
                // Si hay detalles, procesar la respuesta
                $("#resultados").html(response);
                sumador(); // Llamar a la función para calcular el total
            }
        },
        error: function (xhr, status, error) {
            console.error("Error en cargardetalle:", error);
            $("#resultados").html('<tr><td colspan="5">Error al cargar los detalles.</td></tr>');
            $("#lbltotal").text("0");
            $("#txtTotalCompra").val("0");
        }
    });
}

function sumador() {
    $.ajax({
        data: {listar: 'listarsuma'},
        url: 'jsp/compracrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === "" || response.trim() === "0") {
                $("#lbltotal").html("0");
                $("#txtTotalCompra").val("0");
            } else {
                $("#lbltotal").html(response);
                $("#txtTotalCompra").val(response);
            }
        },
        error: function (xhr, status, error) {
            console.error("Error en sumador:", error);
            $("#lbltotal").html("0");
            $("#txtTotalCompra").val("0");
        }
    });
}

    $("#delcompra").click(function () {
        pkd = $("#pkdel").val();
        $.ajax({
            data: {listar: 'elimregcompra', pkd: pkd},
            url: 'jsp/compracrud.jsp',
            type: 'post',
            success: function (response) {
                cargardetalle();
                sumador();
            }
        });

    });

    $("#cancelar-compra").click(function () {
        $.ajax({
            data: {listar: 'cancelcompra'},
            url: 'jsp/compracrud.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'compras.jsp';
            }
        });
    });

    $("#final-compra").click(function () {
        let total = $("#txtTotalCompra").val();
        let codtipo_pago = $("#codtipo_pago").val(); // Obtener el valor de codtipo_pago
        validarSeleccionarCamposVacios(function () {
            $.ajax({
                data: {listar: 'finalcompra', total: total, codtipo_pago: codtipo_pago}, // Incluir codtipo_pago
                url: 'jsp/compracrud.jsp',
                type: 'post',
                success: function (response) {
                    cargardetalle();
                    location.href = 'compras.jsp'; // Redirigir a la página de compras
                }
            });
        }, true, true);
    });
</script>
<%@include file="footer.jsp" %>