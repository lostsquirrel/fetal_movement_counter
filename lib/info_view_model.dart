import 'package:flutter/material.dart';

import 'info_service.dart';
import 'models/info_model.dart';

const startVersion = "1.0.0";
const startBuild = "1";

class InfoViewModel extends ChangeNotifier {
  Future<InfoModel> getInfo() async {
    return infoService.getInfo();
  }
}
