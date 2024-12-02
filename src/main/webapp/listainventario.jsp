<%@ include file="header.jsp" %>
<div class="container-fluid" style="padding:  5px; ">
<legend><i class="fas fa-box"></i> &nbsp;LISTA DE INVENTARIO</legend>
</div>
<!-- Contenido -->
<div class="table-responsive" style="text-align: center; padding:  5px; ">
    
    <table id="stockTable" class="table table-dark table-sm">
        <thead>
            <tr>
                <th>#</th>
                <th>Artículo</th>
                <th>Cantidad</th>
                <th>OPCIÓN</th>
            </tr>
        </thead>
        <tbody id="resultadoStock">
            <!-- Rows will be populated by JavaScript -->
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>


    // Llamar a la función al cargar la página o después de cargar los datos
    $(document).ready(function () {
        llenadocompras(); // Cargar los datos y luego configurar los botones
    });

    function llenadocompras() {
        $.ajax({
            data: { listar: 'listar' },
            url: 'jsp/listainventariocrud.jsp',
            type: 'post',
            success: function (response) {
                var table = $('#stockTable').DataTable();
                table.clear().destroy();
                $("#resultadoStock").html(response);
                $('#stockTable').DataTable();
            }
        });
    }

</script>

<%@ include file="footer.jsp" %>