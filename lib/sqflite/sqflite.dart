import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:step_counter_demo_flutter/model/step_counter_model.dart';

class SqfliteHelper {
  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'step_counter_database.db');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE stepCounter(id INTEGER PRIMARY KEY AUTOINCREMENT, step TEXT, time TEXT)',
        );
      },
    );
    return database;
  }

  Future<StepCounterModel> insertStep(StepCounterModel step) async {
    final db = await database;

    await db.insert(
      'stepCounter',
      step.toMap(),
    );
    return step;
  }

  Future<List<StepCounterModel>> getStep() async {
    final db = await database;

    final List<Map<String, dynamic>> steps = await db.query('stepCounter');

    return List.generate(steps.length, (i) {
      return StepCounterModel(
        id: steps[i]['id'],
        step: steps[i]['step'],
        time: steps[i]['time'],
      );
    });
  }
}
