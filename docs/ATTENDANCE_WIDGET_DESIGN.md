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

**Not stored:** the token, name, NIK, employee ID or raw GPS coordinates. Widgets are visible to anyone who sees the home screen. Since §14 the user's position is published only as a dot position on the map image (0–1 fractions), plus the app's own inside/outside result and the fix time.

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

## 12. TASK 09 — Android widget (implemented)

| File | What it does |
|---|---|
| `android/settings.gradle`, `android/app/build.gradle` | Compose compiler plugin 2.3.10 (matches Kotlin), `buildFeatures.compose`, `glance-appwidget:1.1.1` (same version as home_widget). JUnit and org.json are test-only |
| `kotlin/com/myroyal/widget/AttendanceWidgetData.kt` | Parses payload v1 and rejects missing, malformed or unknown-schema data |
| `kotlin/com/myroyal/widget/AttendanceWidgetState.kt` | Pure resolver: state → title, timer, buttons, stale rule (§6), next refresh time |
| `kotlin/com/myroyal/widget/AttendanceGlanceWidget.kt` | Glance UI: map image or placeholder, office, status, live `Chronometer` (embedded `RemoteViews`), buttons. Every click is `actionStartActivity<MainActivity>(myroyal://attendance?action=…)` |
| `kotlin/com/myroyal/widget/AttendanceWidgetReceiver.kt` | `HomeWidgetGlanceWidgetReceiver`, plus one **inexact** `AlarmManager` refresh at the next state change (midnight → stale, break allowance end, 12 h max age). No new permissions |
| `res/xml/attendance_widget_info.xml`, `res/layout/attendance_widget_chronometer.xml`, `res/values(-night)/attendance_widget.xml` | 4×2 provider, chronometer view, label, description and colors |
| `AndroidManifest.xml` | Receiver registration, and **`flutter_deeplinking_enabled=false`** (see below) |

**Bugs found while testing on the emulator, both fixed:**
1. Launching from the widget gave a **red screen**: "GlobalKey used multiple times (NavigatorState)". Flutter's default Android deep linking pushed the `myroyal://` URI as a route into GetX's navigator. It's now disabled in the manifest; `home_widget` delivers the URI. **T10 must set `FlutterDeepLinkingEnabled = NO` in iOS `Info.plist` for the same reason.**
2. Widget data was read outside `provideContent`, so `updateWidget` recomposed a running session with stale values (for example, still showing "Check In" after logout). It now reads `currentState<HomeWidgetGlanceState>()` inside the composition, which is home_widget's documented pattern.

**Verification**

| Check | Result |
|---|---|
| Android unit tests `./gradlew :app:testDevDebugUnitTest --tests 'com.myroyal.widget.*'` | 14/14 pass (parsing, every status, timers, staleness, midnight and clock skew, format) |
| `flutter build apk --debug --flavor dev` | builds |
| Emulator (Pixel_6, API 31, dev flavor): widget picker lists "Kehadiran 4 × 2" with its description | ✅ |
| Rendered with seeded test payloads: no data, signed out, not started (with and without map), checked in (live 2:34:xx), on break (29:5x countdown), break over (End Break), break end, checked out (`08h 00m`), stale (greyed, no buttons) | ✅ all match §6 |
| Tap Check In / Check Out: MainActivity starts with `myroyal://attendance?action=check_in` / `check_out` (cold and warm) | ✅ |
| Cold start from the widget opens the **Kehadiran** tab | ✅ |
| Tap while signed out: login screen, action not replayed (D4) | ✅ |
| "Unauthenticated." → widget data becomes `signedIn:false`, map removed | ✅ (storage checked) |
| Live in-app refresh of a running widget session after a real attendance action | ⚠ needs a signed-in staging account, so it moves to T12 |
| prod flavor / release build | ⚠ not built here (same sources; needs the release keystore), so it moves to T12 |

Note: the emulator's dev app was downgraded from 1.5.5 to this branch's 1.5.3 build for testing.

## 13. Physical device test — Samsung SM-A336E (Android 12, One UI), dev flavor

Date 2026-11-19, against `dev-api.royalcorp.co.id`. The device already had a signed-in session ("Admin It Hrms"), so no credentials were entered.

