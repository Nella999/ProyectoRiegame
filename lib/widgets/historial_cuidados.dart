import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewmodels/planta_viewmodel.dart';

//Utiliza un StreamBuilder para actualizarse automáticamente cuando se registra un nuevo riego.
class HistorialCuidados extends StatelessWidget {
  final String plantaId;

  const HistorialCuidados({
    super.key,
    required this.plantaId,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = PlantaViewModel();

    return StreamBuilder<QuerySnapshot>(
      stream: viewModel.obtenerRiegos(plantaId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error cargando historial.");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Text(
            "No existen riegos registrados.",
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final fecha =
            (docs[index]["fecha"] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                ),
                title: const Text("Riego registrado"),
                subtitle: Text(
                  "${fecha.day}/${fecha.month}/${fecha.year}  "
                      "${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}",
                ),
              ),
            );
          },
        );
      },
    );
  }
}