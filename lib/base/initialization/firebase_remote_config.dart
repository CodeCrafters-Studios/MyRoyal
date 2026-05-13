import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

class MellotippetFirebaseRemoteConfig extends GetxService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    try {
      final bool activated = await remoteConfig.fetchAndActivate();
      AppUtils.logApp('REMOTE CONFIG ACTIVATED: $activated');
    } catch (e) {
      // Silently fail on simulator — remote config is non-critical
      AppUtils.logApp('REMOTE CONFIG ERROR (safe to ignore on simulator): $e');
    }

    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  }

  // Helper methods to simplify using the values in other parts of the code
  String getRequiredMinimumVersion() =>
      remoteConfig.getString('requiredMinimumVersion');

  String getRecommendedMinimumVersion() =>
      remoteConfig.getString('recommendedMinimumVersion');

  bool getForceUpdateVersion() => remoteConfig.getBool('forceUpdateVersion');
  bool showEvent() => remoteConfig.getBool('showEvent');
  bool newUpdate() => remoteConfig.getBool('newUpdate');
}
