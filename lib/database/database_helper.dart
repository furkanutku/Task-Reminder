import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_reminder/model/task.dart';

class DBHelper {
  static Database? _db;
  static const _version = 1;
  static const _tablename = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("creating a new one");
          return db.execute(
            "CREATE TABLE $_tablename("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "color INTEGER,"
            "isCompleted INTEGER) ",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int?> insert(Task? task) async {
    print("insert function called");
    return await _db?.insert(_tablename, task!.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print("query function called");
    return await _db!.query(_tablename);
  }

  static delete(int id) async {
    await _db!.delete(_tablename, where: 'id=?', whereArgs: [id]);
  }

  static updateAsComplete(int id) async {
    await _db!.rawUpdate(''' 
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
      ''', [1, id]);
  }

  static updateAsTodo(int id) {
    _db!.rawUpdate(''' 
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
      ''', [0, id]);
  }
}
