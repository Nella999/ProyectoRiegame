import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';

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

}