import 'package:flutter/material.dart';
import '../viewmodels/gemini_viewmodel.dart';

//Pantalla que permite al usuario interactuar con la IA de Gemini.
//Enfocada exclusivamente en resolver dudas sobre el cuidado botánico.
class ConsultaIA extends StatefulWidget {
  const ConsultaIA({super.key});

  @override
  State<ConsultaIA> createState() => _ConsultaIAState();
}

class _ConsultaIAState extends State<ConsultaIA> {
  // Controlador para el campo de texto de la pregunta.
  final TextEditingController preguntaController = TextEditingController();
  
  // Instancia del ViewModel que maneja la comunicación con Gemini.
  final GeminiViewModel viewModel = GeminiViewModel();
  
  String respuesta = "";
  bool cargando = false;

  @override
  void dispose() {
    preguntaController.dispose();
    super.dispose();
  }

  //Ejecuta la consulta a la IA validando primero que el campo no esté vacío.
  Future<void> consultar() async {
    if (preguntaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe una pregunta primero.")),
      );
      return;
    }

    setState(() {
      cargando = true;
      respuesta = "";
    });

    // Llamada al ViewModel para obtener la respuesta de la IA.
    final resultado = await viewModel.consultar(
      preguntaController.text.trim(),
    );

    setState(() {
      respuesta = resultado;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta con IA"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView( // Añadido para evitar desbordamientos en pantallas pequeñas
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.smart_toy, size: 80, color: Colors.green),
              const SizedBox(height: 15),
              const Text(
                "Pregunta cualquier duda sobre el cuidado de tus plantas.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              
              // Card con ejemplos de uso para guiar al usuario.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Puedes preguntar:", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("• ¿Cada cuánto debo regar un cactus?"),
                      Text("• Mi planta tiene hojas amarillas"),
                      Text("• ¿Necesita mucho sol una orquídea?"),
                      Text("• ¿Cómo elimino pulgones?"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Entrada de texto multilínea para la consulta.
              TextField(
                controller: preguntaController,
                maxLines: 3,
                maxLength: 300,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  labelText: "Escribe tu pregunta",
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 12),

              // Botón de envío que se deshabilita mientras la IA responde.
              ElevatedButton.icon(
                onPressed: cargando ? null : consultar,
                icon: const Icon(Icons.send),
                label: const Text("Consultar IA"),
              ),

              const SizedBox(height: 25),
              
              // Indicador de progreso durante la espera.
              if (cargando)
                const Center(child: CircularProgressIndicator()),
              
              // Muestra la respuesta en una tarjeta con scroll independiente si es larga.
              if (!cargando && respuesta.isNotEmpty)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.smart_toy, color: Colors.green),
                            SizedBox(width: 8),
                            Text("Respuesta de la IA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          ],
                        ),
                        const Divider(),
                        Text(respuesta, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
