import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../services/firestore_service.dart';

/// ViewModel comunica la interfaz con Firestore.
class PlantaViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  /// Registra una nueva planta
  Future<void> registrarPlanta(Planta planta) async {
    await _firestoreService.registrarPlanta(planta);
  }

  /// Obtiene todas las plantas en tiempo real
  Stream<QuerySnapshot> obtenerPlantas() {
    return _firestoreService.obtenerPlantas();
  }

  /// Elimina una planta
  Future<void> eliminarPlanta(String id) async {
    await _firestoreService.eliminarPlanta(id);
  }

  /// Actualiza una planta existente
  Future<void> actualizarPlanta(Planta planta) async {
    await _firestoreService.actualizarPlanta(planta);
  }

}