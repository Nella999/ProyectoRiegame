import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../models/riego.dart';
import '../services/firestore_service.dart';
import '../utils/planta_utils.dart';

class PlantaViewModel {
  final FirestoreService _firestoreService = FirestoreService();
  Future<String?> registrarPlanta(Planta planta) async {  //Valida los datos y registra una nueva planta.
    if (planta.nombre.trim().isEmpty) {
      return "Debe ingresar el nombre de la planta.";
    }
    if (planta.frecuenciaDias <= 0) {
      return "La frecuencia de riego debe ser mayor que cero.";
    }
    try {
      await _firestoreService.registrarPlanta(planta);
      return null;
    } catch (_) {
      return "Ocurrió un error al registrar la planta.";
    }
  }
  Stream<QuerySnapshot> obtenerPlantas() {  //Obtiene todas las plantas en tiempo real.
    return _firestoreService.obtenerPlantas();
  }
  Future<void> actualizarPlanta(Planta planta) async {  //Actualiza una planta existente.
    await _firestoreService.actualizarPlanta(planta);
  }
  Future<void> eliminarPlanta(String id) async {  //Elimina una planta.
    await _firestoreService.eliminarPlanta(id);
  }
  Future<void> registrarRiego(String plantaId) async {//Registra un nuevo riego para una planta.
    final nuevoRiego = Riego(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantaId: plantaId,
      fecha: DateTime.now(),
    );
    await _firestoreService.registrarRiego(nuevoRiego);
  }
  Stream<QuerySnapshot> obtenerRiegos(String plantaId) {  //Obtiene el historial de riegos de una planta.
    return _firestoreService.obtenerRiegos(plantaId);
  }
  Future<DateTime?> obtenerUltimoRiego(String plantaId) {  //Obtiene la fecha del último riego registrado.
    return _firestoreService.obtenerUltimoRiego(plantaId);
  }

  DateTime calcularProximoRiego(  //Calcula la fecha del próximo riego.
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    return PlantaUtils.calcularProximoRiego(
      ultimoRiego,
      frecuenciaDias,
    );
  }
  bool necesitaRiego(  //Indica si una planta necesita ser regada.
      DateTime ultimoRiego,
      int frecuenciaDias,
      ) {
    return PlantaUtils.necesitaRiego(
      ultimoRiego,
      frecuenciaDias,
    );
  }

  Future<int> obtenerCantidadPlantas() {  //Devuelve la cantidad total de plantas registradas.
    return _firestoreService.obtenerCantidadPlantas();
  }
  Future<int> obtenerCantidadRiegos() {  //Devuelve la cantidad total de riegos registrados.
    return _firestoreService.obtenerCantidadRiegos();
  }
  Future<int> obtenerPlantasQueNecesitanRiego() async {  //Cuenta cuántas plantas necesitan riego actualmente.
    int contador = 0;
    final plantasSnapshot =
    await _firestoreService.obtenerTodasLasPlantas();
    for (final documento in plantasSnapshot.docs) {
      final planta = Planta.fromMap(
        documento.data() as Map<String, dynamic>,
      );
      final ultimoRiego =
      await _firestoreService.obtenerUltimoRiego(
        planta.id,
      );
      // Si nunca fue regada, se considera que necesita riego.
      if (ultimoRiego == null) {
        contador++;
        continue;
      }
      if (necesitaRiego(
        ultimoRiego,
        planta.frecuenciaDias,
      )) {
        contador++;
      }
    }
    return contador;
  }
}