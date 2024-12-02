<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ include file="jsp/conexion.jsp" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
try {
    // Ubicación del archivo jasper
    File reportFile = new File(application.getRealPath("informe/informecompra.jasper"));
    
    // Obtener fechas del formulario y convertir a Date
    Date fechaInicio = Date.valueOf(request.getParameter("fechaInicio"));
    Date fechaFin = Date.valueOf(request.getParameter("fechaFin"));
    
    // Crear mapa de parámetros // CAMBIAR FORMATO DATE
    Map parametros = new HashMap();
    parametros.put("fechaInicio", fechaInicio);
    parametros.put("fechaFin", fechaFin);

    byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parametros, conn);
    response.setContentType("application/pdf");
    response.setContentLength(bytes.length);

    ServletOutputStream output = response.getOutputStream();
    response.getOutputStream();
    output.write(bytes, 0, bytes.length);
    output.flush();
    output.close();
} catch (Exception ex) {
    ex.printStackTrace();
}
%>