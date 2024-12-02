<%@ include file="header.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

   
<div class="container-fluid">
    <fieldset style="display: flex; justify-content: space-between; align-items: center; margin-top: 10px;">
        <legend style="margin-left: -1px;">
            <i class="fas fa-sign-out-alt fa-fw"></i> &nbsp; Vista General Salida
        </legend>
    </fieldset>
    <style>
        /* Container Styles */
        .room-cards-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            padding: 10px;
            border-left: 1px solid transparent;
            border-right: 1px solid transparent;
            overflow-x: auto;
            position: relative;
            margin-left: -27px;
            margin-top: -60px;
            margin-right: -27px;
        }

        /* Card Styles */
        .room-card {
            color: #333;
            border-radius: 8px;
            padding: 10px 10px 35px 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            position: relative;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            height: 110px;
            flex: 0 0 calc(16.66% - 20px);
            margin: 10px;
            display: flex;
            flex-direction: column;
        }

        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }

        /* Icon Overlay */
        .room-card::before {
            content: "\f236";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            font-size: 2em;
            color: rgba(0, 0, 0, 0.1);
            position: absolute;
            top:-6px;
            right: 8px;
        }

        /* Room Card Status Colors */
        .room-card.Ocupada {
            background-color: #ffcccc;
        }

        /* Text Styles */
        .room-card h6 {
            font-size: 1.1em;
            font-weight: 700;
            margin-bottom: 2px;
        }

        .description-text {
            font-size: 0.8em;
            color: #555;
            margin-bottom: 5px;
            flex-grow: 1;
        }

        /* Button Styles */
        .status-btn {
            width: 100%;
            border: none;
            padding: 8px;
            font-weight: bold;
            background-color: transparent;
            color: rgba(0, 0, 0, 0.8) !important;
            transition: opacity 0.3s;
            cursor: pointer;
            position: absolute;
            bottom: 0;
            left: 0;
            margin: 0;
            border-radius: 0 0 8px 8px;
            height: 35px;
            font-size: 0.9em;
        }

        .status-btn:not(.disabled):hover {
            opacity: 0.8;
        }

        /* Estados específicos para los botones */
        .room-card.Ocupada .status-btn {
            color: rgba(0, 0, 0, 0.8) !important;
        }

        /* Button Group Styles */
        .btn-group {
            margin: 0;
            padding: 5px 5px 0;
            margin-left: -8px;
        }

        .btn-group .btn {
            font-weight: bold;
            color: #333;
            background-color: #f7f7f7;
            border: none;
            border-radius: 0.25rem;
            padding: 0.3rem 1rem;
            transition: background-color 0.2s ease, color 0.2s ease;
            cursor: pointer;
        }

        .btn-group .btn.active {
            background-color: #007bff;
            color: #fff;
            border-bottom: 2px solid #007bff;
        }

        .btn-group .btn:hover {
            background-color: #f2f2f2;
            color: #333;
        }

        /* Loading Indicator Styles */
        .loading-indicator {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .loading-indicator img {
            width: 50px;
            height: 50px;
        }

        /* Responsive Styles */
        @media (max-width: 1200px) {
            .room-card {
                flex: 0 0 calc(33.33% - 20px);
            }
        }

        @media (max-width: 768px) {
            .room-card {
                flex: 0 0 calc(50% - 20px);
            }
        }

        @media (max-width: 480px) {
            .room-card {
                flex: 0 0 calc(100% - 20px);
            }
        }
    </style>

    <style>
        .modal-content {
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background-color: #f8f9fa;
            border-radius: 8px 8px 0 0;
        }

        .modal-footer {
            background-color: #f8f9fa;
            border-radius: 0 0 8px 8px;
        }

    </style>

    <title>Vista General Recepción</title>

    <!-- Loading Indicator -->
    <div class="loading-indicator" id="loadingIndicator">
        <img src="assets/img/loading.gif" alt="Cargando...">
        <p>Cargando habitaciones, por favor espere...</p>
    </div>

    <!-- Navigation Buttons -->
    <div class="btn-group mb-4" role="group" aria-label="Level Selector" id="botonesPisos">
        <button type="button" class="btn" onclick="navigateLevel(this, 'all')">Todos</button>
        <!-- Dynamic buttons for each floor will be added here -->
    </div>

    <!-- Room Cards Container -->
    <div class="room-cards-container" id="roomCardsContainer">
        <!-- Room cards will be dynamically added here based on database records -->
    </div>
</div>

<!-- JavaScript for Filtering Rooms by Floor -->
<script>
    $(document).ready(function () {
        actualizarBotonesPisos(); // Load the buttons on initialization
    });

    function navigateLevel(button, level) {
        document.querySelectorAll('.btn-group .btn').forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');

        const allCards = document.querySelectorAll('.room-card');
        allCards.forEach(card => {
            card.style.display = (level === 'all' || card.dataset.level === level) ? 'block' : 'none';
        });
    }

    function actualizarBotonesPisos() {
        $("#loadingIndicator").show(); // Show the loading indicator

        $.ajax({
            data: {listar: 'listar'}, // Call to get the list of floors
            url: 'jsp/pisocrud.jsp',
            type: 'post',
            success: function (response) {
                $("#botonesPisos").html(response); // Update the button group with new buttons
                $("#loadingIndicator").hide(); // Hide the loading indicator
            },
            error: function () {
                $("#loadingIndicator").hide(); // Hide loading indicator on error
                alert("Error al cargar los pisos. Intente nuevamente.");
            }
        });
    }
</script>

<script>
    $(document).ready(function () {
        cargarHabitacionesCobros(); // Load occupied room cards on initialization
    });

    function cargarHabitacionesCobros() {
        $("#loadingIndicator").show(); // Show loading indicator

        $.ajax({
            data: {listar: 'listarHabitacionesCobros'}, // Call to get the list of occupied rooms
            url: 'jsp/habitacioncrud.jsp',
            type: 'post',
            success: function (response) {
                $("#roomCardsContainer").html(response); // Update room cards container
                $("#loadingIndicator").hide(); // Hide loading indicator
            },
            error: function () {
                $("#loadingIndicator").hide(); // Hide loading indicator on error
                alert("Error al cargar las habitaciones ocupadas. Intente nuevamente.");
            }
        });
    }
</script>
<script>
function setRoomDataAndRedirect(roomId, roomName, roomDescription, roomPrice, guestFullName, guestCI, guestPhone, guestEmail, checkInDate, checkOutDate, reservationId, deposit) {
    const form = document.createElement('form');
    form.method = 'post';
    form.action = 'cobroprueba.jsp';

    const inputs = [
        {name: 'roomId', value: roomId},
        {name: 'roomName', value: roomName},
        {name: 'roomDescription', value: roomDescription},
        {name: 'roomPrice', value: roomPrice},
        {name: 'guestFullName', value: guestFullName},
        {name: 'guestCI', value: guestCI},
        {name: 'guestPhone', value: guestPhone},
        {name: 'guestEmail', value: guestEmail},
        {name: 'checkInDate', value: checkInDate},
        {name: 'checkOutDate', value: checkOutDate},
        {name: 'reservationId', value: reservationId}, // Ensure this is the correct value
        {name: 'deposit', value: deposit} // Ensure this is the correct value
    ];

    inputs.forEach(input => {
        const hiddenInput = document.createElement('input');
        hiddenInput.type = 'hidden';
        hiddenInput.name = input.name;
        hiddenInput.value = input.value;
        form.appendChild(hiddenInput);
    });

    document.body.appendChild(form);
    form.submit();
}
</script>
<%@ include file="footer.jsp" %>
