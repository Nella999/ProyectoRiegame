class Planta {
  final String id;  //Identificador  de la planta.
  final String nombre;  //Nombre de la planta.
  final String apodo;  //Apodo asignado por el usuario.
  final String observaciones;//Observaciones adicionales
  final int frecuenciaDias;//Frecuencia de riego en días.

  Planta({
    required this.id,
    required this.nombre,
    required this.apodo,
    required this.observaciones,
    required this.frecuenciaDias,
  });
  //Convierte el objeto Planta en un Map para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apodo': apodo,
      'observaciones': observaciones,
      'frecuenciaDias': frecuenciaDias,
    };
  }
  /// Crea una instancia de Planta desde un documento de Firestore.
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