<%
    HttpSession sesion = request.getSession();
    if (sesion.getAttribute("logueado") == null || sesion.getAttribute("logueado").equals("0")) {
%>
<script>location.href = "index.jsp";</script>	
<% } %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <title>Home</title>

        <!-- Normalize V8.0.1 -->
        <link rel="stylesheet" href="css/normalize.css">

        <!-- Bootstrap V4.3 -->
        <link rel="stylesheet" href="css/bootstrap.min.css">

        <!-- Bootstrap Material Design V4.0 -->
        <link rel="stylesheet" href="css/bootstrap-material-design.min.css">

        <!-- Font Awesome V5.9.0 -->
        <link rel="stylesheet" href="css/all.css">

        <!-- Sweet Alerts V8.13.0 CSS file -->
        <link rel="stylesheet" href="css/sweetalert2.min.css">

        <!-- Sweet Alert V8.13.0 JS file-->
        <script src="js/sweetalert2.min.js" ></script>

        <!-- jQuery Custom Content Scroller V3.1.5 -->
        <link rel="stylesheet" href="css/jquery.mCustomScrollbar.css">

        <!-- General Styles -->
        <link rel="stylesheet" href="css/style.css">
        <!-- CSS de DataTables -->

        <!-- CSS de DataTables -->
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/jquery.dataTables.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css">

        <style>
            /* Ajusta el color de fondo y el color del texto de los números de paginación */
            .dataTables_wrapper .dataTables_paginate .paginate_button {
                background: #ffffff; /* Color de fondo deseado */
                color: #000000; /* Color de texto deseado */
            }

            .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
                background: #e9ecef; /* Color de fondo al pasar el ratón */
                color: #000000; /* Color de texto al pasar el ratón */
            }

            .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                background: #007bff; /* Color de fondo para el botón de página actual */
                color: #ffffff; /* Color de texto para el botón de página actual */
            }

            .tablas{
                text-align: center;
                padding:  5px;
            }
        </style>

    </head>
    <body>

        <!-- Main container -->
        <main class="full-box main-container">
            <!-- Nav lateral -->
            <section class="full-box nav-lateral">
                <div class="full-box nav-lateral-bg show-nav-lateral"></div>
                <div class="full-box nav-lateral-content">
                    <figure class="full-box nav-lateral-avatar">
                        <i class="far fa-times-circle show-nav-lateral"></i>
                        <img src="assets/avatar/Avatar.png" class="img-fluid" alt="Avatar">
                        <figcaption class="roboto-medium text-center">
                            <% out.print(sesion.getAttribute("personal_nombre")); %> <% out.print(sesion.getAttribute("personal_apellido")); %> <br><small class="roboto-condensed-light"><% out.print(sesion.getAttribute("rol")); %></small>
                        </figcaption>
                    </figure>
                    <div class="full-box nav-lateral-bar"></div>
                    <nav class="full-box nav-lateral-menu">
                        <ul>
                            <li>
                                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt fa-fw"></i> &nbsp; Dashboard</a>
                            </li>
                            <% if (sesion.getAttribute("rol") != null && sesion.getAttribute("rol").equals("Administrador")) { %>
                            <li>
                                <a href="#" class="nav-btn-submenu"><i class="fas fa-tools"></i> &nbsp; Mantenimiento <i class="fas fa-chevron-down"></i></a>
                                <ul>
                                    <li>
                                        <a href="ciudades.jsp"><i class="fas fa-city"></i> &nbsp; Ciudades</a>
                                    </li>
                                    <li>
                                        <a href="roles.jsp"><i class="fas fa-user-tag"></i> &nbsp; Roles</a>
                                    </li>
                                    <li>
                                        <a href="#" class="nav-btn-submenu"><i class="fas fa-box"></i> &nbsp; Artículos <i class="fas fa-chevron-down"></i></a>
                                        <ul>
                                            <li><a href="categorias.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Categorías</a></li>
                                            <li><a href="articulos.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Artículos</a></li>
                                        </ul>
                                    </li>
                                    <li>
                                        <a href="personales.jsp"><i class="fas fa-user-tie"></i> &nbsp; Personales</a>
                                    </li>
                                    <li>
                                        <a href="usuarios.jsp"><i class="fas fa-user"></i> &nbsp; Usuarios</a>
                                    </li>
                                    <li>
                                        <a href="huespedes.jsp"><i class="fas fa-users fa-fw"></i> &nbsp; Huespedes</a>
                                    </li>
                                    <li>
                                        <a href="habitaciones.jsp"><i class="fas fa-bed"></i> &nbsp; Habitaciones</a>
                                    </li>
                                    <li>
                                        <a href="pisos.jsp"><i class="fas fa-cogs"></i> &nbsp; Pisos</a>
                                    </li>
                                    <li>
                                        <a href="metodo_pago.jsp"><i class="fas fa-money-bill"></i> &nbsp; Metodo Pago</a>
                                    </li>
                                    <li>
                                        <a href="proveedores.jsp"><i class="fas fa-people-carry"></i> &nbsp; Proveedores</a>
                                    </li>
                                </ul>
                            </li>
                            <% }%>
                            <li>
                                <a href="#" class="nav-btn-submenu">
                                    <i class="fas fa-cash-register"></i> &nbsp; Caja <i class="fas fa-chevron-down"></i>
                                </a>
                                <ul>
                                    <li><a href="cajas.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Administrar Caja</a></li>
                                    <li><a href="listaGastos-Ingresos.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; lista Gastos-Ingresos</a></li>
                                </ul>
                            </li>
                            <li>
                                <a href="recepcion.jsp"><i class="fas fa-concierge-bell fa-fw"></i> &nbsp; Recepción</a>
                            </li>
                            <li>
                                <a href="reservaprueba.jsp"><i class="fas fa-calendar-alt"></i> &nbsp; Reservas</a>
                            </li>
                            <!-- 
                            <li>
                                <a href="ventaprueba.jsp"><i class="fas fa-calendar-alt"></i> &nbsp; Venta Prueba</a>
                            </li>
                            
                            
                            <li>
                                <a href="cobroprueba.jsp"><i class="fas fa-tachometer-alt fa-fw"></i> &nbsp; Cobro Prueba</a>
                            </li>
                            <li>
                                <a href="int.jsp"><i class="fas fa-calendar-alt"></i> &nbsp; CheckInt</a>
                            </li>
                            -->
                            <!-- 
                           <li>
                               <a href="reservas.jsp"><i class="fas fa-calendar-alt"></i> &nbsp; Reservas</a>
                           </li>
                            -->

                            

                            <li>
                                <a href="#" class="nav-btn-submenu"><i class="fas fa-chart-line"></i>
                                    &nbsp; Venta <i class="fas fa-chevron-down"></i></a>
                                <ul>
                                    <li><a href="ventas.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Agregar ventas</a></li>
                                    <li><a href="facturas.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista Facturas</a></li>
                                    <li><a href="listadoventacreditocobro.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista Cobros</a></li>
                                    
                                    <!-- 
                                    <li><a href="listapendientecobro.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista Cobros Pendientes</a></li>
                                    -->
                                </ul>
                            </li>
                            
                            <li>
                                <a href="salida.jsp"><i class="fas fa-sign-out-alt fa-fw"></i> &nbsp; Salida</a>
                            </li>

                            <li>
                                <a href="#" class="nav-btn-submenu">
                                    <i class="fas fa-shopping-cart"></i> &nbsp; Compra <i class="fas fa-chevron-down"></i>
                                </a>
                                <ul>
                                    <li><a href="compras.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Agregar Compra</a></li>
                                    <li><a href="listadocompracreditopago.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista Pagos </a></li>

                                    <li><a href="listapendientepago.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista Pagos Pendientes</a></li>
                                    <!--
                                    <li><a href="notacredito.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Agregar Nota Crédito</a></li>
                                    -->
                                </ul>
                            </li>


                            <li>
                                <a href="#" class="nav-btn-submenu">
                                    <i class="fas fa-box"></i> &nbsp; Inventario <i class="fas fa-chevron-down"></i>
                                </a>
                                <ul>
                                    <li><a href="listainventario.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista de Inventario</a></li>
                                    <li><a href="inventario.jsp"><i class="fas fa-list-ul fa-fw"></i> &nbsp; Lista Movimiento Inventario</a></li>
                                    <li><a href="ajustesstocks.jsp"><i class="fas fa-sliders-h fa-fw"></i> &nbsp; Agregar Ajuste de Inventario</a></li>
                                </ul>
                            </li>

                            
                            <!-- Page content 
                            <li>
                                <a href="#" class="nav-btn-submenu">
                                    <i class="fas fa-undo"></i> &nbsp; Devoluciones <i class="fas fa-chevron-down"></i>
                                </a>
                                <ul>
                                    <li><a href="devoluciones.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Agregar Devoluciones</a></li>
                                </ul>
                            </li>

                            <li>
                                <a href="#" class="nav-btn-submenu">
                                    <i class="fas fa-undo-alt"></i> &nbsp; Devoluciones <i class="fas fa-chevron-down"></i>
                                </a>
                                <ul>
                                    <li><a href="devoluciones.jsp"><i class="fas fa-plus fa-fw"></i> &nbsp; Agregar Devolución</a></li>
                                </ul>
                            </li>-->
                            <!--
                                                       <li><a href="company.html"><i class="fas fa-store-alt fa-fw"></i> &nbsp; Empresa</a></li>
                            -->
                        </ul>
                    </nav>
                </div>
            </section>

            <!-- Page content -->
            <section class="full-box page-content">
                <nav class="full-box navbar-info">
                    <a href="#" class="float-left show-nav-lateral">
                        <i class="fas fa-exchange-alt"></i>
                    </a>
                    <a href="usuarios.jsp">
                        <i class="fas fa-user-cog"></i>
                    </a>
                    <a href="#" class="btn-exit-system">
                        <i class="fas fa-power-off"></i>
                    </a>
                </nav>
