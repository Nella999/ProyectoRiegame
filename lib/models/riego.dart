class Riego {
  final String id;  //Identificador  del registro de riego.
  final String plantaId;//Identificador de la planta regada.
  final DateTime fecha;//Fecha en la que se realizó el riego.
  Riego({
    required this.id,
    required this.plantaId,
    required this.fecha,
  });
  /// Convierte el objeto Riego en un Map para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantaId': plantaId,
      'fecha': fecha,
    };
  }
  /// Crea una instancia de Riego desde el documento de Firestore.
  factory Riego.fromMap(Map<String, dynamic> map) {
    return Riego(
      id: map['id'],
      plantaId: map['plantaId'],
      fecha: map['fecha'].toDate(),
    );
  }
}