import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance =
  NotificationService._();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Inicializa las notificaciones
  Future<void> init() async {
    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(
      android: androidSettings,
    );
    await notificationsPlugin.initialize(
      settings: settings,
    );
  }

  //Solicita permiso (Android 13+)
  Future<void> solicitarPermiso() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Muestra una notificación
  Future<void> mostrarNotificacion({
    required String titulo,
    required String mensaje,
  }) async {

    print("Entró a mostrarNotificacion");
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

    print("Notificación enviada");
  }
}