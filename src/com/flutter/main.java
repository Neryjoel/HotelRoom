package com.flutter;

public class main {
    public static void main(String[] args) {
        // Crear una instancia de la clase de conexión
        conexionflutter conexion = new conexionflutter();
        
        // Intentar establecer la conexión
        if (conexion.establecerConexion() != null) {
            System.out.println("La conexión se ha establecido correctamente.");
        } else {
            System.out.println("No se pudo establecer la conexión.");
        }
    }
}
