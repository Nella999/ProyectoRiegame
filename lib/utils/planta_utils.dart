//Clase de utilidades con lógica pura para cálculos relacionados con las plantas.
class PlantaUtils {

  //Calcula la fecha en la que debería ser el próximo riego.
  static DateTime calcularProximoRiego(
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    return ultimoRiego.add(
      Duration(days: frecuenciaDias),
    );
  }
  //Indica si una planta necesita riego hoy.
  static bool necesitaRiego(
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    return DateTime.now().isAfter(
      calcularProximoRiego(
        ultimoRiego,
        frecuenciaDias,
      ),
    );
  }
  //Devuelve una cadena de texto que describe el estado de salud
  static String obtenerEstadoRiego(
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    final proximo = calcularProximoRiego(
      ultimoRiego,
      frecuenciaDias,
    );
    final ahora = DateTime.now();
    
    // Si la fecha actual superó la fecha del próximo riego
    if (ahora.isAfter(proximo)) {
      return "Necesita riego";
    }
    
    final diasRestantes = proximo.difference(ahora).inDays;
    if (diasRestantes <= 1) {
      return "Próximo riego";
    }
    
    return "Excelente";
  }

  //Mapea el estado de riego a un color semántico
  static String obtenerColorEstado(
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    final estado = obtenerEstadoRiego(
      ultimoRiego,
      frecuenciaDias,
    );
    switch (estado) {
      case "Excelente":
        return "verde";
      case "Próximo riego":
        return "amarillo";
      default:
        return "rojo";
    }
  }
}
