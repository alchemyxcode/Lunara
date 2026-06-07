// LunaFlow - Home Screen
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0
import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/lunar_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _lastCycle;
  Map<String, dynamic>? _todayLog;
  List<String> _todaySymptoms = [];
  int? _dayOfCycle;
  DateTime? _predictedNextPeriod;
  int? _daysUntilNext;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final today = DateTime.now();
      final todayStr =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final cycles = await DatabaseService.instance.getAllCycles();
      final todayLog = await DatabaseService.instance.getLogForDate(todayStr);
      List<String> todaySymptoms = [];
      if (todayLog != null) {
        todaySymptoms = await DatabaseService.instance
            .getSymptomsForLog(todayLog['id'] as int);
      }
      int? dayOfCycle;
      DateTime? predictedNext;
      int? daysUntilNext;
      if (cycles.isNotEmpty) {
        final lastCycleStart = DateTime.parse(cycles.first['start_date']);
        dayOfCycle = today.difference(lastCycleStart).inDays + 1;
        int avgCycleLength = 28;
        if (cycles.length > 1) {
          int totalDays = 0;
          for (int i = 0; i < cycles.length - 1; i++) {
            final current = DateTime.parse(cycles[i]['start_date']);
            final previous = DateTime.parse(cycles[i + 1]['start_date']);
            totalDays += current.difference(previous).inDays;
          }
          avgCycleLength = (totalDays / (cycles.length - 1)).round();
        }
        predictedNext = lastCycleStart.add(Duration(days: avgCycleLength));
        daysUntilNext = predictedNext
            .difference(DateTime(today.year, today.month, today.day))
            .inDays;
      }
      setState(() {
        _lastCycle = cycles.isNotEmpty ? cycles.first : null;
        _todayLog = todayLog;
        _todaySymptoms = todaySymptoms;
        _dayOfCycle = dayOfCycle;
        _predictedNextPeriod = predictedNext;
        _daysUntilNext = daysUntilNext;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _countdownText() {
    if (_daysUntilNext == null) return '';
    if (_daysUntilNext! > 0) return '$_daysUntilNext days away';
    if (_daysUntilNext == 0) return 'Expected today 🌙';
    return '${_daysUntilNext!.abs()} days late';
  }

  Color _countdownColor() {
    if (_daysUntilNext == null) return const Color(0xFF7B4F9E);
    if (_daysUntilNext! > 5) return const Color(0xFF7B4F9E);
    if (_daysUntilNext! > 0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final lunar = LunarService.instance;
    final phaseEmoji = lunar.getPhaseEmoji(today);
    final phaseName = lunar.getPhaseName(today);
    final daysToFull = lunar.daysUntilFullMoon(today);
    final daysToNew = lunar.daysUntilNewMoon(today);
    final isAlignment = lunar.isAlignmentDay(today);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌙 LunaFlow'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, Deanna 🌙',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(today),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Moon phase card
                    Card(
                      color: isAlignment
                          ? const Color(0xFF7B4F9E).withAlpha(40)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Moon Phase',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                if (isAlignment)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7B4F9E),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Alignment ✨',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(phaseEmoji,
                                    style: const TextStyle(fontSize: 48)),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      phaseName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      daysToFull == 0
                                          ? 'Full moon tonight 🌕'
                                          : '$daysToFull days to full moon',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    Text(
                                      daysToNew == 0
                                          ? 'New moon tonight 🌑'
                                          : '$daysToNew days to new moon',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Countdown card
                    if (_predictedNextPeriod != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next Period',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      _countdownText(),
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: _countdownColor(),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '~${_formatDate(_predictedNextPeriod!)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Cycle status card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cycle Status',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            if (_lastCycle == null) ...[
                              const Row(
                                children: [
                                  Icon(Icons.info_outline, size: 16),
                                  SizedBox(width: 8),
                                  Text('No cycle logged yet'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text('Tap Log to record your first period'),
                            ] else ...[
                              Row(
                                children: [
                                  const Icon(Icons.water_drop,
                                      color: Color(0xFF7B4F9E), size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Last period: ${_formatDate(DateTime.parse(_lastCycle!['start_date']))}',
                                  ),
                                ],
                              ),
                              if (_dayOfCycle != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.today,
                                        color: Color(0xFF7B4F9E), size: 16),
                                    const SizedBox(width: 8),
                                    Text('Day $_dayOfCycle of your cycle'),
                                  ],
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Today's log card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            if (_todayLog == null) ...[
                              const Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 16),
                                  SizedBox(width: 8),
                                  Text('No entry logged today'),
                                ],
                              ),
                            ] else ...[
                              const Row(
                                children: [
                                  Icon(Icons.check_circle,
                                      color: Color(0xFF7B4F9E), size: 16),
                                  SizedBox(width: 8),
                                  Text('Logged today ✅'),
                                ],
                              ),
                              if (_todayLog!['mood'] != null) ...[
                                const SizedBox(height: 8),
                                Text('Mood: ${_todayLog!['mood']}'),
                              ],
                              if (_todayLog!['energy_level'] != null) ...[
                                const SizedBox(height: 4),
                                Text('Energy: ${_todayLog!['energy_level']}/5'),
                              ],
                              if (_todaySymptoms.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  children: _todaySymptoms
                                      .take(3)
                                      .map((s) => Chip(
                                            label: Text(s,
                                                style: const TextStyle(
                                                    fontSize: 11)),
                                            padding: EdgeInsets.zero,
                                          ))
                                      .toList(),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
