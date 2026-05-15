import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/solar_forecast.dart';
import 'solar_recommendation_service.dart';

class SolarNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'solar_recommendations';
  static const String _channelName = 'Solar recommendations';
  static const String _channelDescription =
      'Alerts for high solar production windows.';

  static String? _lastScheduleKey;

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    tz.initializeTimeZones();

    await _plugin.initialize(settings: initSettings);
    await _requestPermissions();
  }

  static Future<void> scheduleForForecast(
    ForecastData forecastData, {
    Duration preAlertLeadTime = const Duration(hours: 12),
    int topHours = SolarRecommendationService.defaultTopHours,
  }) async {
    final recommendation = SolarRecommendationService.buildRecommendation(
      forecastData,
      topHours: topHours,
    );

    if (recommendation == null) {
      return;
    }

    final scheduleKey =
        '${recommendation.start.toIso8601String()}|${recommendation.end.toIso8601String()}';
    if (_lastScheduleKey == scheduleKey) {
      return;
    }
    _lastScheduleKey = scheduleKey;

    await _plugin.cancelAll();

    final preAlertTime = recommendation.start.subtract(preAlertLeadTime);

    final startLabel = _formatWindowTime(recommendation.start);
    final endLabel = _formatWindowTime(recommendation.end);

    await _scheduleIfFuture(
      id: 100,
      scheduledTime: preAlertTime,
      title: 'Plan high-energy tasks',
      body: 'Best window starts at $startLabel. Prep appliances tonight.',
    );

    await _scheduleIfFuture(
      id: 101,
      scheduledTime: recommendation.start,
      title: 'High solar production started',
      body: 'Optimal window is now. Best until $endLabel.',
    );

    await _scheduleIfFuture(
      id: 102,
      scheduledTime: recommendation.end,
      title: 'High solar production ending',
      body: 'Optimal window ends at $endLabel. Wrap up energy-heavy tasks.',
    );
  }

  static Future<void> _scheduleIfFuture({
    required int id,
    required DateTime scheduledTime,
    required String title,
    required String body,
  }) async {
    if (!scheduledTime.isAfter(DateTime.now())) {
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: title,
      body: body,
    );
  }

  static NotificationDetails _notificationDetails() {
    const android = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
    );
    const iOS = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(android: android, iOS: iOS);
  }

  static Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

  static String _formatWindowTime(DateTime time) {
    final formatter = DateFormat('EEE HH:mm');
    return formatter.format(time);
  }
}
