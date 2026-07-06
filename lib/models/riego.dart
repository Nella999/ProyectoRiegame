//Modelo que representa un evento de riego.
class Riego {
  final String id;        // Identificador único del registro de riego.
  final String plantaId;  // ID de la planta a la que pertenece este riego.
  final DateTime fecha;   // Fecha y hora en la que se realizó el riego.
  Riego({
    required this.id,
    required this.plantaId,
    required this.fecha,
  });
  //Convierte la instancia de [Riego] a un [Map] para ser almacenado en Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantaId': plantaId,
      'fecha': fecha,
    };
  }
  //Crea una instancia de [Riego] a partir de un [Map] proveniente de Firestore.
  factory Riego.fromMap(Map<String, dynamic> map) {
    return Riego(
      id: map['id'],
      plantaId: map['plantaId'],
      fecha: map['fecha'].toDate(),
    );
  }
}