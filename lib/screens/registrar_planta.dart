import 'package:flutter/material.dart';
import '../models/planta.dart';
//import '../providers/planta_provider.dart'; ya no se hace uso de este import
import '../viewmodels/planta_viewmodel.dart';

class registrar_planta extends StatefulWidget {
  const registrar_planta({super.key});

  @override
  State<registrar_planta> createState() => registrar_plantaState();
}

class registrar_plantaState extends State<registrar_planta> {

  final nombreController = TextEditingController();
  final apodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final frecuenciaController = TextEditingController();
  final PlantaViewModel viewModel = PlantaViewModel(); // Agregando instancia de servicio

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

            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre de la planta",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: apodoController,
              decoration: const InputDecoration(
                labelText: "Apodo de la planta",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: observacionesController,
              decoration: const InputDecoration(
                labelText: "Observaciones",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: frecuenciaController,
              keyboardType: TextInputType.number, // Se abre el teclado numerico
              decoration: const InputDecoration(
                labelText: "Frecuencia de riego (días)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () async  { //Acciones cuando el usuario selecciona algo

                  //El usuario no puede dejar espacios vacíos
                  if (nombreController.text.isEmpty || frecuenciaController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Completar los campos obligatorios porfavor"),
                      ),
                    );
                    return;
                  }

                  Planta newPlanta = Planta(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nombre: nombreController.text,
                    apodo: apodoController.text,
                    observaciones: observacionesController.text,
                    frecuenciaDias: int.tryParse(frecuenciaController.text) ?? 0, //Modificando el tipo de dato a entero
                  );

                  //PlantaProvider.plantas.add(newPlanta);
                  await viewModel.registrarPlanta(newPlanta); //esperar a que termine para continuar

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