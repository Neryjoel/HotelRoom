<%@ include file="header.jsp" %>

<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }

    .container-fluid {
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    #invoice {
        width: 100%;
        max-width: 800px;
        margin: 0 auto;
        border: 1px solid #ccc;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    #invoice-header {
        text-align: center;
        margin-bottom: 20px;
    }

    #invoice-info-right {
        float: right;
    }

    #invoice-info {
        margin-bottom: 20px;
    }

    .table-responsive {
        overflow-x: auto;
    }

    .table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    .table th {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: left;
        background-color: #000;
        color: #fff; /* Color de texto blanco para los encabezados */
    }

    .table td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: left;
    }

    .totals-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    .totals-table td {
        border: 1px solid #ccc;
        padding: 10px;
        text-align: left;
    }

    @media (max-width: 768px) {
        #invoice {
            padding: 10px;
        }
        .table-responsive {
            overflow-x: scroll;
        }
    }

    .print-button {
        margin-top: 20px;
        text-align: center;
    }

    .print-button button {
        padding: 10px 20px;
        font-size: 14px;
        background-color: #007bff;
        color: #fff;
        border: none;
        cursor: pointer;
    }

    @media print {
        .print-button {
            display: none; /* Ocultar el botón de impresión en la versión impresa */
        }
    }
</style>

<div class="container-fluid">
    <div id="invoice">
        <div id="invoice-header">
            <h1>HotelRoom S.A</h1>
            <p>234/90, New York Street<br>
                United States.</p>
            <p>Web: www.hotelroomadmin.com<br>
                E-mail: info@hotelroom.gmail.com<br>
                Tel: +456-345-908-559<br>
                Twitter: @hotelroom</p>
        </div>

        <div id="invoice-info-right">
            <table>
                <tr>
                    <td>Fecha:</td>
                    <td>${facturascom[1]}asddas</td>
                </tr>
                <tr>
                    <td>Factura </td>
                    <td class="center">#: asd${facturascom[0]}</td>
                </tr>
            </table>
        </div>

        <div id="invoice-info">
            <h2>Datos del Huesped</h2>
            <p>d${facturascom[3]}</p>
            <p>d${facturascom[4]}</p>
            <p>d${facturascom[5]}</p>
        </div>

        <hr>

        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th scope="col">Código</th>
                        <th scope="col">Descripción</th>
                        <th scope="col">Precio</th>
                        <th scope="col">Cantidad</th>
                        <th scope="col">Total</th>
                    </tr>
                </thead>
                <tbody>

                    <tr>
                        <td>${det.get(i)[0]}</td>
                        <td>${det.get(i)[1]}</td>
                        <td>GS. ${det.get(i)[3]}</td>
                        <td>${det.get(i)[2]}</td>
                        <td>GS. ${det.get(i)[3] * det.get(i)[2]}</td>
                    </tr>

                </tbody>
            </table>
        </div>

        <hr>

        <div id="invoice-info-right">
            <table class="totals-table">
                <tr>
                    <td>Total:</td>
                    <td>GS. <input type="number" readonly value="${facturascom[2]}" style="width: 100px; font-size: 12px;"></td>
                </tr>
                <tr>
                    <td>SubTotal:</td>
                    <td>GS. <input type="number" readonly value="${facturascom[2]}" style="width: 100px; font-size: 12px;"></td>
                </tr>
            </table>
        </div>

        <div id="invoice-info">
            <h2>Usuario:</h2>
            <p>f${facturascom[6]}</p>
            <p>f${facturascom[6]}</p>
        </div>

        <hr>



        <hr>

        <div class="text-center">
            <span>Nota de Compras Internas</span>
        </div>
    </div>
    <div class="text-center print-button">
        <button onclick="window.print()">Imprimir Factura</button>
    </div>
</div>

<%@ include file="footer.jsp" %>
