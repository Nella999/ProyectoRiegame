class PlantaUtils {

  //Calcula la fecha del próximo riego.
  static DateTime calcularProximoRiego(
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    return ultimoRiego.add(
      Duration(days: frecuenciaDias),
    );
  }

  //Indica si una planta necesita riego.
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
}