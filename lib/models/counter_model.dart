import '../common.dart';

const counterTable = "counter";
const columnId = "id";
const columnCreateAt = "created_at";
const columnType = "type";
const countTypeSignal = 0;
const countTypeCounter = 1;
final markerDate = DateTime(1900, 1, 1);

class CounterModel {
  late DateTime startTime;
  late int count;
  late int total;

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
    var startPoint = first[columnCreateAt];
    startTime = DateTime.fromMillisecondsSinceEpoch(startPoint);
    // items.where((e) => e[columnType] != countTypeSignal).groupBy();
    for (var e in items) {
      if (e[columnType] == countTypeSignal) continue;
      var point = e[columnCreateAt];
      // 30 秒内连续点击算一次胎动
      var d = (point - startPoint) ~/ (30 * 1000);
      if (!countDetail.containsKey(d)) {
        countDetail[d] = <DateTime>[];
      } else {
        countDetail[d]!.add(DateTime.fromMillisecondsSinceEpoch(point));
      }
    }

    count = countDetail.keys.length;
    total = items.length;
  }
}

class CounterRow {
  final int id;
  final int type;
  final int createdAt;

  CounterRow(this.id, this.type, this.createdAt);
}

class CounterDay {
  final int year;
  final int month;
  final int day;
  final Map<int, int> countInHour = {};
  CounterDay(this.year, this.month, this.day);

  void addCount(int hour, int count) {
    countInHour[hour] = count;
  }

  int get prediction {
    return countInHour.values.reduce((a, b) => a + b) *
        (12 ~/ countInHour.values.length);
  }
}

String _hourKey(DateTime t) {
  return [t.year, t.month, t.day, t.hour]
      .map<String>((e) => e.toString().padLeft(2, "0"))
      .join("_");
}

bool _isHour(DateTime job, DateTime t) {
  return t.difference(job).inMilliseconds < hourOfMilliseconds;
}

Map<int, List<DateTime>> countDetail(List<DateTime> points) {
  var startPoint = points.removeAt(0);
  Map<int, List<DateTime>> countDetail = {};
  for (var point in points) {
    // 30 秒内连续点击算一次胎动
    var d = point.difference(startPoint).inSeconds ~/ 30;
    if (!countDetail.containsKey(d)) {
      countDetail[d] = <DateTime>[];
    }
    countDetail[d]!.add(point);
  }

  return countDetail;
}

Map<String, List<DateTime>> groupByHour(List<Map<String, dynamic>> items) {
  var hr = <String, List<DateTime>>{};
  DateTime? latestJob;
  for (var e in items) {
    var r = CounterRow(e[columnId], e[columnType], e[columnCreateAt]);

    var t = DateTime.fromMillisecondsSinceEpoch(r.createdAt);
    if (r.type == countTypeSignal) {
      latestJob = t;
      hr[_hourKey(latestJob)] = <DateTime>[t];
    } else {
      if (latestJob != null && _isHour(latestJob, t)) {
        hr[_hourKey(latestJob)]?.add(t);
      }
    }
  }
  return hr;
}

List<CounterDay> groupByDay(Map<String, List<DateTime>> items) {
  Map<DateTime, CounterDay> tmp = {};

  items.forEach((key, value) {
    var hourTime = key.split("_").map((e) => int.parse(e)).toList();
    var year = hourTime[0];
    var month = hourTime[1];
    var day = hourTime[2];
    var hour = hourTime[3];
    var t = DateTime(year, month, day);

    if (!tmp.containsKey(t)) {
      var d = CounterDay(year, month, day);
      tmp[t] = d;
    }

    tmp[t]!.addCount(hour, countDetail(value).keys.length);
  });
  return tmp.values.toList();
}
