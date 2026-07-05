import 'package:flutter/material.dart';
import '../viewmodels/planta_viewmodel.dart';
/// Tarjeta que muestra un resumen general de la aplicación.
class EstadisticasCard extends StatelessWidget {
  final PlantaViewModel viewModel;

  const EstadisticasCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: Future.wait([
        viewModel.obtenerCantidadPlantas(),
        viewModel.obtenerCantidadRiegos(),
        viewModel.obtenerPlantasQueNecesitanRiego(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final estadisticas = snapshot.data!;
        final plantas = estadisticas[0];
        final riegos = estadisticas[1];
        final necesitan = estadisticas[2];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📊 Resumen",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text("🌱 Plantas registradas: $plantas"),
                const SizedBox(height: 8),
                Text("💧 Riegos registrados: $riegos"),
                const SizedBox(height: 8),
                Text("🚨 Necesitan riego: $necesitan"),
              ],
            ),
          ),
        );
      },
    );
  }
}