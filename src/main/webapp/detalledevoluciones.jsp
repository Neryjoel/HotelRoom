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
    <form id="detalleFormDevolucion" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <legend><i class="fas fa-reply"></i> &nbsp; DETALLE DEVOLUCIÓN</legend>
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12 col-md-2">
                        <div class="form-group">
                            <label for="fechadevolucion" class="bmd-label-floating">FECHA DE DEVOLUCIÓN</label>
                            <input type="text" class="form-control" id="fechadevolucion" name="fechadevolucion" maxlength="45" autocomplete="off" placeholder="Ingrese Fecha" value="<%= fechaFormateada%>" readonly="readonly">
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

                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="motivo" class="bmd-label-floating">MOTIVO</label>
                            <input class="form-control" type="text" name="motivo" id="motivo" autocomplete="off" placeholder="Motivo" required>
                        </div>
                    </div>              
                </div>
                <!--################## Articulos #################-->
                <div class="row">
                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="idarticulos" class="bmd-label-floating">ARTICULOS</label>
                            <input type="hidden" id="codarticulos" name="codarticulos" class="form-control" placeholder="Ingrese Artículo">
                            <select id="idarticulos" name="idarticulos" class="form-control" onchange="dividirarticulo(this.value)"></select>

                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="art_precio_compra" class="bmd-label-floating">PRECIO ARTICULO</label>
                            <input class="form-control" type="text" name="art_precio_compra" id="art_precio_compra" autocomplete="off" placeholder="precio" required onkeyup="puntitos(this, this.value.charAt(this.value.length - 1))" readonly="readonly">
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
            
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button id="guardardevolucion" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
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
            <div align="center">Compra</div>
        </th>
        <th>
            <div align="center">Cantidad</div>
        </th>
        <th>
            <div align="center">Motivo</div>
        </th>
        <th>
            <div align="center">Fecha</div>
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
        <button class="btn btn-danger" type="reset" onclick="#" id="cancelar-devolucion"><span class="fa fa-times"></span> Cancelar</button>
        <button type="button" name="btn-submit" id="final-devolucion" class="btn btn-primary" onclick="#"><span class="fa fa-save"></span> Registrar</button>
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
                Está seguro de querer eliminar el registro?
                <input type="hidden" name="pkdel" id="pkdel"/>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">NO</button>
                <button type="button" class="btn btn-primary" data-dismiss="modal" id="deldevolucion">SI</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        buscarproveedor();
        buscararticulo();
    });

    function buscarproveedor() {
        $.ajax({
            data: {listar: 'buscarproveedor'},
            url: 'jsp/obtenerDevoluciones.jsp',
            type: 'post',
            success: function (response) {
                $("#idproveedores").html(response);
            }
        });
    }

    function buscararticulo() {
        $.ajax({
            data: {listar: 'buscararticulo'},
            url: 'jsp/obtenerDevoluciones.jsp',
            type: 'post',
            success: function (response) {
                $("#idarticulos").html(response);
            }
        });
    }

    function dividirproveedor(a) {
        let datos = a.split(',');
        $("#codproveedores").val(datos[0]);
        $("#prov_ruc").val(datos[1]);
    }

    function dividirarticulo(a) {
        let datos = a.split(',');
        $("#codarticulos").val(datos[0]);
        $("#art_precio_compra").val(datos[1]);
    }

    function validarSeleccionarCamposVacios(callback) {
        let valid = true;
        $(".error-msg").remove();
        $("#idproveedores, #idarticulos, #motivo").each(function () {
            let errorMsg = $("<span class='error-msg' style='color:red;'>Este campo es obligatorio</span>").hide();
            if ($(this).val() === "") {
                valid = false;
                $(this).after(errorMsg);
                errorMsg.fadeIn().delay(2000).fadeOut(function () {
                    $(this).remove();
                });
            }
        });
        if (valid) {
            setTimeout(callback, 2000);
        }
    }

    $("#guardardevolucion").click(function () {
        validarSeleccionarCamposVacios(function () {
            let datosform = $("#detalleFormDevolucion").serialize();
            $.ajax({
                data: datosform,
                url: 'jsp/devolucioncrud.jsp',
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
            url: 'jsp/devolucioncrud.jsp',
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
            url: 'jsp/devolucioncrud.jsp',
            type: 'post',
            success: function (response) {
                $("#lbltotal").html(response);
                $("#txtTotalCompra").val(response);
            }
        });
    }

    $("#deldevolucion").click(function () {
        let pkd = $("#pkdel").val();
        $.ajax({
            data: {listar: 'elimregdevolucion', pkd: pkd},
            url: 'jsp/devolucioncrud.jsp',
            type: 'post',
            success: function (response) {
                cargardetalle();
            }
        });
    });

    $("#cancelar-devolucion").click(function () {
        $.ajax({
            data: {listar: 'canceldevolucion'},
            url: 'jsp/devolucioncrud.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'devoluciones.jsp';
            }
        });
    });

    $("#final-devolucion").click(function () {
        let total = $("#txtTotalCompra").val();
        validarSeleccionarCamposVacios(function () {
            $.ajax({
                data: {listar: 'finaldevolucion', total: total},
                url: 'jsp/devolucioncrud.jsp',
                type: 'post',
                success: function (response) {
                    location.href = 'devoluciones.jsp';
                }
            });
        });
    });

</script>
<%@ include file="footer.jsp" %>
