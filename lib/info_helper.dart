import 'package:package_info_plus/package_info_plus.dart';

import 'models/info_model.dart';

class InfoHelper {
  static final InfoHelper _instance = InfoHelper._p();
  InfoHelper._p();
  factory InfoHelper() {
    return _instance;
  }
  late InfoModel _info;
  Future<void> init() async {
    final packageInfo = await PackageInfo.fromPlatform();
    _info = InfoModel(
        version: packageInfo.version, buildNumber: packageInfo.buildNumber);
  }

  InfoModel get info {
    return _info;
  }
}
