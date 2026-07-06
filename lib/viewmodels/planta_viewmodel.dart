import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../models/riego.dart';
import '../services/firestore_service.dart';
import '../utils/planta_utils.dart';
import '../models/horas_sol.dart';

//Intermediario entre UI y firestore
class PlantaViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  //Valida los datos y registra una nueva planta en Firestore.
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
    } catch (_) {
      return "Ocurrió un error al registrar la planta.";
    }
  }

  //Obtiene un flujo de datos de todas las plantas para la pantalla principal.
  Stream<QuerySnapshot> obtenerPlantas() {
    return _firestoreService.obtenerPlantas();
  }

  //Actualiza la información de una planta existente.
  Future<void> actualizarPlanta(Planta planta) async {
    await _firestoreService.actualizarPlanta(planta);
  }

  //Elimina una planta y limpia todos sus registros asociados.
  Future<void> eliminarPlanta(String id) async {
    await _firestoreService.eliminarPlanta(id);
  }

  //Registra un nuevo evento de riego para la fecha y hora actual.
  Future<void> registrarRiego(String plantaId) async {
    final nuevoRiego = Riego(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantaId: plantaId,
      fecha: DateTime.now(),
    );
    await _firestoreService.registrarRiego(nuevoRiego);
  }

  //Obtiene los registros de riego de una planta.
  Stream<QuerySnapshot> obtenerRiegos(String plantaId) {
    return _firestoreService.obtenerRiegos(plantaId);
  }

  //Recupera la última vez que se regó la planta.
  Future<DateTime?> obtenerUltimoRiego(String plantaId) {
    return _firestoreService.obtenerUltimoRiego(plantaId);
  }

  //Calcula la fecha estimada del siguiente riego basándose en la frecuencia.
  DateTime calcularProximoRiego(DateTime ultimoRiego, int frecuenciaDias) {
    return PlantaUtils.calcularProximoRiego(ultimoRiego, frecuenciaDias);
  }

  //Determina si la planta ya pasó su fecha de riego programada.
  bool necesitaRiego(DateTime ultimoRiego, int frecuenciaDias) {
    return PlantaUtils.necesitaRiego(ultimoRiego, frecuenciaDias);
  }

  //Obtiene un texto descriptivo del estado de riego
  String obtenerEstadoRiego(DateTime ultimoRiego, int frecuenciaDias) {
    return PlantaUtils.obtenerEstadoRiego(ultimoRiego, frecuenciaDias);
  }

  //Obtiene el nombre del color asociado al estado
  String obtenerColorEstado(DateTime ultimoRiego, int frecuenciaDias) {
    return PlantaUtils.obtenerColorEstado(ultimoRiego, frecuenciaDias);
  }

  //Obtiene el total de plantas registradas.
  Future<int> obtenerCantidadPlantas() {
    return _firestoreService.obtenerCantidadPlantas();
  }

  //Obtiene el total de riegos realizados en toda la app.
  Future<int> obtenerCantidadRiegos() {
    return _firestoreService.obtenerCantidadRiegos();
  }

  //Calcula cuántas plantas en total requieren atención inmediata de riego.
  Future<int> obtenerPlantasQueNecesitanRiego() async {
    int contador = 0;
    final plantasSnapshot = await _firestoreService.obtenerTodasLasPlantas();
    for (final documento in plantasSnapshot.docs) {
      final planta = Planta.fromMap(documento.data() as Map<String, dynamic>);
      final ultimoRiego = await _firestoreService.obtenerUltimoRiego(planta.id);
      
      if (ultimoRiego == null) {
        contador++; // Si nunca se regó, necesita atención.
        continue;
      }
      if (necesitaRiego(ultimoRiego, planta.frecuenciaDias)) {
        contador++;
      }
    }
    return contador;
  }

  //Estadísticas por planta: Total de riegos.
  Future<int> obtenerCantidadRiegosPlanta(String plantaId) {
    return _firestoreService.obtenerCantidadRiegosPlanta(plantaId);
  }

  //Estadísticas por planta: Total histórico de riegos.
  Future<int> obtenerTotalRiegosPlanta(String plantaId) {
    return _firestoreService.obtenerTotalRiegosPlanta(plantaId);
  }

  //Estadísticas por planta: Riegos en la última semana.
  Future<int> obtenerRiegosSemana(String plantaId) {
    return _firestoreService.obtenerRiegosSemana(plantaId);
  }

  //Estadísticas por planta: Riegos en el mes actual.
  Future<int> obtenerRiegosMes(String plantaId) {
    return _firestoreService.obtenerRiegosMes(plantaId);
  }

  //Estadísticas globales: Nombre de la planta más cuidada.
  Future<String> obtenerPlantaMasRegada() {
    return _firestoreService.obtenerPlantaMasRegada();
  }

  //Registra una sesión de exposición al sol para una planta.
  Future<void> registrarHorasSol(String plantaId, int horas) async {
    final dato = HoraSol(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plantaId: plantaId,
      horas: horas,
      fecha: DateTime.now(),
    );
    await _firestoreService.registrarHorasSol(dato);
  }

  //Suma total de horas de sol recibidas por una planta.
  Future<int> obtenerHorasSol(String plantaId) {
    return _firestoreService.obtenerHorasSol(plantaId);
  }

  //Calcula el porcentaje de veces que el usuario ha regado a tiempo.
  Future<int> obtenerPorcentajeCumplimiento(String plantaId) async {
    final plantasSnapshot = await _firestoreService.obtenerTodasLasPlantas();
    Planta? planta;
    for (final doc in plantasSnapshot.docs) {
      final p = Planta.fromMap(doc.data() as Map<String, dynamic>);
      if (p.id == plantaId) {
        planta = p;
        break;
      }
    }
    if (planta == null) return 0;

    final consulta = await _firestoreService.obtenerRiegos(plantaId).first;
    final docs = consulta.docs;
    if (docs.length < 2) return docs.isEmpty ? 0 : 100;

    docs.sort((a, b) {
      final fechaA = (a["fecha"] as Timestamp).toDate();
      final fechaB = (b["fecha"] as Timestamp).toDate();
      return fechaA.compareTo(fechaB);
    });

    int cumplidos = 0;
    final totalIntervalos = docs.length - 1;
    for (int i = 1; i < docs.length; i++) {
      final fechaAnterior = (docs[i - 1]["fecha"] as Timestamp).toDate();
      final fechaActual = (docs[i]["fecha"] as Timestamp).toDate();
      final dias = fechaActual.difference(fechaAnterior).inDays;
      if (dias <= planta.frecuenciaDias) {
        cumplidos++;
      }
    }
    return ((cumplidos / totalIntervalos) * 100).round();
  }

  //Historial de registros de sol para mostrar en la UI.
  Stream<QuerySnapshot> obtenerHistorialHorasSol(String plantaId) {
    return _firestoreService.obtenerHistorialHorasSol(plantaId);
  }
}
