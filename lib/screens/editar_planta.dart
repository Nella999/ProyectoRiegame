import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';

//Pantalla que permite modificar los datos de una planta ya registrada.
class EditarPlanta extends StatefulWidget {
  final Planta planta;
  const EditarPlanta({
    super.key,
    required this.planta,
  });

  @override
  State<EditarPlanta> createState() => _EditarPlantaState();
}

class _EditarPlantaState extends State<EditarPlanta> {
  // Controladores de texto para los campos del formulario.
  final nombreController = TextEditingController();
  final apodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final frecuenciaController = TextEditingController();
  final horasSolController = TextEditingController();

  final viewModel = PlantaViewModel();

  @override
  void initState() {
    super.initState();
    // Inicialización de los controladores con los valores actuales de la planta.
    nombreController.text = widget.planta.nombre;
    apodoController.text = widget.planta.apodo;
    observacionesController.text = widget.planta.observaciones;
    frecuenciaController.text = widget.planta.frecuenciaDias.toString();
    horasSolController.text = widget.planta.horasSol.toString();
  }

  @override
  void dispose() {
    // Liberación de recursos.
    nombreController.dispose();
    apodoController.dispose();
    observacionesController.dispose();
    frecuenciaController.dispose();
    horasSolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Planta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Campos de entrada ---
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
              TextField(
                controller: horasSolController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Cantidad horas al sol recomendadas",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Botón para guardar los cambios
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Creación del nuevo objeto planta con los datos editados.
                    Planta plantaActualizada = Planta(
                      id: widget.planta.id, // Mantenemos el mismo ID
                      nombre: nombreController.text,
                      apodo: apodoController.text,
                      observaciones: observacionesController.text,
                      frecuenciaDias: int.tryParse(frecuenciaController.text) ?? 0,
                      horasSol: int.tryParse(horasSolController.text) ?? 0,
                    );

                    await viewModel.actualizarPlanta(plantaActualizada);
                    
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Se actualizó tu planta correctamente 🌱"),
                      ),
                    );
                    Navigator.pop(context); // Volver al detalle
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
