// LunaFlow - Notification Service
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyLogReminderId = 1;

  Future<void> init() async {
    tz_data.initializeTimeZones();

    // Use the device's actual timezone
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(settings: const InitializationSettings(android: android));

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> sendTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'lunaflow_log_reminder',
      'Daily Log Reminder',
      channelDescription: 'Reminds you to log your symptoms each day',
      importance: Importance.max,
      priority: Priority.high,
    );
    await _plugin.show(
      id: 99,
      title: '🌙 Test notification',
      body: 'Notifications are working!',
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }

  Future<void> scheduleDailyLogReminder(TimeOfDay time) async {
    await _plugin.cancel(id: _dailyLogReminderId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'lunaflow_log_reminder',
      'Daily Log Reminder',
      channelDescription: 'Reminds you to log your symptoms each day',
      importance: Importance.max,
      priority: Priority.high,
    );

    await _plugin.zonedSchedule(
      id: _dailyLogReminderId,
      title: '🌙 Time to log!',
      body: 'How are you feeling today? Tap to open LunaFlow.',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyLogReminder() async {
    await _plugin.cancel(id: _dailyLogReminderId);
  }
}
