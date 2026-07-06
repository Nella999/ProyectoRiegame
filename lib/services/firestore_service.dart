import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../models/riego.dart';
import '../models/horas_sol.dart';

//Servicio encargado de la comunicación directa con Firebase Firestore.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Registra una nueva planta en la colección "plantas".
  Future<void> registrarPlanta(Planta planta) async {
    await _db
        .collection("plantas")
        .doc(planta.id)
        .set(planta.toMap());
  }

  //Obtiene un flujo de todas las plantas para actualizaciones en tiempo real.
  Stream<QuerySnapshot> obtenerPlantas() {
    return _db.collection("plantas").snapshots();
  }

  //Actualiza los datos de una planta existente.
  Future<void> actualizarPlanta(Planta planta) async {
    await _db
        .collection("plantas")
        .doc(planta.id)
        .update(planta.toMap());
  }

  //Elimina una planta y todos sus datos relacionados
  Future<void> eliminarPlanta(String id) async {
    final batch = _db.batch();
    final plantaRef = _db.collection("plantas").doc(id);
    batch.delete(plantaRef);
    final riegos = await _db
        .collection("riegos")
        .where("plantaId", isEqualTo: id)
        .get();
    for (var doc in riegos.docs) {
      batch.delete(doc.reference);
    }
    final horas = await _db
        .collection("horas_sol")
        .where("plantaId", isEqualTo: id)
        .get();
    for (var doc in horas.docs) {
      batch.delete(doc.reference);
    }

    // Ejecutar todas las eliminaciones
    await batch.commit();
  }

  Future<QuerySnapshot> obtenerTodasLasPlantas() async {
    return await _db.collection("plantas").get();
  }

  //Retorna el conteo total de plantas en la base de datos.
  Future<int> obtenerCantidadPlantas() async {
    final consulta = await _db.collection("plantas").get();
    return consulta.docs.length;
  }

  /// Registra un nuevo evento de riego en la colección "riegos".
  Future<void> registrarRiego(Riego riego) async {
    await _db
        .collection("riegos")
        .doc(riego.id)
        .set(riego.toMap());
  }

  /// Obtiene un Stream de los riegos de una planta específica, ordenados por fecha.
  Stream<QuerySnapshot> obtenerRiegos(String plantaId) {
    return _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .snapshots();
  }

  /// Recupera la fecha del último riego registrado para una planta.
  Future<DateTime?> obtenerUltimoRiego(String plantaId) async {
    final consulta = await _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .get();
    if (consulta.docs.isEmpty) {
      return null;
    }
    // Ordenar manualmente por fecha descendente
    consulta.docs.sort((a, b) {
      final fechaA = (a["fecha"] as Timestamp).toDate();
      final fechaB = (b["fecha"] as Timestamp).toDate();
      return fechaB.compareTo(fechaA);
    });
    return (consulta.docs.first["fecha"] as Timestamp).toDate();
  }

  //Retorna el total de riegos realizados en toda la aplicación.
  Future<int> obtenerCantidadRiegos() async {
    final consulta = await _db.collection("riegos").get();
    return consulta.docs.length;
  }

  //Obtiene la cantidad de veces que ha sido regada una planta específica.
  Future<int> obtenerCantidadRiegosPlanta(String plantaId) async {
    final consulta = await _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .get();

    return consulta.docs.length;
  }

  Future<int> obtenerTotalRiegosPlanta(String plantaId) async {
    return obtenerCantidadRiegosPlanta(plantaId);
  }

  /// Cuenta los riegos de una planta en los últimos 7 días.
  Future<int> obtenerRiegosSemana(String plantaId) async {
    final hace7Dias = DateTime.now().subtract(const Duration(days: 7));
    final consulta = await _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .get();
    return consulta.docs.where((doc) {
      final fecha = (doc["fecha"] as Timestamp).toDate();
      return fecha.isAfter(hace7Dias);
    }).length;
  }

  //Cuenta los riegos de una planta realizados en el mes actual.
  Future<int> obtenerRiegosMes(String plantaId) async {
    final ahora = DateTime.now();
    final consulta = await _db
        .collection("riegos")
        .where("plantaId", isEqualTo: plantaId)
        .get();
    return consulta.docs.where((doc) {
      final fecha = (doc["fecha"] as Timestamp).toDate();
      return fecha.month == ahora.month &&
          fecha.year == ahora.year;
    }).length;
  }

  //Guarda un registro de horas de sol en la colección "horas_sol".
  Future<void> registrarHorasSol(HoraSol dato) async {
    await _db
        .collection("horas_sol")
        .doc(dato.id)
        .set(dato.toMap());
  }

  //Suma el total de horas de sol registradas para una planta.
  Future<int> obtenerHorasSol(String plantaId) async {
    final consulta = await _db
        .collection("horas_sol")
        .where("plantaId", isEqualTo: plantaId)
        .get();
    int total = 0;
    for (final doc in consulta.docs) {
      total += doc["horas"] as int;
    }
    return total;
  }

  //Obtiene el historial de registros de sol para una planta en tiempo real.
  Stream<QuerySnapshot> obtenerHistorialHorasSol(String plantaId) {
    return _db
        .collection("horas_sol")
        .where("plantaId", isEqualTo: plantaId)
        .snapshots();
  }

  //Identifica el nombre de la planta con mayor número de riegos registrados.
  Future<String> obtenerPlantaMasRegada() async {
    final plantas = await obtenerTodasLasPlantas();
    String nombre = "-";
    int mayor = 0;
    for (final doc in plantas.docs) {
      final planta = Planta.fromMap(
        doc.data() as Map<String, dynamic>,
      );
      final cantidad =
      await obtenerCantidadRiegosPlanta(planta.id);
      if (cantidad > mayor) {
        mayor = cantidad;
        nombre = planta.nombre;
      }
    }
    return nombre;
  }
}
