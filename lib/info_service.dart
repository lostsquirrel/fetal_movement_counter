import 'package:fetal_movement_counter/models/info_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoService {
  static Future<InfoModel> getInfo() async {
    final info = await PackageInfo.fromPlatform();
    return InfoModel(version: info.version, buildNumber: info.buildNumber);
  }
}
