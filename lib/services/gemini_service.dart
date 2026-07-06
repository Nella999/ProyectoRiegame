import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

//Servicio que integra IA (Gemini).
class GeminiService {
  // Inicialización del modelo Gemini usando la API del archivo .env
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  //Envía una consulta al modelo Gemini y retorna la respuesta procesada.
  Future<String> consultarIA(String pregunta) async {
    try {
      final prompt = """
Eres un asistente experto en el cuidado de plantas.

Responde únicamente preguntas relacionadas con:
- riego
- iluminación
- fertilización
- plagas
- enfermedades
- poda
- sustrato
- macetas
- cuidados generales

Si la pregunta no trata sobre plantas, responde únicamente:

"Solo puedo responder consultas relacionadas con el cuidado de plantas 🌱."

Pregunta:
$pregunta
""";

      final respuesta = await _model.generateContent([
        Content.text(prompt),
      ]);

      return respuesta.text ??
          "No fue posible generar una respuesta.";
    } catch (e) {
      // Manejo básico de errores de red o API
      return "Ocurrió un error al consultar la IA.";
    }
  }
}
