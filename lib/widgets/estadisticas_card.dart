import 'package:flutter/material.dart';
import '../viewmodels/planta_viewmodel.dart';
import 'estadisticas_chart.dart';

/// Muestra conteos totales y una gráfica comparativa de la salud del jardín.
class EstadisticasCard extends StatelessWidget {
  final PlantaViewModel viewModel;

  const EstadisticasCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos Future.wait para cargar múltiples métricas asíncronas de forma simultánea.
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        viewModel.obtenerCantidadPlantas(),
        viewModel.obtenerCantidadRiegos(),
        viewModel.obtenerPlantasQueNecesitanRiego(),
        viewModel.obtenerPlantaMasRegada(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text("Error al cargar estadísticas"),
            ),
          );
        }

        final estadisticas = snapshot.data!;
        final plantas = estadisticas[0] as int;
        final riegos = estadisticas[1] as int;
        final necesitan = estadisticas[2] as int;
        final masRegada = estadisticas[3] as String;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📊 Resumen del Jardín",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildStatRow(Icons.eco, "Plantas registradas", "$plantas"),
                _buildStatRow(Icons.water_drop, "Riegos realizados", "$riegos"),
                _buildStatRow(Icons.warning, "Necesitan atención", "$necesitan", color: Colors.red),
                _buildStatRow(Icons.emoji_events, "Planta más cuidada", masRegada),

                const SizedBox(height: 25),
                // Gráfica circular que visualiza los datos numéricos.
                EstadisticasChart(
                  plantas: plantas,
                  riegos: riegos,
                  necesitan: necesitan,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? Colors.green),
          const SizedBox(width: 8),
          Text("$label: "),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
