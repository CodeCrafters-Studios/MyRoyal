import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/initialization/firebase_remote_config.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:url_launcher/url_launcher.dart';

/// Global version checking service
/// Monitors app version across all screens and shows update dialogs
class VersionService extends GetxService {
  final MellotippetFirebaseRemoteConfig firebaseRemoteConfig;
  final DeviceInfo deviceInfo;
  final AppDialog appDialog;

  VersionService({
    required this.firebaseRemoteConfig,
    required this.deviceInfo,
    required this.appDialog,
  });

  DateTime? _lastVersionCheckTime;
  bool _isUpdateDialogShown = false;
  bool _isInitialCheckDone = false;
  static const int VERSION_CHECK_CACHE_MINUTES = 5;

  @override
  void onInit() {
    super.onInit();
    AppUtils.logApp('[VERSION SERVICE] Initializing...');
    WidgetsBinding.instance.addObserver(_LifecycleObserver(
      onResumed: () {
        // Fire and forget - don't block the lifecycle callback
        checkVersion();
      },
    ));

    // Initial check when service starts
    Future.delayed(const Duration(milliseconds: 500), () {
      AppUtils.logApp('[VERSION SERVICE] Running initial version check');
      checkVersion();
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(_LifecycleObserver(
      onResumed: () {
        checkVersion();
      },
    ));
    super.onClose();
  }

  /// Perform lightweight version check
  /// Called automatically when app resumes
  Future<void> checkVersion() async {
    AppUtils.logApp(
        '[VERSION SERVICE] checkVersion() called, Dialog showing: $_isUpdateDialogShown');

    // Skip if dialog already showing
    if (_isUpdateDialogShown) {
      AppUtils.logApp(
          '[VERSION SERVICE] Dialog already showing, skipping check');
      return;
    }

    // Skip if checked recently (5 minute throttle) - BUT NOT on initial startup
    if (_isInitialCheckDone && _lastVersionCheckTime != null) {
      final minutesSinceLastCheck =
          DateTime.now().difference(_lastVersionCheckTime!).inMinutes;
      if (minutesSinceLastCheck < VERSION_CHECK_CACHE_MINUTES) {
        AppUtils.logApp(
            '[VERSION SERVICE] Throttled - last checked $minutesSinceLastCheck minutes ago');
        return;
      }
    }

    try {
      AppUtils.logApp('[VERSION SERVICE] Fetching version data...');

      final appVersion =
          _getExtendedVersionNumber(deviceInfo.packageInfo.version);
      final requiredMinVersion = _getExtendedVersionNumber(
          firebaseRemoteConfig.getRequiredMinimumVersion());
      final recommendedMinVersion = _getExtendedVersionNumber(
          firebaseRemoteConfig.getRecommendedMinimumVersion());
      final forceUpdateVersion = firebaseRemoteConfig.getForceUpdateVersion();

      _lastVersionCheckTime = DateTime.now();
      _isInitialCheckDone = true;

      AppUtils.logApp('[VERSION SERVICE] Version Check Results:');
      AppUtils.logApp(
          '[VERSION SERVICE]  - Current: $appVersion (${deviceInfo.packageInfo.version})');
      AppUtils.logApp(
          '[VERSION SERVICE]  - Required: $requiredMinVersion (${firebaseRemoteConfig.getRequiredMinimumVersion()})');
      AppUtils.logApp(
          '[VERSION SERVICE]  - Recommended: $recommendedMinVersion (${firebaseRemoteConfig.getRecommendedMinimumVersion()})');
      AppUtils.logApp('[VERSION SERVICE]  - Force Update: $forceUpdateVersion');

      // Update needed - show dialog
      if (appVersion < requiredMinVersion) {
        AppUtils.logApp('[VERSION SERVICE] ❌ Force update required!');
        _showUpdateDialog(forceUpdateVersion,
            firebaseRemoteConfig.getRequiredMinimumVersion(),
            isForce: true);
      } else if (appVersion < recommendedMinVersion) {
        AppUtils.logApp('[VERSION SERVICE] ⚠️ Recommended update available');
        _showUpdateDialog(forceUpdateVersion,
            firebaseRemoteConfig.getRecommendedMinimumVersion(),
            isForce: false);
      } else {
        AppUtils.logApp('[VERSION SERVICE] ✅ App is up to date');
      }
    } catch (e) {
      AppUtils.logApp('[VERSION SERVICE] ❌ Error checking version: $e');
    }
  }

  void _showUpdateDialog(
      bool isForceUpdateVersion, String recommendedMinVersion,
      {required bool isForce}) {
    _isUpdateDialogShown = true;
    bool userActionTaken = false;
    AppUtils.logApp(
        '[VERSION SERVICE] Showing update dialog - Force: $isForce');

    appDialog
        .showAppVersionInfoDialog(
      isForceUpdateVersion: isForceUpdateVersion || isForce,
      title: 'New version available',
      description:
          'Tersedia versi baru $recommendedMinVersion di Google Play Store. Apakah Anda ingin memperbarui?',
      onPressLater: () {
        userActionTaken = true;
        AppUtils.logApp(
            '[VERSION SERVICE] User pressed Later - Force: $isForce');
        if (isForceUpdateVersion || isForce) {
          // For force updates, don't allow dismissing - re-show immediately
          AppUtils.logApp(
              '[VERSION SERVICE] Force update - cannot dismiss, re-showing dialog');
          _isUpdateDialogShown = false;
          // Delay to avoid dialog stacking
          Future.delayed(const Duration(milliseconds: 300), () {
            _showUpdateDialog(isForceUpdateVersion, recommendedMinVersion,
                isForce: isForce);
          });
          return;
        }
        // For recommended updates, allow dismissal
        _isUpdateDialogShown = false;
        AppUtils.logApp(
            '[VERSION SERVICE] Recommended update dismissed by user');

        // Safely close dialog
        try {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        } catch (e) {
          AppUtils.logApp('[VERSION SERVICE] Error closing dialog: $e');
        }
      },
      onPressUpdate: () async {
        userActionTaken = true;
        AppUtils.logApp(
            '[VERSION SERVICE] User pressed Update - opening Play Store');

        // Safely close dialog
        try {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        } catch (e) {
          AppUtils.logApp('[VERSION SERVICE] Error closing dialog: $e');
        }

        _isUpdateDialogShown = false;

        String url =
            "https://play.google.com/store/apps/details?id=com.myroyal";
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          AppUtils.logApp('[VERSION SERVICE] User returned from Play Store');
          // Reset throttle so check runs immediately when app resumes
          _lastVersionCheckTime = null;
        } else {
          AppUtils.logApp('[VERSION SERVICE] Could not launch Play Store URL');
        }
      },
    )
        .then((_) {
      _isUpdateDialogShown = false;
      if (!userActionTaken) {
        AppUtils.logApp(
            '[VERSION SERVICE] Dialog closed implicitly (likely by route change). Re-evaluating...');
        // Reset throttle to ensure it checks again
        _lastVersionCheckTime = null;
        // Small delay to allow the new route to fully transition before showing dialog again
        Future.delayed(const Duration(milliseconds: 1000), () {
          checkVersion();
        });
      }
    });
  }

  /// Reset the version check (useful when dialog was dismissed by route change)
  void resetVersionCheck() {
    AppUtils.logApp('[VERSION SERVICE] Manual reset requested');
    _isUpdateDialogShown = false;
    _lastVersionCheckTime = null;
    Future.delayed(const Duration(milliseconds: 500), () {
      checkVersion();
    });
  }

  /// Compare semantic versions
  int _getExtendedVersionNumber(String version) {
    try {
      List<String> versionCells = version.split('.');
      List<int> versionNumbers = versionCells.map((i) => int.parse(i)).toList();
      return versionNumbers[0] * 100000 +
          versionNumbers[1] * 1000 +
          versionNumbers[2];
    } catch (e) {
      AppUtils.logApp('[VERSION SERVICE] Error parsing version $version: $e');
      return 0;
    }
  }

  /// Check if an update is required without showing the dialog (useful for blocking auto-login)
  Future<bool> isUpdateRequiredAsync() async {
    try {
      final appVersion =
          _getExtendedVersionNumber(deviceInfo.packageInfo.version);
      final requiredMinVersion = _getExtendedVersionNumber(
          firebaseRemoteConfig.getRequiredMinimumVersion());
      final recommendedMinVersion = _getExtendedVersionNumber(
          firebaseRemoteConfig.getRecommendedMinimumVersion());
          
      return (appVersion < requiredMinVersion || appVersion < recommendedMinVersion);
    } catch (e) {
      return false;
    }
  }
}

/// Lifecycle observer to detect app resume
class _LifecycleObserver with WidgetsBindingObserver {
  final VoidCallback onResumed;

  _LifecycleObserver({required this.onResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
