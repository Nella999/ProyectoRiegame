class Riego {

  final String id;
  final String plantaId;
  final DateTime fecha;

  Riego({
    required this.id,
    required this.plantaId,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantaId': plantaId,
      'fecha': fecha,
    };
  }

  factory Riego.fromMap(Map<String, dynamic> map) {
    return Riego(
      id: map['id'],
      plantaId: map['plantaId'],
      fecha: map['fecha'].toDate(),
    );
  }
}