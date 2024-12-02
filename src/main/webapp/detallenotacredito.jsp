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

<div class="container-fluid">
    <!-- Formulario principal -->
    <form id="detalleFormCompra" class="form-neon" autocomplete="off" onsubmit="return false">
        <!-- Cabecera -->
        <fieldset>
            <legend>Nota de crédito</legend>
            <div class="row">
                <!-- Columna izquierda -->
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="serie" class="bmd-label-floating">Serie:</label>
                        <input type="text" class="form-control" id="serie" name="serie" value="FN01" readonly="readonly">
                    </div>
                    
                     <!-- 
                    <div class="form-group">
                        <label for="numero" class="bmd-label-floating">Número:</label>
                        <input type="text" class="form-control" id="numero" name="numero" value="7" readonly="readonly">
                    </div>
                     -->

                    <div class="form-group">
                        <label for="fechacompra" class="bmd-label-floating">Fecha operación:</label>
                        <input type="text" class="form-control" id="fechacompra" name="fechacompra" value="<%= fechaFormateada%>" readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label for="motivo" class="bmd-label-floating">Motivo:</label>
                        <input type="text" class="form-control" id="motivo" name="motivo" value="ANULACIÓN DE LA OPERACIÓN">
                    </div>
                </div>

                <!-- Columna derecha -->
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="comprobante" class="bmd-label-floating">Buscar Comprobante:</label>
                        <input type="text" class="form-control" id="comprobante" name="comprobante" placeholder="Buscar comprobante">
                    </div>
                    <!-- 

                    <div class="form-group">
                        <label for="motivo" class="bmd-label-floating">Motivo</label>
                        <input type="text" class="form-control" id="motivo" name="motivo" placeholder="motivo..">
                    </div>
-->
                    <!-- 

                    <div class="form-group">
                        <label for="vendedor" class="bmd-label-floating">Vendedor:</label>
                        <input type="text" class="form-control" id="vendedor" name="vendedor" value="PRUEBA" readonly="readonly">
                    </div>
                    -->
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button id="guardarccompra" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
        <div id="respuesta"></div>
    </form>

    <!-- Detalle del Comprobante -->
    <div class="table-responsive mt-4">
        <legend>Detalle de la Nota de Crédito</legend>
        <table class="table table-dark table-sm" id="resultadodetalle">
            <thead>
                <tr>
                    <th>Acción</th>
                    <th>Artículo</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody id="resultados">
                <!-- Las filas de artículos se agregarán dinámicamente aquí -->
            </tbody>
        </table>
    </div>

    <!-- Totales -->
    <div class="row mt-3">
        <div class="col-md-6">
            <table class="table">
                <tr>
                    <td><strong>Subtotal:</strong></td>
                    <td><strong id="lblsubtotal">0.00</strong></td>
                </tr>
                <tr>
                    <td><strong>IGV:</strong></td>
                    <td><strong id="lbligv">0.00</strong></td>
                </tr>
                <tr>
                    <td><strong>Total:</strong></td>
                    <td><strong id="lbltotal">0.00</strong></td>
                </tr>
            </table>
        </div>
    </div>


    <!-- Total 

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
    -->

    <!-- Botones de acción -->
    <div class="d-flex justify-content-end">
        <button class="btn btn-danger" type="reset" id="cancelar-compra"><span class="fa fa-times"></span> Cancelar</button>
        <button type="button" id="final-compra" class="btn btn-primary ml-2"><span class="fa fa-save"></span> Registrar</button>
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


</div>

<%@ include file="footer.jsp" %>
