import 'package:infinite_circle/db/db_queries.dart';
import 'package:infinite_circle/db/models/scores.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Database version
  static const String _dbName = 'infinite_circle_database.db';
  static const int _dbVersion = 1;
  final _queryManager = Version1();

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) {
        db.execute(_queryManager.createTable());
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute(_queryManager.deleteTable());
        db.execute(_queryManager.createTable());
      },
      onDowngrade: (db, oldVersion, newVersion) {
        db.execute(_queryManager.dropTable());
        db.execute(_queryManager.createTable());
      },
    );
  }

  Future<void> insertScore(Scores score) async {
    final db = await instance.database;
    await db.rawInsert(
      _queryManager.insertRecord(score.toJson()),
    );
  }

  Future<List<Scores>> getScores() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      _queryManager.getTable(),
    );
    return result.map((json) => Scores.fromJson(json)).toList();
  }

  Future<void> deleteScores() async {
    final db = await instance.database;
    await db.rawDelete(_queryManager.deleteTable());
  }

  Future close() async => database.then((db) => db.close());
}
