import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmdb/database/model/database_model.dart';

class DatabaseHelper {
  DatabaseHelper.init();

  static final DatabaseHelper instance = DatabaseHelper.init();

  // database properties
  static const _dbName = 'movie.db';
  static const _dbVersion = 1;

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await _initDatabase();
    }

    return _db!;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);

    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreateDatabase);
  }

  Future _onCreateDatabase(Database db, int version) async {
    final idMovie = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';
    final numType = 'REAL NOT NULL';

    await db.execute(
        'CREATE TABLE ${MovieFields.popular} (${MovieFields.idMovie} $idMovie, ${MovieFields.id} $idType, ${MovieFields.poster} $textType, ${MovieFields.backdrop} $textType, ${MovieFields.title} $textType, ${MovieFields.vote} $numType)');

    await db.execute(
        'CREATE TABLE ${MovieFields.nowPlaying} (${MovieFields.idMovie} $idMovie, ${MovieFields.id} $idType, ${MovieFields.poster} $textType, ${MovieFields.backdrop} $textType, ${MovieFields.title} $textType, ${MovieFields.vote} $numType)');

    await db.execute(
        'CREATE TABLE ${MovieFields.topRated} (${MovieFields.idMovie} $idMovie, ${MovieFields.id} $idType, ${MovieFields.poster} $textType, ${MovieFields.backdrop} $textType, ${MovieFields.title} $textType, ${MovieFields.vote} $numType)');
  }

  Future<int> create(String table, MovieDatabaseModel model) async {
    final db = await instance.database;
    final query = await db.insert(table, model.toMap());

    return query;
  }

  Future<List<MovieDatabaseModel>> read(String table) async {
    final db = await instance.database;
    final data = await db.query(table);
    List<MovieDatabaseModel> result =
        data.map((e) => MovieDatabaseModel.fromMap(e)).toList();

    return result;
  }

  Future deleteTable(String table) async {
    final db = await instance.database;

    final idMovie = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';
    final numType = 'REAL NOT NULL';

    await db.execute("DROP TABLE IF EXISTS $table");
    await db.execute(
        'CREATE TABLE $table (${MovieFields.idMovie} $idMovie, ${MovieFields.id} $idType, ${MovieFields.poster} $textType, ${MovieFields.backdrop} $textType, ${MovieFields.title} $textType, ${MovieFields.vote} $numType)');
  }
}
