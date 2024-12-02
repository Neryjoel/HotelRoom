<%@include file="header.jsp" %>

<style>
    /* Container Styles */
    .room-cards-container {
        display: flex;
        flex-wrap: wrap; /* Permite que las tarjetas se distribuyan en múltiples filas */
        justify-content: flex-start; /* Alinea tarjetas al inicio del contenedor */
        padding: 10px; /* Padding general del contenedor */
        border-left: 1px solid transparent; /* Bordes */
        border-right: 1px solid transparent; /* Bordes */
        overflow-x: auto; /* Permite desplazamiento horizontal si es necesario */
    }

    /* Card Styles */
    .room-card {
        background-color: #f8f9fa;
        color: #333;
        border-radius: 8px;
        padding: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        position: relative;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        height: 110px;
        flex: 0 0 calc(16.66% - 20px); /* Por defecto, 6 cards, ajustando para márgenes */
        margin: 10px; /* Margen uniforme alrededor de las tarjetas */
    }

    .room-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
    }

    /* Icon Overlay */
    .room-card::before {
        content: "\f236"; /* FontAwesome bed icon */
        font-family: "Font Awesome 5 Free";
        font-weight: 900;
        font-size: 2em;
        color: rgba(0, 0, 0, 0.1);
        position: absolute;
        top: 8px;
        right: 8px;
    }

    /* Status Colors */
    .sencilla { background-color: #e0f7fa; }
    .doble { background-color: #e3f2fd; }
    .triple { background-color: #fff3e0; }
    .ocupada { background-color: #ffebee; }
    .limpieza { background-color: #e0f2f1; }

    /* Text Styles */
    .room-card h6 {
        font-size: 1.1em;
        font-weight: 700;
        margin-bottom: 2px;
    }

    .status-text {
        font-size: 0.8em;
        color: #555;
    }

    .status-icon {
        font-size: 1em;
        color: #888;
    }

    /* Button Styles */
    .btn-group {
        margin-bottom: 15px;
        margin-left: 23px; /* Mueve los botones a la derecha */
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

    /* Adjust Room Card Position */
    .room-cards-container {
        margin-top: -30px; /* Eleva las tarjetas de habitación */
    }

    /* Responsive Styles */
    @media (max-width: 1200px) {
        .room-card {
            flex: 0 0 calc(33.33% - 20px); /* 3 cards per row */
        }
    }

    @media (max-width: 768px) {
        .room-card {
            flex: 0 0 calc(50% - 20px); /* 2 cards per row */
        }
    }

    @media (max-width: 480px) {
        .room-card {
            flex: 0 0 calc(100% - 20px); /* 1 card per row */
        }
    }
</style>

<title>Vista General Recepción</title>

<!-- Navigation Buttons -->
<div class="btn-group mb-4" role="group" aria-label="Level Selector">
    <button type="button" class="btn" onclick="navigateLevel(this, 'all')">Todos</button>
    <button type="button" class="btn" onclick="navigateLevel(this, 'level1')">Primer Piso</button>
    <button type="button" class="btn" onclick="navigateLevel(this, 'level2')">Segundo Piso</button>
    <button type="button" class="btn" onclick="navigateLevel(this, 'level3')">Tercer Piso</button>
    <button type="button" class="btn" onclick="navigateLevel(this, 'level4')">Cuarto Piso</button>
</div>

<!-- JavaScript for Filtering Rooms by Floor -->
<script>
    function navigateLevel(button, level) {
        document.querySelectorAll('.btn-group .btn').forEach(btn => btn.classList.remove('active'));
        button.classList.add('active');

        const allCards = document.querySelectorAll('.room-card');
        allCards.forEach(card => {
            card.style.display = (level === 'all' || card.dataset.level === level) ? 'block' : 'none';
        });
    }
</script>

<!-- Room Cards -->
<div class="room-cards-container">
    <!-- First Floor Rooms -->
    <div class="room-card sencilla" data-level="level1">
        <h6>103</h6>
        <span>SENCILLA</span>
        <div class="status-text">Disponible <span class="status-icon"><i class="fas fa-check-circle"></i></span></div>
    </div>
    <div class="room-card doble limpieza" data-level="level1">
        <h6>110</h6>
        <span>DOBLE</span>
        <div class="status-text">Ocupada/Limpieza <span class="status-icon"><i class="fas fa-broom"></i></span></div>
    </div>
    <!-- Second Floor Rooms -->
    <div class="room-card ocupada" data-level="level2">
        <h6>215</h6>
        <span>SENCILLA</span>
        <div class="status-text">Ocupada <span class="status-icon"><i class="fas fa-exclamation-triangle"></i></span></div>
    </div>
    <div class="room-card doble" data-level="level2">
        <h6>214</h6>
        <span>PREPARACIÓN</span>
        <div class="status-text">Reservación <span class="status-icon"><i class="fas fa-calendar-alt"></i></span></div>
    </div>
    <!-- Third Floor Rooms -->
    <div class="room-card triple" data-level="level3">
        <h6>312</h6>
        <span>TRIPLE</span>
        <div class="status-text">Reservada <span class="status-icon"><i class="fas fa-lock"></i></span></div>
    </div>
    <!-- Fourth Floor Rooms -->
    <div class="room-card triple" data-level="level4">
        <h6>405</h6>
        <span>Cliente por llegar</span>
        <div class="status-text">Retraso <span class="status-icon"><i class="fas fa-hourglass-half"></i></span></div>
    </div>
    <!-- Nueva habitación -->
    <div class="room-card sencilla" data-level="level1">
        <h6>104</h6>
        <span>SENCILLA</span>
        <div class="status-text">Disponible <span class="status-icon"><i class="fas fa-check-circle"></i></span></div>
    </div>
</div>

<%@include file="footer.jsp" %>
