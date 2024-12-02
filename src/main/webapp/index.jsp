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
        <title>Login</title>

        <!-- Normalize V8.0.1 -->
        <link rel="stylesheet" href="./css/normalize.css">

        <!-- Bootstrap V4.3 -->
        <link rel="stylesheet" href="css/bootstrap.min.css">

        <!-- Bootstrap Material Design V4.0 -->
        <link rel="stylesheet" href="css/bootstrap-material-design.min.css">

        <!-- Font Awesome V5.9.0 -->
        <link rel="stylesheet" href="css/all.css">

        <!-- Sweet Alerts V8.13.0 CSS file -->
        <link rel="stylesheet" href="css/sweetalert2.min.css">

        <!-- Sweet Alert V8.13.0 JS file -->
        <script src="js/sweetalert2.min.js"></script>

        <!-- jQuery Custom Content Scroller V3.1.5 -->
        <link rel="stylesheet" href="css/jquery.mCustomScrollbar.css">

        <!-- General Styles -->
        <link rel="stylesheet" href="css/style.css">
        
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <style>.pointer {cursor: pointer;}</style>
    </head>
    <body>

        <div class="login-container">
            <div class="login-content">
                <p class="text-center">
                    <i class="fas fa-user-circle fa-5x"></i>
                </p>
                <p class="text-center">
                    Inicia sesión con tu cuenta
                </p>
                <form action="" id="formlogin" method="post">
                    <div class="form-group">
                        <label for="UserName" class="bmd-label-floating"><i class="fas fa-user-secret"></i> &nbsp; Usuario</label>
                        <input type="text" class="form-control" id="usuario" name="usuario" pattern="[a-zA-Z0-9]{1,35}" maxlength="35">
                    </div>
                    <div class="form-group">
                        <label for="UserPassword" class="bmd-label-floating"><i class="fas fa-key"></i> &nbsp; Contraseña</label>
                        <input type="password" class="form-control" id="pswrd" name="pswrd" maxlength="200">
                    </div>
                    <a class="btn-login text-center pointer" id="acceso">INGRESAR</a>
                </form>
                <div id="respuestalogin"></div>
            </div>
        </div>

        <script>
            $(document).ready(function() {
                $("#acceso").click(function() {
                    var usuario = $("#usuario").val().trim();
                    var pswrd = $("#pswrd").val().trim();
                    var error = false;

                    // Validar usuario
                    if (usuario === "") {
                        $("#usuario").after('<span class="errorUsuario text-danger">Ingrese un usuario.</span>');
                        error = true;
                        setTimeout(function() {
                            $(".errorUsuario").fadeOut('slow', function() {
                                $(this).remove();
                            });
                        }, 2000);
                    }

                    // Validar contraseña
                    if (pswrd === "") {
                        $("#pswrd").after('<span class="errorUsuario text-danger">Ingrese una contraseña.</span>');
                        error = true;
                        setTimeout(function() {
                            $(".errorUsuario").fadeOut('slow', function() {
                                $(this).remove();
                            });
                        }, 2000);
                    }

                    // Si hay errores, detener el proceso
                    if (error) {
                        return;
                    }

                    var datosform = $("#formlogin").serialize();
                    $.ajax({
                        data: datosform,
                        url: 'jsp/logincrud.jsp',
                        type: 'post',
                        beforeSend: function() {
                            // Mostrar un mensaje de carga si es necesario
                        }, 
                        success: function(response) {
                            $("#respuestalogin").html(response);

                            // Ocultar el mensaje de "Usuario no válido" después de 2 segundos
                            if (response.includes("alert-danger")) {
                                setTimeout(function() {
                                    $("#respuestalogin .alert").fadeOut('slow', function() {
                                        $(this).remove();
                                    });
                                }, 2000);
                            }
                        }
                    });
                });
            });
        </script>

        <!-- codigo del profe 
        <script>
            $("#acceso").click(function() {
            var datosform = $("#formlogin").serialize();
            $.ajax({
                data: datosform,
                url: 'jsp/logincrud.jsp',
                type: 'post',
                beforeSend: function() {
                    // Puedes mostrar un mensaje de carga aquí si lo deseas
                    // $("#resultado").html("Procesando, espere por favor...");
                },
                success: function(response) {
                    $("#respuestalogin").html(response);
                }
            });
        });
        </script>
          -->

<%@include file="footer.jsp" %>