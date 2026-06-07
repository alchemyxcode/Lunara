// LunaFlow - Settings Service
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService instance = SettingsService._internal();
  SettingsService._internal();

  static const String _keyName = 'user_name';
  static const String _keyWebdavUrl = 'webdav_url';
  static const String _keyWebdavUser = 'webdav_user';
  static const String _keyWebdavPass = 'webdav_pass';
  static const String _keySyncEnabled = 'sync_enabled';
  static const String _keyAiEnabled = 'ai_enabled';
  static const String _keyAiProvider = 'ai_provider';
  static const String _keyAiApiKey = 'ai_api_key';
  static const String _keyAiEndpoint = 'ai_endpoint';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyReminderHour = 'reminder_hour';
  static const String _keyReminderMinute = 'reminder_minute';

  Future<void> saveAll({
    required String name,
    required String webdavUrl,
    required String webdavUser,
    required String webdavPass,
    required bool syncEnabled,
    required bool aiEnabled,
    required String aiProvider,
    required String aiApiKey,
    required String aiEndpoint,
    required bool notificationsEnabled,
    required int reminderHour,
    required int reminderMinute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyWebdavUrl, webdavUrl);
    await prefs.setString(_keyWebdavUser, webdavUser);
    await prefs.setString(_keyWebdavPass, webdavPass);
    await prefs.setBool(_keySyncEnabled, syncEnabled);
    await prefs.setBool(_keyAiEnabled, aiEnabled);
    await prefs.setString(_keyAiProvider, aiProvider);
    await prefs.setString(_keyAiApiKey, aiApiKey);
    await prefs.setString(_keyAiEndpoint, aiEndpoint);
    await prefs.setBool(_keyNotificationsEnabled, notificationsEnabled);
    await prefs.setInt(_keyReminderHour, reminderHour);
    await prefs.setInt(_keyReminderMinute, reminderMinute);
  }

  Future<Map<String, dynamic>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyName) ?? 'Deanna',
      'webdav_url': prefs.getString(_keyWebdavUrl) ?? 'https://cloud.disroot.org/remote.php/dav/files/USERNAME/LunaFlow/',
      'webdav_user': prefs.getString(_keyWebdavUser) ?? '',
      'webdav_pass': prefs.getString(_keyWebdavPass) ?? '',
      'sync_enabled': prefs.getBool(_keySyncEnabled) ?? false,
      'ai_enabled': prefs.getBool(_keyAiEnabled) ?? false,
      'ai_provider': prefs.getString(_keyAiProvider) ?? 'Anthropic',
      'ai_api_key': prefs.getString(_keyAiApiKey) ?? '',
      'ai_endpoint': prefs.getString(_keyAiEndpoint) ?? '',
      'notifications_enabled': prefs.getBool(_keyNotificationsEnabled) ?? false,
      'reminder_hour': prefs.getInt(_keyReminderHour) ?? 20,
      'reminder_minute': prefs.getInt(_keyReminderMinute) ?? 0,
    };
  }

  Future<String> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName) ?? 'Deanna';
  }

  Future<String> getAiApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAiApiKey) ?? '';
  }

  Future<String> getAiProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAiProvider) ?? 'Anthropic';
  }

  Future<String> getAiEndpoint() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAiEndpoint) ?? '';
  }

  Future<bool> isSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySyncEnabled) ?? false;
  }

  Future<bool> isAiEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAiEnabled) ?? false;
  }

  Future<String> getWebdavUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWebdavUrl) ?? '';
  }

  Future<String> getWebdavUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWebdavUser) ?? '';
  }

  Future<String> getWebdavPass() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyWebdavPass) ?? '';
  }

  Future<bool> isNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? false;
  }

  Future<TimeOfDay> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return TimeOfDay(
      hour: prefs.getInt(_keyReminderHour) ?? 20,
      minute: prefs.getInt(_keyReminderMinute) ?? 0,
    );
  }
}
