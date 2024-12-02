<%@include file="header.jsp" %>

<!-- Content here-->
<br>
<div class="container-fluid">
    <form id="articuloForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center">
                    <legend><i class="fas fa-box"></i> &nbsp; ARTÍCULO</legend>
                    <a href="reporteVistaGeneral/reporteArticuloGeneral.jsp" class="btn btn-raised btn-dark btn-sm mt-2 d-flex align-items-center">
                        <i class="fas fa-file-alt mr-2"></i> Reporte
                    </a>
                </div>
                <div class="row">
                    <div class="col-12 col-md-7">
                        <div class="form-group">
                            <label for="art_nombre" class="bmd-label-floating">Nombre</label>
                            <input type="text" class="form-control" id="art_nombre" name="art_nombre" maxlength="100">
                        </div>
                    </div>

                    <div class="col-12 col-md-3">
                        <div class="form-group">
                            <label for="art_tipo" class="bmd-label-floating">Tipo</label>
                            <select class="form-control" id="art_tipo" name="art_tipo">
                                <option value="">Seleccione Tipo</option>
                                <option >Articulo</option>
                                <option>Servicio</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-12 col-md-2">
                        <div class="form-group">
                            <label for="art_iva" class="bmd-label-floating">IVA</label>
                            <select class="form-control" id="art_iva" name="art_iva">
                                <option value="">Seleccione IVA</option>
                                <option value="0">0</option>
                                <option value="5">5%</option>
                                <option value="10">10%</option>
                            </select>
                        </div>
                    </div>

                    <div class="col-12 col-md-3">
                        <div class="form-group">
                            <label for="art_precio_venta" class="bmd-label-floating">Precio de Venta</label>
                            <input type="number" class="form-control" id="art_precio_venta" name="art_precio_venta" maxlength="10">
                        </div>
                    </div>
                    <div class="col-12 col-md-3" id="div_precio_compra">
                        <div class="form-group">
                            <label for="art_precio_compra" class="bmd-label-floating">Precio de Compra</label>
                            <input type="number" class="form-control" id="art_precio_compra" name="art_precio_compra" maxlength="10">
                        </div>
                    </div>
                    
                    <div class="col-12 col-md-2" id="div_stock_min">
                        <div class="form-group">
                            <label for="stock_min" class="bmd-label-floating">Stock Mínimo</label>
                            <input type="number" class="form-control" id="stock_min" name="stock_min" min="0">
                        </div>
                    </div>
                    <div class="col-12 col-md-4" id="div_categorias_idcategorias">
                        <div class="form-group">
                            <label for="categorias_idcategorias" class="bmd-label-floating">Categoría</label>
                            <select class="form-control" id="categorias_idcategorias" name="categorias_idcategorias">
                                <option value="">Seleccione Categoría</option>
                                <!-- Opciones de categoría -->
                            </select>
                        </div>
                    </div>

                    <input type="hidden" class="form-control" name="listar" id="listar" value="cargar">
                    <input type="hidden" class="form-control" name="idarticulos" id="idarticulos">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button type="reset" class="btn btn-raised btn-secondary btn-sm"><i class="fas fa-paint-roller"></i> &nbsp; LIMPIAR</button>
            &nbsp; &nbsp;
            <button id="guardarArticulo" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; GUARDAR</button>
        </p>
    </form>
    <div id="mensajeArticulo"></div>
</div>

<!-- Content here-->
<div class="table-responsive tablas">
    <table class="table table-dark table-sm mx-auto" id="resultadoArticulo">
        <thead>
            <tr>
                <th>#</th>
                <th>NOMBRE</th>
                <th>PRECIO COMPRA</th>
                <th>PRECIO VENTA</th>
                <th>STOCK MIN</th>
                <th>IVA</th>
                <th>TIPO</th>
                <th>CATEGORÍA</th>
                <th>OPCIÓN</th>
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>
</div>

<!-- Modal para eliminar datos -->
<div class="modal fade" id="eliminarArticuloModal" tabindex="-1" role="dialog" aria-labelledby="eliminarArticuloModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarArticuloModalLabel">Eliminar artículo</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" class="form-control" name="listar_EliminarArticulo" id="listar_EliminarArticulo" value="eliminar">
                <input type="hidden" class="form-control" name="idarticulos_e" id="idarticulos_e">
                <p>¿Estás seguro/a que quieres eliminar este artículo?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
                <button type="button" class="btn btn-primary" id="eliminarRegistroArticulo" data-dismiss="modal">Sí</button>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>

<script>
    $(document).ready(function () {
        // Inicializar DataTable y otras funciones
        rellenarDatosArticulo();
        obtenerCategorias();


        // Manejar el cambio de tipo
        $('#art_tipo').change(function () {
            if ($(this).val() === 'Servicio') {
                $('#div_precio_compra').hide();
                $('#art_precio_compra').val(''); // Limpiar el campo
                $('#div_stock_min').hide();
                $('#stock_min').val(''); // Limpiar el campo
                $('#div_categorias_idcategorias').hide();
                $('#categorias_idcategorias').val(''); // Limpiar el campo
            } else {
                $('#div_precio_compra').show();
                $('#div_stock_min').show();
                $('#div_categorias_idcategorias').show();
            }
        });
    });

