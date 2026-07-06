import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//Servicio encargado de gestionar las notificaciones locales en el dispositivo.
class NotificationService {
  // Constructor privado para el Singleton.
  NotificationService._();
  static final NotificationService instance = NotificationService._();
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  //Configura los ajustes iniciales para las notificaciones.
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: androidSettings,
    );
    await notificationsPlugin.initialize(
      settings: settings,
    );
  }

  //Solicita explícitamente permisos al usuario para mostrar notificaciones
  Future<void> solicitarPermiso() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> mostrarNotificacion({
    required String titulo,
    required String mensaje,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'riegame_channel',
      'Recordatorios',
      channelDescription: 'Recordatorios de riego y cuidados',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    
    await notificationsPlugin.show(
      id: 0,
      title: titulo,
      body: mensaje,
      notificationDetails: notificationDetails,
    );
  }
}
