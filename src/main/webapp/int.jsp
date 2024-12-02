<%@ include file="header.jsp" %>
<style>
    .container-fluid {
        margin-top: 20px;
    }
    .section-header {
        font-weight: bold;
        color: #333;
        background-color: #f8f9fa;
        padding: 10px;
        border: 1px solid #dee2e6;
        margin-bottom: 20px;
        border-radius: 5px;
    }
    .card {
        border: 1px solid #dee2e6;
        padding: 15px;
        margin-bottom: 20px;
        border-radius: 5px;
    }
    .card-header {
        font-weight: bold;
        color: #333;
        padding: 10px 0;
        border-bottom: 1px solid #dee2e6;
        margin-bottom: 15px;
    }
    .form-control[readonly] {
        background-color: #e9ecef;
    }
    .btn-register {
        background-color: #28a745;
        color: white;
    }
    .btn-cancel {
        background-color: #dc3545;
        color: white;
    }
</style>
</head>
<body>

<div class="container-fluid">
    <!-- Room Details -->
    <div class="section-header">
        <h5>Datos de la habitación</h5>
    </div>
    <div class="card">
        <div class="row">
            <div class="col-md-2"><strong>Nombre</strong><p>209</p></div>
            <div class="col-md-2"><strong>Tarifa</strong><p>24hr</p></div>
            <div class="col-md-2"><strong>Tipo</strong><p>DOBLE</p></div>
            <div class="col-md-3"><strong>Detalles</strong><p>HABITACIÓN DOBLE, BAÑO, TV, WIFI, MÁXIMO 4 PERSONAS</p></div>
            <div class="col-md-2"><strong>Precio</strong><p>MXN$ 360</p></div>
            <div class="col-md-1"><strong>Estado</strong><span class="badge badge-success">DISPONIBLE</span></div>
        </div>
    </div>

    <!-- Client Details -->
    <div class="section-header">
        <h5>Datos del Cliente</h5>
    </div>
    <div class="card">
        <div class="row">
            <div class="col-md-6">
                <label for="clientName">Nombre</label>
                <div class="input-group">
                    <select id="clientName" class="form-control">
                        <option selected>José Alcaraz</option>
                        <!-- Add more options as needed -->
                    </select>
                    <div class="input-group-append">
                        <button class="btn btn-outline-primary" type="button" data-toggle="modal" data-target="#addClientModal">
                            Agregar Cliente
                        </button>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <label for="docType">Tipo documento</label>
                <input type="text" id="docType" class="form-control" placeholder="DNI">
            </div>
            <div class="col-md-3">
                <label for="docNumber">Documento</label>
                <input type="text" id="docNumber" class="form-control" placeholder="12345678">
            </div>
            <div class="col-md-3">
                <label for="nit">NIT</label>
                <input type="text" id="nit" class="form-control">
            </div>
            <div class="col-md-3">
                <label for="billName">Nombre a facturar</label>
                <input type="text" id="billName" class="form-control">
            </div>
            <div class="col-md-3">
                <label for="email">Correo</label>
                <input type="email" id="email" class="form-control">
                <div class="form-check mt-1">
                    <input type="checkbox" class="form-check-input" id="sendAccountStatus">
                    <label class="form-check-label" for="sendAccountStatus">Enviar estado de cuenta por correo.</label>
                </div>
            </div>
            <div class="col-md-3">
                <label for="phone">Teléfono</label>
                <input type="text" id="phone" class="form-control" placeholder="731112222">
            </div>
        </div>
    </div>

    <!-- Accommodation Details -->
    <div class="section-header">
        <h5>Datos del Alojamiento</h5>
    </div>
    <div class="card">
        <div class="row">
            <div class="col-md-3">
                <label for="checkinDate">Fecha y hora entrada</label>
                <input type="datetime-local" id="checkinDate" class="form-control" value="2022-01-26T17:38">
            </div>
            <div class="col-md-3">
                <label for="checkoutDate">Fecha y hora salida</label>
                <input type="datetime-local" id="checkoutDate" class="form-control" value="2022-01-27T17:38">
            </div>
            <div class="col-md-2">
                <label for="discount">Descuento</label>
                <div class="input-group">
                    <input type="number" id="discount" class="form-control" value="0">
                    <select class="form-control">
                        <option>%</option>
                        <option>MXN</option>
                    </select>
                </div>
            </div>
            <div class="col-md-2">
                <label for="extraCharge">Cobro extra</label>
                <input type="number" id="extraCharge" class="form-control" value="0">
            </div>
            <div class="col-md-2">
                <label for="advance">Adelanto</label>
                <input type="number" id="advance" class="form-control" placeholder="MXN$">
            </div>
            <div class="col-md-2">
                <label for="totalPay">Total a pagar</label>
                <input type="text" id="totalPay" class="form-control" value="360" readonly>
            </div>
            <div class="col-md-12">
                <label for="observations">Observaciones</label>
                <textarea id="observations" class="form-control" placeholder="Escribir algún detalle que tenga el registro..."></textarea>
            </div>
        </div>
        <div class="d-flex justify-content-end mt-3">
            <button class="btn btn-cancel me-2">Regresar</button>
            <button class="btn btn-register">Agregar Registro</button>
        </div>
    </div>

    <!-- Modal for Adding New Client -->
    <div class="modal fade" id="addClientModal" tabindex="-1" role="dialog" aria-labelledby="addClientModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addClientModalLabel">Agregar Cliente</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="addClientForm">
                        <div class="form-group mb-3">
                            <label for="clientFirstName">Nombre</label>
                            <input type="text" id="clientFirstName" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="clientLastName">Apellido</label>
                            <input type="text" id="clientLastName" class="form-control">
                        </div>
                        <div class="form-group mb-3">
                            <label for="clientCI">Cédula de Identidad (CI)</label>
                            <input type="text" id="clientCI" class="form-control">
                        </div>
                        <div class="form-group mb-3">
                            <label for="clientPhone">Teléfono</label>
                            <input type="text" id="clientPhone" class="form-control">
                        </div>
                        <div class="form-group mb-3">
                            <label for="clientEmail">Correo</label>
                            <input type="email" id="clientEmail" class="form-control">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-primary" onclick="addClient()">Guardar Cliente</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End of Modal -->

</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function addClient() {
        // Implement your logic to add a client here
        alert('Cliente agregado'); // Placeholder for client addition logic
        $('#addClientModal').modal('hide'); // Close modal after adding client
    }
</script>
</body>
</html>