$('#guardarArticulo').on("click", function () {
    $(".text-danger").remove();

    var nombre = $("#art_nombre").val().trim();
    var tipo = $("#art_tipo").val();
    var precioVenta = $("#art_precio_venta").val().trim();
    var precioCompra = $("#art_precio_compra").val().trim();
    var iva = $("#art_iva").val();
    var stockMin = $("#stock_min").val().trim();
    var categoria = $("#categorias_idcategorias").val();

    var errores = false;
    var regexNombre = /^[A-ZÁÉÍÓÚÜÑ][a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]*( [a-zA-Z0-9áéíóúüñÁÉÍÓÚÜÑ]+)*$/;

    // Validar el nombre
    if (!regexNombre.test(nombre)) {
        $("#art_nombre").after('<span id="errorDescripcionArticulo" class="text-danger">El nombre debe comenzar con mayúscula y no tener caracteres especiales.</span>');
        errores = true;
    }

    // Validar el tipo
    if (tipo === '') {
        $("#art_tipo").after('<span class="text-danger">Seleccione un tipo.</span>');
        errores = true;
    }

    // Validar precio de venta
    if (precioVenta === '' || isNaN(precioVenta) || parseFloat(precioVenta) <= 0) {
        $("#art_precio_venta").after('<span class="text-danger">Ingrese un precio de venta válido.</span>');
        errores = true;
    }

    // Validaciones adicionales solo si se selecciona tipo "Articulo"
    if (tipo === 'Articulo') {
        if (precioCompra === '' || isNaN(precioCompra) || parseFloat(precioCompra) <= 0) {
            $("#art_precio_compra").after('<span class="text-danger">Ingrese un precio de compra válido.</span>');
            errores = true;
        }

        if (stockMin === '' || isNaN(stockMin) || parseInt(stockMin) < 0) {
            $("#stock_min").after('<span class="text-danger">Ingrese un stock mínimo válido.</span>');
            errores = true;
        }

        if (categoria === '') {
            $("#categorias_idcategorias").after('<span class="text-danger">Seleccione una categoría.</span>');
            errores = true;
        }
    }

    if (iva === '') {
        $("#art_iva").after('<span class="text-danger">Seleccione un IVA.</span>');
        errores = true;
    }

    if (errores) {
        setTimeout(function () {
            $(".text-danger").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
        return;
    }

    var datosform = $("#articuloForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/articulocrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'articulo_existe') {
                $("#art_nombre").after('<span class="text-danger">El artículo ya existe.</span>');
                setTimeout(function () {
                    $(".text-danger").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
                $("#mensajeArticulo").html(response);
                rellenarDatosArticulo();
                setTimeout(function () {
                    $("#mensajeArticulo").html("");
                    $("#art_nombre, #art_precio_compra, #art_precio_venta, #stock_min, #art_iva, #art_tipo, #categorias_idcategorias").val("");
                }, 2000);
            }
        }
    });
});


// Eliminar registro de artículo o servicio
    $('#eliminarRegistroArticulo').on("click", function () {
    var listar = $("#listar_EliminarArticulo").val();
    var pk = $("#idarticulos_e").val();

    $.ajax({
        data: {listar: listar, idpk: pk},
        url: 'jsp/articulocrud.jsp',
        type: 'post',
        success: function (response) {
            $("#mensajeArticulo").html(response);
            rellenarDatosArticulo();

            setTimeout(function () {
                $("#mensajeArticulo").html("");
                $("#art_nombre, #art_precio_compra, #art_precio_venta").val("");
                $("#art_nombre").focus();
                $("#categorias_idcategorias").val(""); // Limpiar selección de categoría
                $("#listar").val("cargar");
            }, 2000);
        }
    });
});

// Función para rellenar los datos de artículos y servicios
    function rellenarDatosArticulo() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/articulocrud.jsp',
            type: 'post',
            success: function (response) {
                var table = $('#resultadoArticulo').DataTable();
                table.clear().destroy(); // Clear and destroy the DataTable
                $("#resultadoArticulo tbody").html(response);
                $('#resultadoArticulo').DataTable(); // Reinitialize DataTable
            }
        });
    }

function rellenarEditarArticulo(id, nombre, precioCompra, precioVenta, stockMin, iva, tipo, categoria) {
    $("#idarticulos").val(id);
    $("#art_nombre").val(nombre);
    $("#art_precio_compra").val(precioCompra);
    $("#art_precio_venta").val(precioVenta);
    $("#art_iva").val(iva);
    $("#stock_min").val(stockMin); // Esto debería estar vacío para servicios
    $("#art_tipo").val(tipo);
    obtenerCategorias(categoria);

    // Manejar la visualización de campos según el tipo seleccionado
    if (tipo === 'Servicio') {
        $('#div_precio_compra').hide();
        $('#art_precio_compra').val(''); // Limpiar el campo
        $('#div_stock_min').hide();
        $('#stock_min').val(''); // Limpiar el campo
        $('#div_categorias_idcategorias').hide();
        $('#categorias_idcategorias').val(''); // Limpiar el campo
    } else {
        $('#div_precio_compra').show();
        $('#div_stock_min').show();
        $('#div_categorias_idcategorias').show();
    }
    $("#listar").val("modificar");
}


// Función para obtener categorías
    function obtenerCategorias(selectedCategory = "") {
        $.ajax({
            url: 'jsp/obtenerCategorias.jsp',
            type: 'post',
            success: function (response) {
                $("#categorias_idcategorias").html('<option value="">Seleccione Categoría</option>' + response);
                if (selectedCategory) {
                    $("#categorias_idcategorias option").filter(function () {
                        return $(this).text() === selectedCategory;
                    }).prop('selected', true);
                }
            }
        });
    }
</script>