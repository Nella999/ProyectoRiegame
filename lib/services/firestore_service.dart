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

  Future<void> eliminarPlanta(String id) async { //Funcion para eliminar plantas
    await _db.collection("plantas").doc(id).delete();
  }

  Future<void> actualizarPlanta(Planta planta) async { //Funcion para editar planta
    await _db
        .collection("plantas")
        .doc(planta.id)
        .update(planta.toMap());
  }
  /// Registra un nuevo riego en Firestore.
  Future<void> registrarRiego(Riego riego) async {
    await _db
        .collection("riegos")
        .doc(riego.id)
        .set(riego.toMap());
  }

  /// Obtiene todos los riegos de una planta.
  Stream<QuerySnapshot> obtenerRiegos(String plantaId) {
    return _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .orderBy("fecha", descending: true)
        .snapshots();
  }

}