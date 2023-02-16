import 'dart:async';

import 'package:fetal_movement_counter/info_helper.dart';
import 'package:fetal_movement_counter/sql.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/info_model.dart';

const dbname = "fmc.db";
const firstBuildNumber = "1";

void _onCreate(Database db, int version) async {
  // create table statements here
  await db.execute(appInit);
}

// other database operations here

FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  late Database _db;

  factory DatabaseHelper() {
    return _instance;
  }
  DatabaseHelper._internal();

  Future<Database?> get db async {
    return _db;
  }

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    String path = join(dir.path, dbname);

    InfoModel info = InfoHelper().info;

    // return openDatabase(path, version: 1, onCreate: _onCreate);
    if (info.buildNumber == firstBuildNumber) {
      _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    } else {
      _db = await openDatabase(path,
          version: int.parse(info.buildNumber), onUpgrade: _onUpgrade);
    }
  }
}
