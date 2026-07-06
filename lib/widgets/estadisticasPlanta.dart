import 'package:flutter/material.dart';
import '../viewmodels/planta_viewmodel.dart';
//Incluye riegos semanales/mensuales, horas de sol y porcentaje de cumplimiento.
class EstadisticasPlanta extends StatelessWidget {
  final String plantaId; // ID de la planta para consultar sus datos.

  const EstadisticasPlanta({
    super.key,
    required this.plantaId,
  });

  @override
  Widget build(BuildContext context) {

    final viewModel = PlantaViewModel();

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        viewModel.obtenerRiegosSemana(plantaId),
        viewModel.obtenerRiegosMes(plantaId),
        viewModel.obtenerHorasSol(plantaId),
        viewModel.obtenerPorcentajeCumplimiento(plantaId),
      ]),

      builder: (context,snapshot){
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final semana = snapshot.data![0] as int;
        final mes = snapshot.data![1] as int;
        final sol = snapshot.data![2] as int;
        final porcentaje = snapshot.data![3] as int;

        return Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📊 Estadísticas de esta planta",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height:20),
                Text("💧 Riegos esta semana: $semana"),
                const SizedBox(height:8),
                Text("📅 Riegos este mes: $mes"),
                const SizedBox(height:8),
                Text("☀️ Horas de sol: $sol"),
                const SizedBox(height:8),
                Text("✅ Recordatorios cumplidos: $porcentaje %"),
              ],
            ),
          ),
        );
      },
    );
  }
}