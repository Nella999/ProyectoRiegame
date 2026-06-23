import 'package:flutter/material.dart';

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
              decoration: const InputDecoration(
                labelText: "Frecuencia de riego",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                print("Nombre: ${nombreController.text}");
                print("Apodo: ${apodoController.text}");
                print("Observaciones: ${observacionesController.text}");
                print("Frecuencia: ${frecuenciaController.text}");

              },
              child: const Text("Guardar"),
            ),

          ],
        ),
      ),
    );
  }
}