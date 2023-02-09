import 'dart:async';
import 'dart:io' as io;

import 'package:fetal_movement_counter/sql.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'info_service.dart';
import 'models/info_model.dart';

const dbname = "fmc.db";
const firstBuildNumber = "1";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _db;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  void _onCreate(Database db, int version) async {
    // create table statements here
    await db.execute(appInit);
  }

// other database operations here

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbname);
    InfoModel info = await InfoService.getInfo();

    if (info.buildNumber == firstBuildNumber) {
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    } else {
      _db = await openDatabase(path,
          version: int.parse(info.buildNumber), onUpgrade: _onUpgrade);
    }
  }
}
