<%@ include file="header.jsp" %>
<div class="container-fluid" style="padding:  5px; ">
    <legend><i class="fas fa-box"></i> &nbsp;INVENTARIO</legend>
</div>

<!-- Contenido -->
<div class="table-responsive" style="text-align: center; padding: 5px;">
    <table id="inventarioTable" class="table table-dark table-sm">
        <thead>
            <tr>
                <th>#</th>
                <th>Fecha</th>
                <th>Tipo Movimiento</th>
                <th>Articulo</th>
                <th>Cantidad</th>
                <th>Precio Unidad</th>
                <th>Usuario</th>
            </tr>
        </thead>
        <tbody id="resultadoTable">
            <!-- Rows will be populated by JavaScript -->
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function () {
        llenadoInventario(); // Cargar los datos y luego configurar los botones
    });

    function llenadoInventario() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'jsp/inventariocrud.jsp',
            type: 'post',
            success: function (response) {
                //console.log(response); // Verifica qué datos estás recibiendo
                var table = $('#inventarioTable').DataTable();
                table.clear().destroy(); // Limpia y destruye la tabla anterior
                $("#resultadoTable").html(response); // Actualiza el contenido del tbody
                $('#inventarioTable').DataTable(); // Re-inicializa la tabla
            }
        });
    }
</script>

<%@ include file="footer.jsp" %>