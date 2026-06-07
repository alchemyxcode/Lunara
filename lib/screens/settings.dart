// LunaFlow - Settings Screen
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0

import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/sync_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _webdavUrlController = TextEditingController();
  final _webdavUserController = TextEditingController();
  final _webdavPassController = TextEditingController();
  final _aiEndpointController = TextEditingController();
  final _aiApiKeyController = TextEditingController();
  String _aiProvider = 'Anthropic';
  bool _syncEnabled = false;
  bool _aiEnabled = false;
  bool _notificationsEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  bool _obscurePass = true;
  bool _obscureKey = true;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isTesting = false;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.instance.loadAll();
    setState(() {
      _nameController.text = settings['name'];
      _webdavUrlController.text = settings['webdav_url'];
      _webdavUserController.text = settings['webdav_user'];
      _webdavPassController.text = settings['webdav_pass'];
      _syncEnabled = settings['sync_enabled'];
      _aiEnabled = settings['ai_enabled'];
      _aiProvider = settings['ai_provider'];
      _aiApiKeyController.text = settings['ai_api_key'];
      _aiEndpointController.text = settings['ai_endpoint'];
      _notificationsEnabled = settings['notifications_enabled'];
      _reminderTime = TimeOfDay(
        hour: settings['reminder_hour'],
        minute: settings['reminder_minute'],
      );
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    try {
      await SettingsService.instance.saveAll(
        name: _nameController.text,
        webdavUrl: _webdavUrlController.text,
        webdavUser: _webdavUserController.text,
        webdavPass: _webdavPassController.text,
        syncEnabled: _syncEnabled,
        aiEnabled: _aiEnabled,
        aiProvider: _aiProvider,
        aiApiKey: _aiApiKeyController.text,
        aiEndpoint: _aiEndpointController.text,
        notificationsEnabled: _notificationsEnabled,
        reminderHour: _reminderTime.hour,
        reminderMinute: _reminderTime.minute,
      );

      // Schedule or cancel notification based on toggle
      if (_notificationsEnabled) {
        await NotificationService.instance.scheduleDailyLogReminder(_reminderTime);
      } else {
        await NotificationService.instance.cancelDailyLogReminder();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings saved! 🌙'),
            backgroundColor: Color(0xFF7B4F9E),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _testConnection() async {
    await _saveSettings();
    setState(() => _isTesting = true);
    try {
      final success = await SyncService.instance.testConnection();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Connected to Disroot! ✅'
                : 'Connection failed ❌ Check your credentials'),
            backgroundColor: success ? const Color(0xFF7B4F9E) : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isTesting = false);
    }
  }

  Future<void> _syncNow() async {
    setState(() => _isSyncing = true);
    try {
      final success = await SyncService.instance.syncToCloud();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Synced to Disroot! ✅' : 'Sync failed ❌ Try again'),
            backgroundColor: success ? const Color(0xFF7B4F9E) : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _webdavUrlController.dispose();
    _webdavUserController.dispose();
    _webdavPassController.dispose();
    _aiEndpointController.dispose();
    _aiApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profile
            Text('Profile', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 32),

            // Notifications
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: _notificationsEnabled,
                  activeColor: const Color(0xFF7B4F9E),
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Daily reminder to log your symptoms',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),

            if (_notificationsEnabled) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text('Reminder time'),
                subtitle: Text(_reminderTime.format(context)),
                trailing: TextButton(
                  onPressed: _pickReminderTime,
                  child: const Text('Change'),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Sync
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Disroot / Nextcloud Sync',
                    style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: _syncEnabled,
                  activeColor: const Color(0xFF7B4F9E),
                  onChanged: (val) => setState(() => _syncEnabled = val),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Sync your data to your own Nextcloud',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),

            if (_syncEnabled) ...[
              TextField(
                controller: _webdavUrlController,
                decoration: InputDecoration(
                  labelText: 'WebDAV URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _webdavUserController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _webdavPassController,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isTesting ? null : _testConnection,
                      icon: _isTesting
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.wifi_tethering),
                      label: Text(_isTesting ? 'Testing...' : 'Test'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isSyncing ? null : _syncNow,
                      icon: _isSyncing
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.cloud_upload),
                      label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF7B4F9E)),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // AI Agent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('AI Health Agent',
                    style: Theme.of(context).textTheme.titleMedium),
                Switch(
                  value: _aiEnabled,
                  activeColor: const Color(0xFF7B4F9E),
                  onChanged: (val) => setState(() => _aiEnabled = val),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Connect to your AI agent for health insights',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),

            if (_aiEnabled) ...[
              DropdownButtonFormField<String>(
                value: _aiProvider,
                decoration: InputDecoration(
                  labelText: 'AI Provider',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.auto_awesome_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'Anthropic', child: Text('Anthropic (Claude)')),
                  DropdownMenuItem(value: 'Ollama', child: Text('Ollama (Self-hosted)')),
                  DropdownMenuItem(value: 'Custom', child: Text('Custom endpoint')),
                ],
                onChanged: (val) => setState(() => _aiProvider = val!),
              ),
              const SizedBox(height: 12),
              if (_aiProvider == 'Anthropic') ...[
                TextField(
                  controller: _aiApiKeyController,
                  obscureText: _obscureKey,
                  decoration: InputDecoration(
                    labelText: 'Anthropic API Key',
                    hintText: 'sk-ant-...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureKey ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    ),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _aiEndpointController,
                  decoration: InputDecoration(
                    labelText: _aiProvider == 'Ollama'
                        ? 'Ollama URL (e.g. http://192.168.1.x:11434)'
                        : 'Custom endpoint URL',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.computer),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Testing AI connection... 🤖')),
                    );
                  },
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Test AI Connection'),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Save
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveSettings,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Settings'),
              ),
            ),

            const SizedBox(height: 32),

            // About
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LunaFlow v1.0.0'),
                    const SizedBox(height: 4),
                    const Text('Licensed under GNU GPL v3.0'),
                    const SizedBox(height: 4),
                    Text(
                      'Built by @alchemyxcode with assistance from Claude by Anthropic',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
