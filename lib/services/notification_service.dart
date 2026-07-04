import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Servicio encargado de mostrar notificaciones locales.
class NotificationService {

  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Inicializa las notificaciones.
  Future<void> init() async {

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  /// Muestra una notificación inmediata.
  Future<void> mostrarNotificacion({
    required String titulo,
    required String mensaje,
  }) async {

    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'riegame_channel',
      'Recordatorios',
      channelDescription: 'Recordatorios de riego',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(
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