import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper._internal();
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databaseDirpath = await getDatabasesPath();
    final databasePath = join(databaseDirpath, 'student_db');

    return openDatabase(databasePath, version: 1, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT,text TEXT  ) ');
    });
  }

  Future<int> insertText(String text) async {
    final db = await database;
    return await db.insert('students', {'text': text});
  }

  Future<List<Map<String, dynamic>>> getTexts() async {
    Database db = await database;
    return await db.query('students');
  }
}
