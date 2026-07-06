import 'package:cloud_firestore/cloud_firestore.dart';

//Modelo que representa un registro de horas de sol recibidas por una planta.
class HoraSol {
  final String id;        // Identificador único del registro.
  final String plantaId;  // ID de la planta a la que se le asignan las horas.
  final int horas;        // Cantidad de horas registradas.
  final DateTime fecha;   // Fecha en la que se realizó el registro.

  HoraSol({
    required this.id,
    required this.plantaId,
    required this.horas,
    required this.fecha,
  });

  //Convierte la instancia de [HoraSol] a un [Map] para Firestore.
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "plantaId": plantaId,
      "horas": horas,
      "fecha": fecha,
    };
  }

  //Crea una instancia de [HoraSol] a partir de un [Map] de Firestore.
  factory HoraSol.fromMap(Map<String, dynamic> map) {
    return HoraSol(
      id: map["id"],
      plantaId: map["plantaId"],
      horas: map["horas"],
      fecha: (map["fecha"] as Timestamp).toDate(),
    );
  }
}