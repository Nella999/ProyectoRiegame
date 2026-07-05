import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance =
  NotificationService._();
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {  // Inicializa las notificaciones
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: androidSettings,
    );
    await notificationsPlugin.initialize(
      settings: settings,
    );
  }
  Future<void> solicitarPermiso() async {  //Solicita permiso para mostrar notificaciones
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> mostrarNotificacion({  // Muestra una notificación
    required String titulo,
    required String mensaje,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'riegame_channel',
      'Recordatorios',
      channelDescription: 'Recordatorios de riego',
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