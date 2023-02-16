import 'package:fetal_movement_counter/database_helper.dart';
import 'package:fetal_movement_counter/models/info_model.dart';

import 'info_helper.dart';

const appTable = "app";

Future<InfoModel> getInfoModel() async {
  var info2 = InfoHelper().info;

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
  var values = {
    "key": InfoModel.expectedDateKey,
    "value": expectedDate.toIso8601String(),
    "created_at": DateTime.now().millisecondsSinceEpoch
  };
  await db!.insert(
    appTable,
    values,
    // conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<bool> hasExpectedDate() async {
  var info = await getInfoModel();
  return info.expectedDate != null;
}
