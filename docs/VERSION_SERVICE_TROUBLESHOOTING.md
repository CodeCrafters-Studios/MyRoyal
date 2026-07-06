# VersionService Troubleshooting Guide

## Quick Checklist

### 1. Is VersionService Initialized?

Add this to your service locator initialization:

```dart
// In your service locator setup (e.g., service_locator.dart or main.dart)
import 'package:MyRoyal/base/services/version_service.dart';

void setupServices() {
  // Initialize Firebase Remote Config FIRST
  Get.put<MellotippetFirebaseRemoteConfig>(...);
  Get.put<DeviceInfo>(...);
  Get.put<AppDialog>(...);

  // THEN initialize VersionService
  Get.put<VersionService>(
    VersionService(
      firebaseRemoteConfig: Get.find<MellotippetFirebaseRemoteConfig>(),
      deviceInfo: Get.find<DeviceInfo>(),
      appDialog: Get.find<AppDialog>(),
    ),
    permanent: true, // Very important!
  );

  AppUtils.logApp('[SERVICE LOCATOR] VersionService initialized');
}
```

### 2. Check Logs

Look for these log messages:

**Initial startup (should see within 500ms):**

```
[VERSION SERVICE] Initializing...
[VERSION SERVICE] Running initial version check
[VERSION SERVICE] checkVersion() called
[VERSION SERVICE] Fetching version data...
[VERSION SERVICE] Version Check Results:
[VERSION SERVICE]  - Current: 10001 (1.0.1)
[VERSION SERVICE]  - Required: 10001 (1.0.1)
[VERSION SERVICE]  - Recommended: 10001 (1.0.1)
[VERSION SERVICE]  - Force Update: false
[VERSION SERVICE] ✅ App is up to date
```

**When app resumes:**

```
[VERSION SERVICE] checkVersion() called
[VERSION SERVICE] Version Check Results:
...
```

### 3. Verify Firebase Remote Config

Make sure Firebase Remote Config values are properly loaded:

```dart
// Test this in any controller
final requiredVersion = Get.find<MellotippetFirebaseRemoteConfig>().getRequiredMinimumVersion();
final recommendedVersion = Get.find<MellotippetFirebaseRemoteConfig>().getRecommendedMinimumVersion();
final forceUpdate = Get.find<MellotippetFirebaseRemoteConfig>().getForceUpdateVersion();

print('Required: $requiredVersion');
print('Recommended: $recommendedVersion');
print('Force Update: $forceUpdate');
```

### 4. Common Issues

#### Issue: "No version checking happening"

**Solution:**

- ✅ Check if `permanent: true` is set when putting VersionService
- ✅ Check if Firebase Remote Config is initialized before VersionService
- ✅ Check if `GetxService` is properly extended
- ✅ Run the app and check logs for `[VERSION SERVICE]` messages

#### Issue: "Dialog never shows"

**Solution:**

- ✅ Check if `AppDialog` is properly initialized in service locator
- ✅ Check if version comparison is actually failing:
  ```
  if (appVersion < requiredMinVersion) { ... }
  ```
- ✅ Manually trigger by changing `pubspec.yaml` version to lower value for testing

#### Issue: "Error: GetxService not found"

**Solution:**

```dart
// Make sure VersionService extends GetxService
class VersionService extends GetxService { ... }

// NOT extends GetxController
// NOT extends ChangeNotifier
```

#### Issue: "Dialog shows but can't dismiss"

**Solution:**
This is expected for force updates. But if it's a recommended update:

- ✅ Check if `isForce: false` is being passed
- ✅ Check if `_isUpdateDialogShown` flag is being reset properly

## Testing Checklist

### Test 1: App Startup

- [ ] Open app → Check logs for `[VERSION SERVICE] Initializing...`
- [ ] Wait 500ms → See `[VERSION SERVICE] Running initial version check`
- [ ] See version comparison results

### Test 2: Version Check Results

- [ ] Logs show current version (e.g., `Current: 10001 (1.0.1)`)
- [ ] Logs show required/recommended from Firebase
- [ ] Result shows ✅, ⚠️, or ❌

### Test 3: App Resume (Pause/Resume App)

- [ ] Close app (pause to tray)
- [ ] Open app again
- [ ] Check logs for `[VERSION SERVICE] checkVersion() called`
- [ ] Version check should run again (unless within 5-minute throttle)

### Test 4: Force Update Dialog

To trigger force update for testing:

1. Manually change `pubspec.yaml` version to `0.0.1`
2. Rebuild app
3. Set Firebase Remote Config required version to `1.0.1`
4. App resumes
5. Dialog should appear and cannot be dismissed

### Test 5: Recommended Update Dialog

To trigger recommended update:

1. Keep current version as is (e.g., `1.0.0`)
2. Set Firebase Remote Config:
   - Required: `1.0.0` (same as current)
   - Recommended: `1.0.1` (higher than current)
3. App resumes
4. Dialog appears and CAN be dismissed

### Test 6: Play Store Return

1. Trigger update dialog (either force or recommended)
2. Click "Update" button → Play Store
3. Return to app WITHOUT updating
4. Dialog should re-appear ✓

## Debug Mode

Add this to main.dart for detailed logging:

```dart
void main() {
  // Enable debug logging
  AppUtils.enableDebugLogging();

  setupServices();
  runApp(const MyApp());
}
```

Then watch for all `[VERSION SERVICE]` messages.

## Still Not Working?

1. Check that these are initialized in order:
   - Firebase Remote Config ✅
   - DeviceInfo ✅
   - AppDialog ✅
   - VersionService ✅

2. Verify `permanent: true`:

   ```dart
   Get.put<VersionService>(..., permanent: true);
   ```

3. Check console/logcat for `[VERSION SERVICE]` messages

4. Verify Firebase values are not empty or null:

   ```
   getRequiredMinimumVersion() != null
   getRecommendedMinimumVersion() != null
   getForceUpdateVersion() != null
   ```

5. Make sure device info loads correctly:
   ```
   deviceInfo.packageInfo.version returns valid version string
   ```

## Contact for Help

If still having issues, check:

- iOS/Android version format in pubspec.yaml
- Firebase Remote Config is properly initialized
- All dependencies are in service locator
