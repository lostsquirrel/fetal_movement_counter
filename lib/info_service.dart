import 'package:fetal_movement_counter/database_helper.dart';
import 'package:fetal_movement_counter/models/info_model.dart';

import 'info_helper.dart';

const appTable = "app";

class _InfoService {
  _InfoService() {
    // DatabaseHelper().initDb();
  }
  Future<InfoModel> getInfo() async {
    var info2 = await InfoHelper().info;

    await loadInfoFromDB(info2);
    return info2;
  }

  loadInfoFromDB(InfoModel info) async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps = await db!.query(appTable);
    info.fromDB(maps);
  }

  Future<void> addExpectedDate(DateTime expectedDate) async {
    final db = await DatabaseHelper().db;
    await db!.insert(
      appTable,
      {
        "key": InfoModel.expectedDateKey,
        "value": expectedDate,
        "created_at": DateTime.now()
      },
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

var infoService = _InfoService();
