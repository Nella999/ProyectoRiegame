import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import 'editar_planta.dart';
import '../services/notification_service.dart';

class DetallePlanta extends StatelessWidget {
  final Planta planta;
  final PlantaViewModel viewModel = PlantaViewModel();

  DetallePlanta({
    super.key,
    required this.planta,
  });

  Widget _buildHistorialRiegos() {//Historial de riego
    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.obtenerRiegos(planta.id),
      builder: (context, snapshot) {

        // Mientras carga la información
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // En caso de errores
        if (snapshot.hasError) {
          return const Text(
            "Ocurrió un error al cargar el historial.",
          );
        }
        // Si no se registro riego alguno
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text(
            "Aún no hay riegos registrados.",
          );
        }
        final riegos = snapshot.data!.docs;
        // Se muestran todos los riegos registrados
        return Column(
          children: riegos.map((riego) {
            final fecha =
            (riego["fecha"] as Timestamp).toDate();
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                ),
                title: Text(
                  "${fecha.day}/${fecha.month}/${fecha.year}",
                ),
                subtitle: Text(
                  "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}",
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planta.nombre),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Center(
                child: Icon(//icono principal
                  Icons.local_florist,
                  size: 90,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 30),

              //información general de la planta
              Text(
                "Nombre",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(planta.nombre),

              const SizedBox(height: 20),
              Text(
                "Apodo",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(planta.apodo),
              const SizedBox(height: 20),

              Text(
                "Observaciones",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(planta.observaciones),
              const SizedBox(height: 20),

              Text(
                "Frecuencia",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Cada ${planta.frecuenciaDias} días",
              ),
              const SizedBox(height: 25),

              //Información de riego
              FutureBuilder<DateTime?>(
                future: viewModel.obtenerUltimoRiego(planta.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text(
                      "No existen riegos registrados.",
                    );
                  }
                  final ultimoRiego = snapshot.data!;
                  final proximo =
                  viewModel.calcularProximoRiego(
                    ultimoRiego,
                    planta.frecuenciaDias,
                  );
                  final necesita =
                  viewModel.necesitaRiego(
                    ultimoRiego,
                    planta.frecuenciaDias,
                  );
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Último riego:",
                            style:
                            Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "${ultimoRiego.day}/${ultimoRiego.month}/${ultimoRiego.year}",
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Próximo riego:",
                            style:
                            Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "${proximo.day}/${proximo.month}/${proximo.year}",
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Icon(
                                necesita
                                    ? Icons.warning
                                    : Icons.check_circle,
                                color: necesita
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                necesita
                                    ? "Debes regarla"
                                    : "No necesita agua",
                                style: TextStyle(
                                  color: necesita
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Divider(),//historial de riegos
              const SizedBox(height: 15),
              Text(
                "Historial de riegos",
                style:
                Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              _buildHistorialRiegos(),
              const SizedBox(height: 30),

              SizedBox(//boton para editar la planta
              width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Editar planta"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditarPlanta(
                          planta: planta,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(//boton para registrar un nuevo riego
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.water_drop),
                  label: const Text("Regué hoy"),
                  onPressed: () async {
                    await viewModel.registrarRiego(planta.id,);
                    await NotificationService.instance.mostrarNotificacion(
                      titulo: "¡Riégame! ☀️🌱",
                      mensaje: "El riego de ${planta.nombre} fue registrado correctamente.",
                    );

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          "¡Riego registrado correctamente! 💧",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}