| Check | Result |
|---|---|
| Install the dev debug build of `feature/attendance-home-widget` (prod app 1.5.7 untouched) | ✅ |
| Attendance tab loads the real backend state (not_started, inside "GEDUNG A" geofence, GPS active) | ✅ |
| App writes payload v1 with no identity, token or GPS: `{"status":"not_started","date":"2026-11-19","officeName":"GEDUNG A",...}` | ✅ |
| Real `takeSnapshot()` map image saved (640×558 JPEG, 24 KB; geofence and blue dot, per D2) | ✅ |
| One UI widget picker shows "Kehadiran 4 × 2"; added to the home screen | ✅ |
| Widget renders real data: office, "Belum check-in", map snapshot, Check In button | ✅ |
| Widget **Check In** → app opens on the Kehadiran tab → the **existing** confirm dialog ("Mohon persiapkan diri untuk mengambil foto") | ✅ |
| Cancelling the dialog records nothing; status stays `not_started` | ✅ |
| Live widget update after a real backend-confirmed transaction: the employee checked in (selfie flow) and the payload became `checked_in`, `checkIn 10:54`. With the **same app process still running**, the widget switched to "Sedang bekerja · Masuk 10:54", the live timer was running, and it showed Check Out and Take a Break | ✅ (confirms the T09 `currentState` fix on hardware) |

Observation: the device clock was about 2 min behind the server (check-in 10:54 against a phone clock of 10:53). The widget timer and staleness use the server clock from the payload, so the display stays consistent.

## 14. Change request: full-screen map + location while the app is in use (options A + B)

Approved 2026-11-19. Option C (background tracking) was rejected: it needs "always" location permission, store review and HR consent, and it would reverse D1.

| Aspect | Implementation |
|---|---|
| Layout | The map image fills the whole widget (`ContentScale.Crop`). A translucent status card is top-left, the location chips top-right, and the action buttons along the bottom |
| A: last known location | Blue dot plus "Lokasi HH:mm" from the last GPS fix while the app was in use |
| B: live while in use | Every accepted fix (accuracy ≤ 25 m, the existing filters) updates the widget, **throttled to 30 s**. A change between inside and outside the geofence is published immediately. The GPS stream only runs while the app is in the foreground (EPIC 01), so nothing tracks in the background and no permissions changed |
| Inside/outside badge | The app's **existing** `isLocationValid` result, not reimplemented natively. Shown only while the fix is under 15 min old and the attendance data isn't stale. Display only: actions still re-validate in the app |
| Privacy | No coordinates are stored for the widget. Dart projects the fix onto the snapshot using the snapshot's `getVisibleRegion()` bounds (Web Mercator) and stores only `mapDotX`/`mapDotY` (0–1), `insideArea` (1/0/−1) and `locationAtEpochMs`. Nothing is published while GPS spoofing is detected |
| Snapshot | Once per day per app process. The camera is held on the office bounds (`newLatLngBounds`, so bearing and tilt are 0). The in-app my-location layer is hidden for about 0.4 s so the old dot isn't baked into the image. The bounds are kept with the image; no dot is shown until bounds exist |
| Dot rendering | Drawn **into the bitmap** on the Android side, so it stays correct after cropping. Grey when the fix is older than 15 min; a refresh is scheduled for that moment |
| Payload | Additive fields, schema still 1; older payloads parse with defaults |

Tests: Dart covers projection (centre, corners, north-up, off-image), payload defaults, bounds lifecycle, controller throttle and the immediate inside/outside change, no location while spoofing, and dot placement once bounds exist (90/90 attendance tests). Kotlin covers fresh vs old fix, badge, refresh at the freshness limit, stale attendance hiding the badge, off-image dot, and older payload compatibility (21/21).

Device check (SM-A336E, real session, checked in): payload `mapDotX 0.409, mapDotY 0.536, insideArea 1`. The widget shows the full-screen map with a drawn blue dot, "Di dalam area", "Lokasi 11:10", "Sedang bekerja · Masuk 10:54" with the timer running, and Check Out / Take a Break. The new snapshot has no baked-in dot. ✅
