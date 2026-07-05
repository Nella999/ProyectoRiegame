import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../models/riego.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarPlanta(Planta planta) async { //creación de coleccion en el firebase
    await _db
        .collection("plantas")
        .doc(planta.id)
        .set(planta.toMap());
  }
  Stream<QuerySnapshot> obtenerPlantas() { //Llamar info de la firebase
    return _db.collection("plantas").snapshots();
  }
  Future<void> actualizarPlanta(Planta planta) async { //Funcion para actualizar planta
    await _db
        .collection("plantas")
        .doc(planta.id)
        .update(planta.toMap());
  }Future<void> eliminarPlanta(String id) async { //Funcion para eliminar plantas
    await _db.collection("plantas").doc(id).delete();
  }
  Future<void> registrarRiego(Riego riego) async {//Registra un nuevo riego
    await _db
        .collection("riegos")
        .doc(riego.id)
        .set(riego.toMap());
  }
  Stream<QuerySnapshot> obtenerRiegos(String plantaId) {  // Obtiene todos los riegos de una planta.
    return _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .orderBy("fecha", descending: true)
        .snapshots();
  }
  Future<DateTime?> obtenerUltimoRiego(// Obtiene el último riego registrado de una planta.
      String plantaId) async {
    final consulta = await _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .orderBy("fecha", descending: true)
        .limit(1)
        .get();
    if (consulta.docs.isEmpty) {
      return null;
    }
    return (consulta.docs.first["fecha"] as Timestamp)
        .toDate();
  }
  Future<int> obtenerCantidadPlantas() async {  //Obtiene la cantidad total de plantas.
    final consulta = await _db.collection("plantas").get();
    return consulta.docs.length;
  }
  Future<int> obtenerCantidadRiegos() async {  // Obtiene la cantidad total de riegos.
    final consulta = await _db.collection("riegos").get();
    return consulta.docs.length;
  }
  Future<QuerySnapshot> obtenerTodasLasPlantas() async {  //Obtiene todas las plantas.
    return await _db.collection("plantas").get();
  }
}