class Planta {
  //Detallando la info registrada
  final String id;
  final String nombre;
  final String apodo;
  final String observaciones;
  final int frecuenciaDias;

  Planta({
    required this.id,
    required this.nombre,
    required this.apodo,
    required this.observaciones,
  required this.frecuenciaDias,
  });
  //Agregando map para que Firestore pueda leerlo
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apodo': apodo,
      'observaciones': observaciones,
      'frecuenciaDias': frecuenciaDias,
    };
  }

  // Convierte un doc de Firestore en un objeto Planta
  factory Planta.fromMap(Map<String, dynamic> map) {
    return Planta(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      apodo: map['apodo'] ?? '',
      observaciones: map['observaciones'] ?? '',
      frecuenciaDias: map['frecuenciaDias'] ?? 0,
    );
  }
}
