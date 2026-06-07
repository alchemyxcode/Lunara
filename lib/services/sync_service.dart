// LunaFlow - Sync Service
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0

import 'dart:convert';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'database_service.dart';
import 'settings_service.dart';

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
      debug: false,
    );
  }

  // Test the WebDAV connection
  Future<bool> testConnection() async {
    try {
      final client = await _getClient();
      await client.ping();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Create LunaFlow folder on Nextcloud if it doesn't exist
  Future<void> _ensureFolder(webdav.Client client) async {
    try {
      await client.mkdir('LunaFlow');
    } catch (e) {
      // Folder may already exist, that's fine
    }
  }

  // Export all data to JSON and upload to Nextcloud
  Future<bool> syncToCloud() async {
    try {
      final client = await _getClient();
      await _ensureFolder(client);

      // Get all data from local database
      final cycles = await DatabaseService.instance.getAllCycles();
      final logs = await DatabaseService.instance.getAllLogs();

      // Build symptoms for each log
      final List<Map<String, dynamic>> logsWithSymptoms = [];
      for (final log in logs) {
        final symptoms = await DatabaseService.instance
            .getSymptomsForLog(log['id'] as int);
        logsWithSymptoms.add({
          ...log,
          'symptoms': symptoms,
        });
      }

      // Create the export object
      final exportData = {
        'exported_at': DateTime.now().toIso8601String(),
        'version': '1.0.0',
        'cycles': cycles,
        'logs': logsWithSymptoms,
      };

      // Convert to JSON
      final jsonString = jsonEncode(exportData);
      final bytes = utf8.encode(jsonString);

      // Upload to Nextcloud
      await client.write(
        'LunaFlow/lunaflow_data.json',
        bytes,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // Download and import data from Nextcloud
  Future<bool> syncFromCloud() async {
    try {
      final client = await _getClient();

      final bytes = await client.read('LunaFlow/lunaflow_data.json');
      final jsonString = utf8.decode(bytes);
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      // Data is available — in future we'll merge it with local
      // For now just confirm it's readable
      return data.containsKey('cycles') && data.containsKey('logs');
    } catch (e) {
      return false;
    }
  }
}
