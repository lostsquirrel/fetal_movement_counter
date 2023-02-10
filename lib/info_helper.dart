import 'package:package_info_plus/package_info_plus.dart';

import 'models/info_model.dart';

class InfoHelper {
  static final InfoHelper _instance = InfoHelper._();
  static InfoModel? _info;
  InfoHelper._();

  factory InfoHelper() {
    return _instance;
  }

  Future<InfoModel> get info async {
    _info ??= await getInfo();
    return _info!;
  }

  Future<InfoModel> getInfo() async {
    final info = await PackageInfo.fromPlatform();
    return InfoModel(version: info.version, buildNumber: info.buildNumber);
  }
}
