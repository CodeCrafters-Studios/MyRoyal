# Attendance Home Screen Widget — TASK 08 Design

Branch `feature/attendance-home-widget` (cut from `fix/attendance-stabilization`, PR #46). Written 2026-11-19.
Decisions D1–D5 in §9 were **approved** on 2026-11-19 (recommended options). TASK 11 (the Flutter side) is implemented; see §11.

## 1. Verified starting point

| Area | Fact | Source |
|---|---|---|
| Flutter | 3.35.1 (FVM), Dart SDK `>=3.3.1` | `.fvm`, `pubspec.yaml` |
| Widget plugin | **none** (no `home_widget`) | `pubspec.yaml` |
| Android | AGP 8.6.1, Kotlin 2.3.10, Gradle 8.7, minSdk 25, compile/target 36, Java 17 | `android/settings.gradle`, `android/app/build.gradle` |
| Android flavors | `prod` (`com.myroyal`) and `dev` (`com.myroyal.dev`) | `build.gradle:64-77` |
| iOS | Deployment target 15.5; one app target plus RunnerTests; bundle `com.myroyal`; team `D6T55J4XB8`; no flavors | `ios/Podfile`, `project.pbxproj` |
| iOS entitlements | only `aps-environment`. **No App Group, no URL scheme.** | `Runner.entitlements`, `Info.plist` |
| Auth token | Hive `AppStorage` key `access_token`, sent as a Bearer header | `app_constants.dart:9`, `http_service.dart:145` |
| Logout | Deletes the access and refresh tokens | `settings/data/datasources/local_data.dart:19-29` |
| Session expiry | On an `"Unauthenticated."` response: dialog → delete tokens → `LOGIN` | `http_service.dart:385-394` |
| Startup gate | Splash → `InitialRouteImpl.route` (login / onboarding / bottom nav) | `splash_controller.dart:29-71` |
| Attendance tab | `BottomnavbarController.selectMenu(1)` inside an `IndexedStack` | `bottomnavbar_controller.dart:29` |
| Single point of backend truth | `AttendanceController._applyAttendanceToday` (every confirmed response) | EPIC 01 |
| Map snapshot API | `GoogleMapController.takeSnapshot()` is available (google_maps_flutter 2.10.1) | pub cache |
| Check-in / check-out | Require a **selfie with face detection** (`validation_selfie` module) | EPIC 01 audit |

## 2. Key constraint: what a widget can and cannot do

| Requirement | Native widget, headless | Opening the app |
|---|---|---|
| Check-in/out selfie + face detection | ❌ impossible (needs camera UI) | ✅ existing flow |
| GPS + geofence (reuse existing) | ⚠ needs **background location** (`ACCESS_BACKGROUND_LOCATION` on Android 10+; iOS "Always"), a Play/App Store review justification, and a second implementation | ✅ existing `_initLocation` stream and geofence |
| Auth (reuse existing) | ⚠ token must be copied to native or shared storage → wider attack surface; refresh logic would be duplicated | ✅ existing `HttpService` |
| Duplicate-action prevention | ⚠ would need a second lock | ✅ `_actionInProgress` and status validation |
| "No duplicate attendance business logic" (EPIC DoD) | ❌ | ✅ |

**Conclusion:** the widget is a **read-only display plus a launcher**. Every action opens the app on the attendance tab and runs the existing flow: confirm dialog → geofence → selfie or break POST → backend refetch. The widget never calls the API, never holds a token, and never reads GPS.

## 3. Architecture

```
 Backend ──► AttendanceController._applyAttendanceToday (EPIC 01, unchanged)
                   │ backend-confirmed state only
                   ▼
           AttendanceWidgetSync  (new, Flutter, ~1 file)
             • map state → WidgetPayload v1
             • HomeWidget.saveWidgetData / updateWidget
             • clear() on logout / session expiry
                   │ shared storage (no token)
     ┌─────────────┴──────────────┐
     ▼                            ▼
 Android Glance widget       iOS WidgetKit extension
 (SharedPreferences)         (App Group UserDefaults)
     │  tap = launch intent        │  tap = widgetURL / Link
     └─────────────┬───────────────┘
                   ▼  myroyal://attendance?action=<a>
           AttendanceWidgetLaunchHandler  (new, Flutter)
             • HomeWidget.initiallyLaunchedFromHomeWidget + widgetClicked
             • waits for auth gate + BOTTOMNAVBAR + first attendance load
             • selectMenu(1) → controller.handleWidgetAction(a)
                   ▼
           existing validationSelfie / startBreakTime / endBreakTime
```

### Plugin: `home_widget` (one new dependency)
- It covers both platforms: Android receivers (including a Glance base class), iOS App Group storage, launch URIs and a click stream. It is the de-facto standard and works with Flutter 3.35.
- Writing the same bridging by hand would mean two method channels plus launch-URI plumbing per platform. That is not justified.
- I'll pin the exact version when adding it in T09, after checking the changelog for AGP 8.6 and Kotlin 2.3.

### Flutter additions (no attendance logic duplicated)

| New code | Responsibility |
|---|---|
| `attendance/widget/attendance_widget_sync.dart` | Converts the controller state into the payload; `save()`, `clear()`, `saveMapSnapshot(bytes)` |
| `attendance/widget/attendance_widget_launch_handler.dart` | Parses the URI, holds the pending action until the app is ready, dispatches it, and debounces (same action within 2 s is ignored) |
| `AttendanceController.handleWidgetAction(String)` | Maps `check_in`/`check_out` → `validationSelfie`, `break_start` → `startBreakTime`, `break_end` → `endBreakTime`. All existing checks apply; an invalid action shows the existing "status sudah berubah" snackbar |
| Hook 1 | `_applyAttendanceToday` → `AttendanceWidgetSync.save(...)` (the only writer) |
| Hook 2 | `local_data.dart` logout + `http_service.dart` "Unauthenticated." branch → `AttendanceWidgetSync.clear()` |
| Hook 3 | After the map fits the office bounds → snapshot (see §5) |

## 4. Widget data contract — `attendance_widget_v1`

| Key | Type | Notes |
|---|---|---|
| `schema` | int | `1`; the native side ignores unknown versions |
| `signedIn` | bool | `false` after logout or expiry → "Masuk ke MyRoyal" state |
| `status` | string | backend value: `not_started`, `checked_in`, `break_start`, `break_end`, `checked_out` |
| `date` | `yyyy-MM-dd` | backend attendance date |
| `checkIn` / `checkOut` / `breakStart` / `breakEnd` | `HH:mm` or empty | display only |
| `workedMinutesAtSync` | int | from `computeWorkDuration` (EPIC 01), never negative |
| `breakEndsAtEpochMs` | int or 0 | end of the break allowance, for the countdown |
| `serverNowAtSyncEpochMs` / `syncedAtEpochMs` | int | used for the live timer and staleness |
| `officeName` | string | nearest office from the last session |
| `mapImage` | file path | snapshot PNG, or empty → placeholder |

**Not stored:** the token, name, NIK, employee ID or raw GPS coordinates. Widgets are visible to anyone who sees the home screen.

## 5. Map preview

| Option | Verdict |
|---|---|
| **A. In-app `takeSnapshot()`** of the attendance map after it fits the office bounds. Saved as a compressed PNG (`flutter_image_compress` is already a dependency) into shared storage, at most once per day or when office locations change | ✅ **Recommended.** No new API, no key exposure, no network from the widget. Non-GMS Android (flutter_map) gets a placeholder in v1 |
| B. Google Static Maps API from the widget | ❌ Needs a new API with billing, puts the key in the request URL, and requires network access from the widget |
| C. No map | Fallback if the Product Owner prefers |

Privacy: the attendance map has `myLocationEnabled: true` (`attendance_view.dart:560`), so the snapshot is taken with the camera on the office area. The blue dot may still appear if the user is on site. §9 D2 asks for confirmation.

## 6. States, actions and staleness

| Status | Widget shows | Buttons (each opens the app) |
|---|---|---|
| `signedIn=false` | "Masuk ke MyRoyal" | Buka |
| `not_started` | map, date | **Check In** |
| `checked_in` | map, "Masuk 08:00", live worked timer | **Check Out**, **Take a Break** |
| `break_start` | break countdown | **End Break** (enabled when the countdown ends; tapping early opens the app, which shows the countdown) |
| `break_end` | worked timer, break duration | **Check Out** |
| `checked_out` | total hours, completed | none (tap opens the app) |
| **stale** | last known values, greyed, "Ketuk untuk memperbarui" | none; tap opens the app |

- **Stale** means `date` is before today (computed from `serverNowAtSync + elapsed`), or the last sync is more than 12 h old. Action buttons are hidden while stale, so a previous day's state can never be acted on from the widget. Opening the app refreshes the state through EPIC 01's resume refetch.
- **Live time without polling:**
  - iOS: `Text(date, style: .timer)` and a timeline entry at the next midnight that switches to stale.
  - Android: Glance has no chronometer, so an `AndroidRemoteViews` `Chronometer` is embedded (base = now − worked; count-down mode for the break, API 24+, and minSdk is 25). A periodic update (30 min minimum) handles the stale switch.
- **No optimistic display:** the only writer is `_applyAttendanceToday`, so the widget changes only after backend confirmation, as TASK 11 requires.

## 7. Platform plans

### Android — TASK 09 (Glance: compatible ✅)
- Glance needs: the Kotlin Compose compiler plugin `org.jetbrains.kotlin.plugin.compose` 2.3.10 (matching Kotlin), `buildFeatures { compose true }`, and `androidx.glance:glance-appwidget` (1.1.x; requires minSdk 23, and we have 25). Changes are confined to `android/app/build.gradle` and `settings.gradle`.
- New files: `AttendanceGlanceWidget` + receiver (extends `home_widget`'s Glance receiver), `res/xml/attendance_widget_info.xml` (4×2, preview image, `updatePeriodMillis` 30 min), a layout for the chronometer `RemoteViews`, and manifest receiver entries.
- Taps use `HomeWidgetLaunchIntent` (explicit, targets the app's own package), so the `prod` and `dev` flavors installed side by side never collide. No new permissions.

### iOS — TASK 10 (WidgetKit: compatible ✅, iOS 14+; we target 15.5)
- New **Widget Extension** target `AttendanceWidget` (SwiftUI, deployment 15.5, `systemMedium`), embedded in Runner.
- **App Group** `group.com.myroyal` on Runner and the extension. ⚠ The App Group must be created in the Apple Developer portal and both provisioning profiles regenerated (team D6T55J4XB8). **This is a manual step for whoever owns the account.**
- Add URL scheme `myroyal` to `Info.plist` (`CFBundleURLTypes`). Buttons use `Link(destination:)`, which works on iOS 14+ in medium widgets.
- **AppIntents: not used in v1.** Interactive widget buttons need iOS 17 and would execute without opening the app, which conflicts with §2. They could be added later for a "refresh display" intent only.
- The extension uses no CocoaPods; it only reads `UserDefaults(suiteName:)` and the image file.

## 8. Security and safety

| Concern | Handling |
|---|---|
| Token exposure | Never leaves Hive; the widget has no network access |
| Logout or account switch | `clear()` → signed-out state; the next account's first fetch repopulates |
| Session expiry while the widget shows data | The data is display-only. Tapping opens the app → the existing "Unauthenticated." flow → `clear()` |
| Widget tap while logged out | The normal startup gate goes to login. **The pending action is dropped** (D4), so it is never replayed after a different user signs in |
| Duplicate submissions | Existing lock, debounce, and status validation |
| Stale state | Buttons hidden (§6) |
| Emulator block (prod) | The splash guard still applies; the widget cannot bypass it |

## 9. Decisions needed from the Product Owner (block T09/T10)

| # | Decision | Recommendation |
|---|---|---|
| D1 | Action model | **Every action opens the app** (§2). Headless break actions would need background location, so they are not proposed |
| D2 | Map preview | **In-app snapshot** (A). Confirm that the user's blue dot may appear in the snapshot when on site, or choose C |
| D3 | Sizes | Android 4×2 + iOS `systemMedium` in v1; a small "status only" size later |
| D4 | Widget tap while signed out | Drop the action after login (safer) |
| D5 | Apple Developer portal | Who creates the App Group `group.com.myroyal` and regenerates the profiles before T10 |

## 10. Effort and order (after approval)

1. **T11 Flutter side** (sync, launch handler, hooks) with unit tests — platform-independent, so it goes first.
2. **T09 Android** Glance widget.
3. **T10 iOS** extension (needs D5 done).
4. **T12 QA:** flutter tests for the payload, staleness and launch routing; manual checks on both platforms for every state, action, logout/switch, stale data across midnight, and fresh install.

## 11. TASK 11 — Flutter integration (implemented)

| File | What it does |
|---|---|
| `pubspec.yaml` | `home_widget: ^0.9.2+1` (0.10.0 needs a newer toolchain) |
| `attendance/widget/attendance_widget_sync.dart` | `AttendanceWidgetPayload` (contract v1, §4) and `AttendanceWidgetSync`: `save` / `clear` / `saveMapSnapshot`. Errors are swallowed, so the widget can never break attendance |
| `attendance/widget/attendance_widget_launch_handler.dart` | Parses `myroyal://attendance?action=…`. D4 drops taps made while signed out. Taps wait for the attendance screen, expire after 2 min, and repeats within 2 s are ignored |
| `attendance/widget/attendance_widget_bootstrap.dart` | Startup wiring: App Group, sign-in check, and opening the tab (pops back to the bottom nav first) |
| `attendance_controller.dart` | `_syncWidget()` is called only from `_applyAttendanceToday` and when the nearest office becomes known. `handleWidgetAction()` waits for `areActionsReady`, re-checks the allowed status (and the break countdown for End Break), then calls the **existing** `validationSelfie` / `startBreakTime` / `endBreakTime`, so the user still confirms. The daily map snapshot (D2) is a JPEG of about 640×320 |
| `bottomnavbar_controller.dart` | On a cold start with a pending tap, `onReady` selects the attendance tab |
| `settings/.../local_data.dart`, `base/services/http_service.dart` | Logout and "Unauthenticated." both call `AttendanceWidgetSync.clear()` |
| `base/initialization/app_setup.dart` | `startAttendanceWidget()` after `runApp` |

Native identifiers the T09/T10 widgets must use:
- Data key `attendance_widget_v1` (JSON) and map key `attendance_widget_map` (file path)
- Android receiver `com.myroyal.widget.AttendanceWidgetReceiver`
- iOS kind `AttendanceWidget`
- App Group `group.com.myroyal`
- Link URIs `myroyal://attendance?action=check_in|break_start|break_end|check_out`

Tests: `test/attendance/widget/` has 30 tests covering the payload contract, sync failure isolation, the once-a-day snapshot, URI parsing, D4, debounce, expiry, the cold-start tap, and the controller integration (confirmed-only publishing, midnight reset, failed POST not published, a tap waiting for GPS and then showing the normal confirm dialog, invalid or early actions rejected). Full suite: **99/99 pass**. `flutter analyze lib test/attendance`: clean.

Until T09/T10 add the native widgets, `updateWidget` fails quietly (logged) and nothing changes for users.
