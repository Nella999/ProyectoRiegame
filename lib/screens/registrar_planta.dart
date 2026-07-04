import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import '../widgets/campo_texto.dart';

class RegistrarPlanta extends StatefulWidget {
  const RegistrarPlanta({super.key});

  @override
  State<RegistrarPlanta> createState() => RegistrarPlantaState();
}

class RegistrarPlantaState extends State<RegistrarPlanta> {

  final nombreController = TextEditingController();
  final apodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final frecuenciaController = TextEditingController();
  final PlantaViewModel viewModel = PlantaViewModel(); // ViewModel se encarga de comunicarse con Firestore

  @override
  void dispose() { //Para liberar memoria
    nombreController.dispose();
    apodoController.dispose();
    observacionesController.dispose();
    frecuenciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registra tu nueva Planta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 16),
            CampoTexto(
              controller: nombreController,
              label: "Nombre de la planta",
            ),
            const SizedBox(height: 16),

            CampoTexto(
              controller: apodoController,
              label: "Apodo de la planta",
            ),
            const SizedBox(height: 16),

            CampoTexto(
              controller: observacionesController,
              label: "Observaciones",
            ),
            const SizedBox(height: 16),

            CampoTexto(
              controller: frecuenciaController,
              label: "Frecuencia de riego (días)",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () async  { //Se ejecuta al presionar el boton guardar
                  final newPlanta = Planta(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nombre: nombreController.text,
                    apodo: apodoController.text,
                    observaciones: observacionesController.text,
                    frecuenciaDias: int.tryParse(frecuenciaController.text) ?? 0, //Modificando el tipo de dato a entero
                  );

                  //PlantaProvider.plantas.add(newPlanta);
                  final resultado = await viewModel.registrarPlanta(newPlanta);
                  if (resultado != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(resultado),
                      ),
                    );
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("¡Tu planta se registró correctamente! 🌱"),
                    ),
                  );
                  Navigator.pop(context);
                },
              child: const Text("Guardar Planta"),
            ),

          ],
        ),
      ),
    );
  }
}