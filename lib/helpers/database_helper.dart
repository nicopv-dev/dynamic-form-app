import 'dart:developer' as dev;

import 'package:dynamic_form_app/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import "package:path/path.dart";
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static Database? _database;
  final String formsTable = Constants.formsTable;
  final String fieldTypesTable = Constants.fieldTypesTable;
  final String formFieldsTable = Constants.formFieldsTable;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'dynamic_form.db');

    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $fieldTypesTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $formsTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $formFieldsTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        form_id INTEGER,
        field_type_id INTEGER,
        FOREIGN KEY (form_id) REFERENCES $formsTable(id),
        FOREIGN KEY (field_type_id) REFERENCES $fieldTypesTable(id)
      )
    ''');
  }

  Future<void> insertInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (!isFirstRun) return;

    final db = await database;
    final query = await db.rawQuery('SELECT COUNT(*) FROM $fieldTypesTable');
    final count = Sqflite.firstIntValue(query);

    if (count == null || count > 0) return;

    await db.insert(fieldTypesTable, {'name': 'text'});
    await db.insert(fieldTypesTable, {'name': 'number'});
    await db.insert(fieldTypesTable, {'name': 'date'});
    await db.insert(fieldTypesTable, {'name': 'dropdown'});
    await db.insert(fieldTypesTable, {'name': 'checkbox'});
    await db.insert(fieldTypesTable, {'name': 'image'});

    dev.log('[DATABASE_HELPER] Inserted initial data');
  }

  Future<void> insertData(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<void> clearTables() async {
    final db = await database;
    await db.delete(formsTable);
    await db.delete(fieldTypesTable);
    await db.delete(formFieldsTable);
  }
}
