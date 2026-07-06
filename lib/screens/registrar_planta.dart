import 'package:flutter/material.dart';
import '../models/planta.dart';
import '../viewmodels/planta_viewmodel.dart';
import '../widgets/campo_texto.dart';

//Pantalla que permite al usuario registrar una nueva planta en su colección.
class RegistrarPlanta extends StatefulWidget {
  const RegistrarPlanta({super.key});

  @override
  State<RegistrarPlanta> createState() => RegistrarPlantaState();
}

class RegistrarPlantaState extends State<RegistrarPlanta> {
  // Controladores para capturar el texto de los campos de entrada.
  final nombreController = TextEditingController();
  final apodoController = TextEditingController();
  final observacionesController = TextEditingController();
  final frecuenciaController = TextEditingController();
  final horasSolController = TextEditingController();

  // Instancia del ViewModel para procesar el registro.
  final PlantaViewModel viewModel = PlantaViewModel();

  @override
  void dispose() {
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
        title: const Text("Registra tu nueva Planta"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
              CampoTexto(
                controller: horasSolController,
                label: "Horas de exposición solar",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Creación del objeto Planta con los datos del formulario.
                    final newPlanta = Planta(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nombre: nombreController.text,
                      apodo: apodoController.text,
                      observaciones: observacionesController.text,
                      frecuenciaDias: int.tryParse(frecuenciaController.text) ?? 0,
                      horasSol: int.tryParse(horasSolController.text) ?? 0,
                    );

                    // Envío al ViewModel para validación y registro.
                    final resultado = await viewModel.registrarPlanta(newPlanta);
                    
                    if (resultado != null) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(resultado)),
                      );
                      return;
                    }

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("¡Tu planta se registró correctamente! 🌱"),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar Planta"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
