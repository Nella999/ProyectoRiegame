import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarPlanta(Planta planta) async {

    await _db
    //Crea una colección llamada plantas
        .collection("plantas")
        .doc(planta.id) //crea doc
        .set(planta.toMap()); // guarda info

  }

}