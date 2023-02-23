import '../common.dart';

const counterTable = "counter";
const columnCreateAt = "created_at";
const columnType = "type";
const countTypeSignal = 0;
const countTypeCounter = 1;

class CounterModel {
  static const createAtKey = "created_at";
  late DateTime startTime;
  late int count;
  late int total;
  var countPoint = 12;
  static final markerDate = DateTime(1900, 1, 1);
  bool get hasJob => total > 0;
  Map<int, List<DateTime>> countDetail = {};
  CounterModel(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      startTime = markerDate;
      count = 0;
      total = 0;
      return;
    }
    // conterStep = Iterable.generate(countPoint, (i) => i * 5).toList();
    var first = items.firstWhere(
      (element) => element[columnType] == countTypeSignal,
      orElse: () => {},
    );
    if (first.isEmpty) {
      startTime = markerDate;
      count = 0;
      total = 0;
      return;
    }
    var startPoint = first[createAtKey];
    startTime = DateTime.fromMillisecondsSinceEpoch(startPoint);

    for (var e in items) {
      if (e[columnType] == countTypeSignal) continue;
      var point = e[createAtKey];
      // 30 秒内连续点击算一次胎动
      var d = (point - startPoint) ~/ (minuteOfMilliseconds / 2);
      if (!countDetail.containsKey(d)) {
        countDetail[d] = <DateTime>[];
      }
      countDetail[d]!.add(DateTime.fromMillisecondsSinceEpoch(point));
    }

    count = countDetail.keys.length;
    total = items.length;
  }
}
