# Global Version Checking Integration Guide

## Overview

Version checking is now **global and works across all screens** (login, home, attendance, etc.) instead of just on the login screen.

## How It Works

```
App Resumes (any screen)
         ↓
didChangeAppLifecycleState(resumed)
         ↓
VersionService.checkVersion()
         ↓
Compare versions + show dialog if update needed
```

## Integration Steps

### 1. Add VersionService to Service Locator

In your **service locator setup** (usually `lib/base/services/service_locator.dart` or similar):

```dart
import 'package:MyRoyal/base/services/version_service.dart';
import 'package:MyRoyal/base/initialization/firebase_remote_config.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

void setupServiceLocator() {
  // ... your existing services ...

  // Initialize VersionService (must be after Firebase Remote Config)
  Get.put<VersionService>(
    VersionService(
      firebaseRemoteConfig: Get.find<MellotippetFirebaseRemoteConfig>(),
      deviceInfo: Get.find<DeviceInfo>(),
      appDialog: Get.find<AppDialog>(),
    ),
    permanent: true, // Keep alive throughout app lifecycle
  );
}
```

### 2. Initialize Early in App Lifecycle

Add to **main.dart** or your app initialization:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Firebase, Remote Config, etc.
  await setupFirebase();

  // Then setup services
  setupServiceLocator();

  runApp(const MyApp());
}
```

### 3. Verify VersionService Initialization

In your **App widget** or root page:

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // ... your config ...
      home: _initRoute(),
    );
  }

  Widget _initRoute() {
    // VersionService is now running in background
    // It will detect app resume and check versions automatically
    return const LoginPage();
  }
}
```

## Features

✅ **Global Lifecycle Detection**

- Monitors app state across all screens (login, home, attendance, etc.)
- Automatically checks version when app resumes from any screen

✅ **Lightweight**

- Only compares version numbers on resume
- 5-minute throttle prevents excessive checks
- No device info re-fetching needed

✅ **Smart Dialog Management**

- Prevents showing multiple dialogs simultaneously
- Force updates cannot be dismissed (shows same dialog)
- Recommended updates can be dismissed but will be reminded

✅ **No Breaking Changes**

- LoginController still works normally
- Device info setup still happens in LoginController
- Version checking is now separated and global

## Version Check Flow

```
┌────────────────────────────────────────┐
│ App Lifecycle Events (all screens)    │
└────────────────────────────────────────┘
           ↓
┌────────────────────────────────────────┐
│ VersionService.checkVersion()          │
│  - Check if 5min throttle elapsed      │
│  - Compare current vs required version │
│  - Fetch remote config values          │
└────────────────────────────────────────┘
           ↓
      ┌────────────────────┐
      │ Version OK?        │
      └────────────────────┘
       ↙ No      ↘ Yes
      ↓          ↓
  Show Dialog   No action
      ↓
   User chooses
   Update/Later
```

## Logging

VersionService logs all activities:

```
[VERSION SERVICE] Check - Current: 10001, Required: 10002, Recommended: 10002
[VERSION SERVICE] Force update required
[VERSION SERVICE] Dialog already showing, skipping check
[VERSION SERVICE] Skipping check - last checked 2 minutes ago
[VERSION SERVICE] App is up to date
```

View logs with: `AppUtils.logApp()`

## Testing

### Test Force Update

1. Set app version lower than Firebase Remote Config required version
2. Close app, open from tray
3. Dialog appears and cannot be dismissed ✓

### Test Recommended Update

1. Set app version lower than recommended but higher than required
2. Close app, open from tray
3. Dialog appears, can be dismissed ✓

### Test Play Store Redirect

1. Click "Update" button → Play Store
2. Return without updating
3. Dialog re-appears when app resumes ✓

## FAQ

**Q: Why isn't VersionService in LoginController anymore?**
A: Because users might already be logged in on home/other screens. Now version checks work everywhere, not just on login screen.

**Q: What if user is in the middle of an important action?**
A: The 5-minute throttle and "already showing dialog" check prevent interrupting users too frequently.

**Q: Does this impact app performance?**
A: No - version checking is lightweight and cached. Only does version string comparison on app resume.

**Q: Can I customize the update dialog?**
A: Yes, modify `_showUpdateDialog()` in `version_service.dart` or update the `appDialog.showAppVersionInfoDialog()` call.
