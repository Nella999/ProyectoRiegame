import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../services/firestore_service.dart';
import '../viewmodels/planta_viewmodel.dart';

class EditarPlanta extends StatefulWidget {
  final Planta planta;
  // constructor para editar
  const EditarPlanta({
    super.key,
    required this.planta,
  });

  @override
  State<EditarPlanta> createState() => _EditarPlantaState();
}

class _EditarPlantaState extends State<EditarPlanta> {
  final nombreController = TextEditingController();
  final apodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final frecuenciaController = TextEditingController();
  final viewModel = PlantaViewModel();

  @override
  void initState() {
    super.initState();

    nombreController.text = widget.planta.nombre;
    apodoController.text = widget.planta.apodo;
    observacionesController.text = widget.planta.observaciones;
    frecuenciaController.text =
        widget.planta.frecuenciaDias.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Planta"),
      ),
      // Cuerpo de la pantalla (Se reutiliza el formulario de registrar_planta)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                  labelText: "Apodo",
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Frecuencia de riego (días)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

            //Actualizando información de la planta
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Planta plantaActualizada = Planta(
                      id: widget.planta.id,
                      nombre: nombreController.text,
                      apodo: apodoController.text,
                      observaciones: observacionesController.text,
                      frecuenciaDias:
                      int.tryParse(frecuenciaController.text) ?? 0,
                    );

                    await viewModel.actualizarPlanta(plantaActualizada);                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Se actualizó tu planta correctamente 🌱"),
                      ),
                    );

                    Navigator.pop(context);

                  },
                  child: const Text("Guardar cambios"),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}