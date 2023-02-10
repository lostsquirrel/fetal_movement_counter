class InfoModel {
  static const String expectedDateKey = "expected_date";
  String version;
  String buildNumber;
  DateTime? expectedDate;
  InfoModel({required this.version, required this.buildNumber});

  bool hasExpectedDate() {
    return expectedDate != null;
  }

  void fromDB(List<Map<String, dynamic>> items) {
    Map<String, dynamic> item =
        items.lastWhere((e) => e['key'] == expectedDateKey, orElse: () => {});
    if (item.isNotEmpty) {
      expectedDate = DateTime(item['value']);
    }
  }
}
