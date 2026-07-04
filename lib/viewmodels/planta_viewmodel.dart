import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../services/firestore_service.dart';

// ViewModel comunica la interfaz con Firestore.
class PlantaViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  // Valida y registra una nueva planta.
  Future<String?> registrarPlanta(Planta planta) async {

    if (planta.nombre.trim().isEmpty) {
      return "Debe ingresar el nombre de la planta.";
    }
    if (planta.frecuenciaDias <= 0) {
      return "La frecuencia de riego debe ser mayor que cero.";
    }
    try {
      await _firestoreService.registrarPlanta(planta);
      return null;
    } catch (e) {
      return "Ocurrió un error al registrar la planta.";
    }
  }

  // Obtiene todas las plantas en tiempo real
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