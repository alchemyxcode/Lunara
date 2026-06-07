// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0
import 'dart:convert';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'database_service.dart';
import 'settings_service.dart';
import 'encryption_service.dart';

class SyncService {
  static final SyncService instance = SyncService._internal();
  SyncService._internal();

  Future<webdav.Client> _getClient() async {
    final url = await SettingsService.instance.getWebdavUrl();
    final user = await SettingsService.instance.getWebdavUser();
    final pass = await SettingsService.instance.getWebdavPass();
    return webdav.newClient(
      url,
      user: user,
      password: pass,
      debug: true,
    );
  }

  Future<bool> testConnection() async {
    try {
      final client = await _getClient();
      await client.ping();
      return true;
    } catch (e) {
      print('Connection error: $e');
      return false;
    }
  }

  Future<void> _ensureFolder(webdav.Client client) async {
    try {
      await client.mkdir('data');
    } catch (e) {
      // Folder may already exist, that's fine
    }
  }

  Future<bool> syncToCloud() async {
    try {
      final client = await _getClient();
      await _ensureFolder(client);

      final cycles = await DatabaseService.instance.getAllCycles();
      final logs = await DatabaseService.instance.getAllLogs();

      final List<Map<String, dynamic>> logsWithSymptoms = [];
      for (final log in logs) {
        final symptoms = await DatabaseService.instance
            .getSymptomsForLog(log['id'] as int);
        logsWithSymptoms.add({
          ...log,
          'symptoms': symptoms,
        });
      }

      final exportData = {
        'exported_at': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'cycles': cycles,
        'logs': logsWithSymptoms,
      };

      final jsonString = jsonEncode(exportData);

      // Encrypt using the WebDAV password as the key
      final password = await SettingsService.instance.getWebdavPass();
      final encryptedString = EncryptionService.instance.encrypt(jsonString, password);
      final bytes = utf8.encode(encryptedString);

      await client.write(
        'data/lunaflow_data.enc',
        bytes,
      );

      return true;
    } catch (e) {
      print('Sync error: $e');
      return false;
    }
  }

  Future<bool> syncFromCloud() async {
    try {
      final client = await _getClient();
      final password = await SettingsService.instance.getWebdavPass();

      final bytes = await client.read('data/lunaflow_data.enc');
      final encryptedString = utf8.decode(bytes);
      final jsonString = EncryptionService.instance.decrypt(encryptedString, password);

      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      return data.containsKey('cycles') && data.containsKey('logs');
    } catch (e) {
      print('Sync from cloud error: $e');
      return false;
    }
  }
}
