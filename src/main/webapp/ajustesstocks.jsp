<%@ include file="header.jsp" %>

<!-- Formulario para editar stock -->
<div class="container-fluid">
    <form id="stockEditForm" class="form-neon" autocomplete="off" onsubmit="return false">
        <fieldset>
            <legend><i class="fas fa-box"></i> &nbsp; AJUSTE INVENTARIO</legend>
            <div class="container-fluid">
                <div class="row">
                    <!-- Campo para mostrar el nombre del artículo (deshabilitado) -->
                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="art_nombre" class="bmd-label-floating">Nombre del Artículo</label>
                            <input type="text" class="form-control" id="art_nombre" name="art_nombre" disabled>
                        </div>
                    </div>

                    <!-- Campo para la cantidad actual (deshabilitado) -->
                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="cantidad_actual" class="bmd-label-floating">Cantidad Actual</label>
                            <input type="number" class="form-control" id="cantidad_actual" name="cantidad_actual" disabled>
                        </div>
                    </div>


                    <!-- Campo para ingresar la nueva cantidad -->
                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="nueva_cantidad" class="bmd-label-floating">Nueva Cantidad</label>
                            <input type="number" class="form-control" id="nueva_cantidad" name="nueva_cantidad">
                        </div>
                        <div id="errorNuevaCantidad" class="alert alert-danger d-none" role="alert">
                            Ingrese ajuste
                        </div>
                    </div>
                    <!-- Campo para mostrar el nombre del artículo (deshabilitado) -->
                    <!-- Campo para ingresar el motivo del ajuste -->
                    <div class="col-12 col-md-4">
                        <div class="form-group">
                            <label for="aju_motivo" class="bmd-label-floating">Motivo del Ajuste</label>
                            <input type="text" class="form-control" id="aju_motivo" name="aju_motivo">
                        </div>
                    </div>
                    <!-- Input oculto para el id del stock -->
                    <input type="hidden" class="form-control" id="idajustesstocks" name="idajustesstocks">
                </div>
            </div>
        </fieldset>
        <p class="text-center" style="margin-top: 40px;">
            <button id="guardarStock" type="button" class="btn btn-raised btn-info btn-sm"><i class="far fa-save"></i> &nbsp; ACTUALIZAR CANTIDAD</button>
        </p>
    </form>
    <div id="mensajeStock" class="alert fade-out"></div>
</div>

<!-- Contenido -->
<div class="table-responsive" style="text-align: center; padding:  5px; ">
    <table id="stockTable" class="table table-dark table-sm">
        <thead>
            <tr>
                <th>#</th>
                <th>Artículo</th>
                <th>Cantidad</th>
                <th>Motivo</th>
                <th>OPCION</th>
            </tr>
        </thead>
        <tbody id="resultadoStock">
            <!-- Rows will be populated by JavaScript -->
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
        // Función para rellenar el formulario de edición con los datos de stock
        function rellenarEditarStock(idajustesstocks, articuloNombre, cantidadActual, aju_motivo) {
            $("#idajustesstocks").val(idajustesstocks);
            $("#art_nombre").val(articuloNombre);
            $("#cantidad_actual").val(cantidadActual);
            $("#aju_motivo").val(aju_motivo); // Nuevo campo para motivo
        }


        // Asignar evento al botón de editar
        function setupEditButtons() {
            $('.btn-edit').on('click', function () {
                var idajustesstocks = $(this).data('idajustesstocks');
                var articuloNombre = $(this).data('articulonombre');
                var cantidadActual = $(this).data('cantidadactual');
                var aju_motivo = $(this).data('aju_motivo');  // Obtener el motivo

                rellenarEditarStock(idajustesstocks, articuloNombre, cantidadActual, aju_motivo);
            });
        }

        // Llamar a la función al cargar la página o después de cargar los datos
        $(document).ready(function () {
            llenadocompras(); // Cargar los datos y luego configurar los botones
        });

        function llenadocompras() {
            $.ajax({
                data: {listar: 'listar'},
                url: 'jsp/ajustesstockscrud.jsp',
                type: 'post',
                success: function (response) {
                    var table = $('#stockTable').DataTable();
                    table.clear().destroy();
                    $("#resultadoStock").html(response);
                    $('#stockTable').DataTable();
                    setupEditButtons(); // Configurar botones de editar después de cargar los datos
                }
            });
        }

        $("#guardarStock").on("click", function () {
            var idajustesstocks = $("#idajustesstocks").val();
            var nuevaCantidad = $("#nueva_cantidad").val();
            var aju_motivo = $("#aju_motivo").val(); // Obtener motivo del ajuste

            // Validaciones (incluyendo la nueva cantidad)
            if (!nuevaCantidad || nuevaCantidad <= 0) {
                $("#nueva_cantidad").after('<span id="errorNuevaCantidad" class="text-danger">Ingrese ajuste.</span>');
                setTimeout(function () {
                    $("#errorNuevaCantidad").fadeOut('slow', function () {
                        $(this).remove();
                    });
                }, 2000);
                return;
            }

            $.ajax({
                type: 'POST',
                url: 'jsp/ajustesstockscrud.jsp',
                data: {
                    modificar: 'modificar',
                    idajustesstocks: idajustesstocks,
                    nueva_cantidad: nuevaCantidad,
                    aju_motivo: aju_motivo // Incluir motivo en la petici�n AJAX
                },
                success: function (response) {
                    $("#mensajeStock").html(response).removeClass('d-none').hide().fadeIn("slow");
                    $("#idajustesstocks").val('');
                    $("#art_nombre").val('');
                    $("#cantidad_actual").val('');
                    $("#nueva_cantidad").val('');
                    $("#aju_motivo").val(''); // Limpiar motivo
                    setTimeout(function () {
                        $("#mensajeStock").fadeOut("slow");
                    }, 2000);
                    llenadocompras(); // Recargar tabla
                }
            });
        });
</script>

<%@ include file="footer.jsp" %>