import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/inicio.dart';
import 'services/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//Punto de entrada principal de la aplicación.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carga las variables de entorno
  await dotenv.load(fileName: ".env");
  
  // Inicializa la conexión con Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configuración inicial de notificaciones locales y solicitud de permisos.
  await NotificationService.instance.init();
  await NotificationService.instance.solicitarPermiso();
  
  runApp(const RiegameApp());
}

class RiegameApp extends StatelessWidget {
  const RiegameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '¡Riégame!',
      // Define el tema global basado en el color verde
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      // La pantalla inicial es el dashboard de plantas.
      home: const Inicio(),
    );
  }
}
