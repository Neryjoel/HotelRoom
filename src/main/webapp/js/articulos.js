$(document).ready(function () {
    rellenarDatosArticulo();
    obtenerCategorias();
    $('#resultadoArticulo').DataTable({
        "paging": true,
        "searching": true,
        "info": false
    });
});

$('#guardarArticulo').on("click", function () {
    // Limpiar mensajes de error anteriores
    $(".errorArticulo").remove();

    // Obtener valores de los campos
    var nombre = $("#art_nombre").val().trim();
    var precioCompra = $("#art_precio_compra").val().trim();
    var precioVenta = $("#art_precio_venta").val().trim();
    var categoria = $("#categorias_idcategorias").val().trim();

    // Validar campos
    var error = false;
    if (nombre === "") {
        $("#art_nombre").after('<span class="errorArticulo text-danger">El nombre es obligatorio.</span>');
        error = true;
        setTimeout(function () {
            $(".errorArticulo").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    var precioRegex = /^\d+(\.\d{1,3})?$/; // Formato de número decimal con hasta 3 decimales
    if (!precioRegex.test(precioCompra)) {
        $("#art_precio_compra").after('<span class="errorArticulo text-danger">Ingrese un precio válido.</span>');
        error = true;
        setTimeout(function () {
            $(".errorArticulo").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    if (!precioRegex.test(precioVenta)) {
        $("#art_precio_venta").after('<span class="errorArticulo text-danger">Ingrese un precio válido.</span>');
        error = true;
        setTimeout(function () {
            $(".errorArticulo").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    if (categoria === "") {
        $("#categorias_idcategorias").after('<span class="errorArticulo text-danger">Seleccione una categoría.</span>');
        error = true;
        setTimeout(function () {
            $(".errorArticulo").fadeOut('slow', function () {
                $(this).remove();
            });
        }, 2000);
    }

    // Si hay errores, detener el proceso
    if (error) {
        return;
    }

    // Si no hay errores, enviar el formulario
    var datosform = $("#articuloForm").serialize();

    $.ajax({
        data: datosform,
        url: 'jsp/articulocrud.jsp',
        type: 'post',
        success: function (response) {
            if (response.trim() === 'articulo_existe') {
                $("#art_nombre").after('<span class="errorArticulo text-danger">El artículo ya existe.</span>');
                setTimeout(function () {
                    $(".errorArticulo").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
            } else {
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
        }
    });
});

$('#eliminarRegistroArticulo').on("click", function () {
    var listar = $("#listar_EliminarArticulo").val();
    var pk = $("#idarticulos_e").val();

    $.ajax({
        data: { listar: listar, idpk: pk },
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

function rellenarDatosArticulo() {
    $.ajax({
        data: { listar: 'listar' },
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

function rellenarEditarArticulo(id, nombre, precioCompra, precioVenta, categoria) {
    $("#idarticulos").val(id);
    $("#art_nombre").val(nombre);
    $("#art_precio_compra").val(precioCompra);
    $("#art_precio_venta").val(precioVenta);
    obtenerCategorias(categoria);
    $("#listar").val("modificar");
}

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
