import '../services/gemini_service.dart';

//Netodo encargado de la conexion de IA con el servicio de Gemini.
class GeminiViewModel {
  final GeminiService _service = GeminiService();

  //Procesa la consulta del usuario.
  Future<String> consultar(String pregunta) async {
    if (pregunta.trim().isEmpty) {
      return "Escribe una pregunta válida.";
    }

    // Llama al servicio para obtener la respuesta generada.
    return await _service.consultarIA(pregunta);
  }
}
