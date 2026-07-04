import 'package:flutter/material.dart';
import '../models/planta.dart';
import 'editar_planta.dart';
import '../viewmodels/planta_viewmodel.dart';

class DetallePlanta extends StatelessWidget {
  final Planta planta;
  final PlantaViewModel viewModel = PlantaViewModel();

   DetallePlanta({
    super.key,
    required this.planta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(planta.nombre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Icon(
              Icons.local_florist,
              size: 80,
              color: Colors.green,
            ),
            const SizedBox(height: 25),

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
            const Spacer(),

            SizedBox( //Boton para editar planta
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
            SizedBox(//Botón para registrar riego
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.water_drop),
                label: const Text("Regué hoy"),
                onPressed: () async {
                  await viewModel.registrarRiego(planta.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("¡Riego registrado correctamente! 💧"),
                    ),
                  );

                },

              ),
            ),
          ],
        ),
      ),
    );
  }

}