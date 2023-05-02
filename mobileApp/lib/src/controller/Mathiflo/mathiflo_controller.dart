import 'package:mathiflo/config.dart';
import 'package:mathiflo/src/model/Mathiflo/mathiflo_network.dart';
import 'package:state_extended/state_extended.dart';

class MathifloController extends StateXController {
  factory MathifloController() => _this ??= MathifloController._();
  MathifloController._() : super();

  static MathifloController? _this;
  late bool _needUpdateApp;

  bool get needUpdateApp => _needUpdateApp;

  Future<void> initialize() async {
    _needUpdateApp = await _needUpdate();
  }

  Future<bool> _needUpdate() async {
    final networkAppInfo = await getNetworkAppInfo();

    if (networkAppInfo == null) {
      return false;
    }
    return packageInfo.version != networkAppInfo["app_version"] ||
        packageInfo.buildNumber != networkAppInfo["code_version"];
  }
}
