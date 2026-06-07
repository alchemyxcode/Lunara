// LunaFlow - Settings Screen
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController(text: 'Deanna');
  final _webdavUrlController = TextEditingController(
    text: 'https://cloud.disroot.org/remote.php/dav/files/USERNAME/LunaFlow/',
  );
  final _webdavUserController = TextEditingController();
  final _webdavPassController = TextEditingController();
  final _aiEndpointController = TextEditingController();
  final _aiApiKeyController = TextEditingController();
  String _aiProvider = 'Anthropic';
  bool _syncEnabled = false;
  bool _aiEnabled = false;
  bool _obscurePass = true;
  bool _obscureKey = true;

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

            // Profile section
            Text('Profile',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 32),

            // Sync section
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
              'Encrypt and sync your data to your own Nextcloud',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),

            if (_syncEnabled) ...[
              TextField(
                controller: _webdavUrlController,
                decoration: InputDecoration(
                  labelText: 'WebDAV URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.link),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _webdavUserController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _webdavPassController,
                obscureText: _obscurePass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePass
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Testing connection... 🌙'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.wifi_tethering),
                  label: const Text('Test Connection'),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // AI Agent section
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.auto_awesome_outlined),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Anthropic',
                    child: Text('Anthropic (Claude)'),
                  ),
                  DropdownMenuItem(
                    value: 'Ollama',
                    child: Text('Ollama (Self-hosted)'),
                  ),
                  DropdownMenuItem(
                    value: 'Custom',
                    child: Text('Custom endpoint'),
                  ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.key),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureKey
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscureKey = !_obscureKey),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                      const SnackBar(
                        content: Text('Testing AI connection... 🤖'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.science_outlined),
                  label: const Text('Test Connection'),
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved! 🌙'),
                      backgroundColor: Color(0xFF7B4F9E),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Settings'),
              ),
            ),

            const SizedBox(height: 32),

            // About section
            Text('About',
                style: Theme.of(context).textTheme.titleMedium),
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
