// LunaFlow - Database Service
// Copyright (C) 2026 alchemyxcode
// Licensed under GNU General Public License v3.0

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lunaflow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cycles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_date TEXT NOT NULL,
        end_date TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        flow_intensity TEXT,
        flow_colour TEXT,
        mood TEXT,
        libido TEXT,
        energy_level INTEGER,
        sleep_hours REAL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE symptoms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        log_id INTEGER NOT NULL,
        symptom TEXT NOT NULL,
        FOREIGN KEY (log_id) REFERENCES daily_logs (id)
      )
    ''');
  }

  Future<int> saveDailyLog({
    required String date,
    String? flowIntensity,
    String? flowColour,
    String? mood,
    String? libido,
    int? energyLevel,
    double? sleepHours,
    String? notes,
    List<String> symptoms = const [],
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final logId = await db.insert(
      'daily_logs',
      {
        'date': date,
        'flow_intensity': flowIntensity,
        'flow_colour': flowColour,
        'mood': mood,
        'libido': libido,
        'energy_level': energyLevel,
        'sleep_hours': sleepHours,
        'notes': notes,
        'created_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final symptom in symptoms) {
      await db.insert('symptoms', {
        'log_id': logId,
        'symptom': symptom,
      });
    }

    return logId;
  }

  Future<int> logPeriodStart(String startDate) async {
    final db = await database;
    return await db.insert(
      'cycles',
      {
        'start_date': startDate,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await database;
    return await db.query('daily_logs', orderBy: 'date DESC');
  }

  Future<List<String>> getSymptomsForLog(int logId) async {
    final db = await database;
    final results = await db.query(
      'symptoms',
      where: 'log_id = ?',
      whereArgs: [logId],
    );
    return results.map((r) => r['symptom'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getAllCycles() async {
    final db = await database;
    return await db.query('cycles', orderBy: 'start_date DESC');
  }

  Future<Map<String, dynamic>?> getLogForDate(String date) async {
    final db = await database;
    final results = await db.query(
      'daily_logs',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }
}
