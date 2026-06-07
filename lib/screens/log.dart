// LunaFlow - Log Screen
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0

import 'package:flutter/material.dart';
import '../services/database_service.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  DateTime selectedDate = DateTime.now();
  String? flowIntensity;
  String? flowColour;
  String? mood;
  String? libido;
  double energyLevel = 3;
  double sleepHours = 7;
  Set<String> selectedSymptoms = {};
  final TextEditingController notesController = TextEditingController();
  bool _isSaving = false;

  final List<Map<String, String>> intensityOptions = [
    {'label': 'Spotting', 'emoji': '🩸'},
    {'label': 'Light', 'emoji': '💧'},
    {'label': 'Medium', 'emoji': '🔴'},
    {'label': 'Heavy', 'emoji': '❤️'},
  ];

  final List<Map<String, String>> colourOptions = [
    {'label': 'Bright Red', 'emoji': '🔴'},
    {'label': 'Dark Red', 'emoji': '🟤'},
    {'label': 'Pink', 'emoji': '🩷'},
    {'label': 'Brown', 'emoji': '🟫'},
    {'label': 'Black', 'emoji': '⚫'},
    {'label': 'Orange', 'emoji': '🟠'},
  ];

  final List<Map<String, String>> symptomOptions = [
    {'label': 'Cramps', 'emoji': '😣'},
    {'label': 'Headache', 'emoji': '🤕'},
    {'label': 'Bloating', 'emoji': '🫧'},
    {'label': 'Fatigue', 'emoji': '😴'},
    {'label': 'Nausea', 'emoji': '🤢'},
    {'label': 'Acne', 'emoji': '😤'},
    {'label': 'Breast Tenderness', 'emoji': '💔'},
    {'label': 'Back Pain', 'emoji': '🔙'},
    {'label': 'Brain Fog', 'emoji': '🌫️'},
    {'label': 'Insomnia', 'emoji': '😶'},
    {'label': 'Increased Appetite', 'emoji': '🍽️'},
    {'label': 'Decreased Appetite', 'emoji': '🚫'},
    {'label': 'Food Cravings', 'emoji': '🍫'},
  ];

  final List<Map<String, String>> moodOptions = [
    {'label': 'Happy', 'emoji': '😊'},
    {'label': 'Calm', 'emoji': '😌'},
    {'label': 'Anxious', 'emoji': '😰'},
    {'label': 'Irritable', 'emoji': '😠'},
    {'label': 'Sad', 'emoji': '😢'},
    {'label': 'Energetic', 'emoji': '⚡'},
    {'label': 'Overwhelmed', 'emoji': '😵'},
  ];

  final List<Map<String, String>> libidoOptions = [
    {'label': 'Low', 'emoji': '📉'},
    {'label': 'Normal', 'emoji': '➡️'},
    {'label': 'High', 'emoji': '📈'},
  ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _logPeriod() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select period start date',
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      await DatabaseService.instance.logPeriodStart(
        picked.toIso8601String().split('T')[0],
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Period logged for ${picked.day}/${picked.month}/${picked.year} 🌙',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _saveEntry() async {
    setState(() => _isSaving = true);

    try {
      await DatabaseService.instance.saveDailyLog(
        date: selectedDate.toIso8601String().split('T')[0],
        flowIntensity: flowIntensity,
        flowColour: flowColour,
        mood: mood,
        libido: libido,
        energyLevel: energyLevel.toInt(),
        sleepHours: sleepHours,
        notes: notesController.text.isEmpty ? null : notesController.text,
        symptoms: selectedSymptoms.toList(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entry saved! 🌙'),
            backgroundColor: Color(0xFF7B4F9E),
            duration: Duration(seconds: 2),
          ),
        );

        // Reset form
        setState(() {
          flowIntensity = null;
          flowColour = null;
          mood = null;
          libido = null;
          energyLevel = 3;
          sleepHours = 7;
          selectedSymptoms = {};
          notesController.clear();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving entry: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Today'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Date
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                trailing: const Icon(Icons.edit),
                onTap: _pickDate,
              ),
            ),

            const SizedBox(height: 16),

            // Log Period button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _logPeriod,
                icon: const Icon(Icons.water_drop),
                label: const Text('Log Period'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4F9E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Flow intensity
            Text('Flow Intensity',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: intensityOptions.map((option) {
                final isSelected = flowIntensity == option['label'];
                return ChoiceChip(
                  label: Text('${option['emoji']} ${option['label']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      flowIntensity = selected ? option['label'] : null;
                    });
                  },
                  selectedColor: const Color(0xFF7B4F9E),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Flow colour
            Text('Flow Colour',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Colour can indicate hormonal changes',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colourOptions.map((option) {
                final isSelected = flowColour == option['label'];
                return ChoiceChip(
                  label: Text('${option['emoji']} ${option['label']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      flowColour = selected ? option['label'] : null;
                    });
                  },
                  selectedColor: const Color(0xFF7B4F9E),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Symptoms
            Text('Symptoms',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Select all that apply',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: symptomOptions.map((option) {
                final isSelected = selectedSymptoms.contains(option['label']);
                return FilterChip(
                  label: Text('${option['emoji']} ${option['label']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedSymptoms.add(option['label']!);
                      } else {
                        selectedSymptoms.remove(option['label']);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF7B4F9E),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Mood
            Text('Mood', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: moodOptions.map((option) {
                final isSelected = mood == option['label'];
                return ChoiceChip(
                  label: Text('${option['emoji']} ${option['label']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      mood = selected ? option['label'] : null;
                    });
                  },
                  selectedColor: const Color(0xFF7B4F9E),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Libido
            Text('Sex Drive',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: libidoOptions.map((option) {
                final isSelected = libido == option['label'];
                return ChoiceChip(
                  label: Text('${option['emoji']} ${option['label']}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      libido = selected ? option['label'] : null;
                    });
                  },
                  selectedColor: const Color(0xFF7B4F9E),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Energy level
            Text(
              'Energy Level: ${energyLevel.toInt()}/5',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: energyLevel,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: const Color(0xFF7B4F9E),
              label: energyLevel.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  energyLevel = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Sleep hours
            Text(
              'Sleep: ${sleepHours.toInt()} hours',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: sleepHours,
              min: 0,
              max: 12,
              divisions: 12,
              activeColor: const Color(0xFF7B4F9E),
              label: '${sleepHours.toInt()}h',
              onChanged: (value) {
                setState(() {
                  sleepHours = value;
                });
              },
            ),

            const SizedBox(height: 24),

            // Notes
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Anything else you want to note...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _saveEntry,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? 'Saving...' : 'Save Entry'),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
