import 'package:flutter/material.dart';

import 'info_service.dart';
import 'models/info_model.dart';

const startVersion = "1.0.0";
const startBuild = "1";

class InfoViewModel extends ChangeNotifier {
  bool _loading = false;
  late InfoModel _info;
  InfoViewModel() {
    getInfo();
  }
  bool get loading => _loading;
  InfoModel get info => _info;
  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  getInfo() async {
    setLoading(true);
    _info = await InfoService.getInfo();
    setLoading(false);
  }
}
