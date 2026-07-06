//Modelo que representa una planta en el sistema.
class Planta {
  final String id;           // Identificador único de la planta (usualmente el ID de Firestore).
  final String nombre;       // Nombre común o científico de la planta.
  final String apodo;        // Nombre cariñoso asignado por el usuario.
  final String observaciones;// Notas adicionales sobre el cuidado o estado.
  final int frecuenciaDias;  // Cada cuántos días debe ser regada.
  final int horasSol;        // Cantidad de horas de sol recomendadas o recibidas.

  Planta({
    required this.id,
    required this.nombre,
    required this.apodo,
    required this.observaciones,
    required this.frecuenciaDias,
    required this.horasSol,
  });
  //Convierte la instancia de [Planta] a un [Map] para ser almacenado en Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apodo': apodo,
      'observaciones': observaciones,
      'frecuenciaDias': frecuenciaDias,
      'horasSol': horasSol,
    };
  }
  //Crea una instancia de [Planta] a partir de un [Map] proveniente de Firestore.
  factory Planta.fromMap(Map<String, dynamic> map) {
    return Planta(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      apodo: map['apodo'] ?? '',
      observaciones: map['observaciones'] ?? '',
      frecuenciaDias: map['frecuenciaDias'] ?? 0,
      horasSol: map["horasSol"] ?? 0,
    );
  }
}