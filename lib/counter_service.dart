import 'database_helper.dart';
import 'models/counter_model.dart';

/// 最的一小时是否有任务

Future<CounterModel> getCounter() async {
  final db = await DatabaseHelper().db;

  var whereString = "$columnCreateAt >= ?";
  var whereArguments = [
    DateTime.now().add(const Duration(minutes: -60)).millisecondsSinceEpoch
  ];
  var items = await db!.query(
    counterTable,
    where: whereString,
    whereArgs: whereArguments,
  );
  return CounterModel(items);
}

Future<List<CounterDay>> getCounterResults() async {
  final db = await DatabaseHelper().db;
  var items = await db!.query(counterTable);
  return groupByDay(groupByHour(items));
}

Future<void> startJob() async {
  final db = await DatabaseHelper().db;
  await db!.insert(counterTable, {
    columnType: countTypeSignal,
    columnCreateAt: DateTime.now().millisecondsSinceEpoch,
  });
}

Future<void> addCount() async {
  final db = await DatabaseHelper().db;
  await db!.insert(counterTable, {
    columnType: countTypeCounter,
    columnCreateAt: DateTime.now().millisecondsSinceEpoch,
  });
}
