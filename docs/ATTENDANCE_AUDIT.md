# Attendance Audit — TASK 01

Audited on branch `v1.4.0` (HEAD `9635a36d`), 2026-11-19. Read-only; no code changed.
Paths are relative to `lib/app/modules/attendance/` unless noted.

## 1. Architecture

| Layer | File | Notes |
|---|---|---|
| Datasource | `data/datasources/remote_data.dart` | `GET myroyalattendance/today`, `POST myroyalattendance/record_attendance`, `GET myroyalattendance/location` |
| Repository | `data/repositories/attendance_repository_impl.dart` | Wraps every error in `ServerFailure` (no network/server distinction) |
| Use cases | `domain/usecases/*.dart` | Thin pass-through (today / record / location) |
| Models | `data/models/attendance_today_model.dart` | Times are `HH:mm:ss` strings; `date` and `server_time` come from backend |
| Controller | `presentation/controllers/attendance_controller.dart` (1260 lines) | Holds all state, timers, GPS, geofence, map camera, and break/checkout actions |
| View | `presentation/views/attendance_view.dart` (868 lines) | Includes `AttendanceMap` (Google) and `AttendanceFlutterMap` (no-GMS fallback) |
| Selfie / check-in / check-out | `lib/app/modules/validation_selfie/controllers/validation_selfie_controller.dart:359` | Check-in and check-out POSTs are sent from here; break start/end are sent from the attendance controller |
| DI | `lib/app/modules/bottomnavbar/presentation/bindings/bottomnavbar_binding.dart:324` (`fenix: true`), plus `presentation/bindings/attendance_binding.dart` and `validation_selfie_binding.dart:41` | The controller is registered in 3 places |
| Host | `bottomnavbar_view.dart:45` `IndexedStack` | The tab stays alive, so the controller lives as long as the process does |
| Local cache | none | No attendance persistence. State lives only in memory |

**Backend statuses → `AttendanceStatus`** (`attendance_controller.dart:23-46`): `checked_in`, `break_start`, `break_end`, `checked_out`. Anything else (including `not_started` and `''`) becomes `notStarted`.

**Actions per state** (`attendance_view.dart:184-343`): notStarted → Check In · checkedIn → Check Out + Take a Break · breakStart → End Break (only after the countdown ends) · breakEnd → Check Out · checkedOut → none.

## 2. Findings (verified in code)

| # | Severity | Finding | Location | Affects |
|---|---|---|---|---|
| F1 | **P0** | `WidgetsBindingObserver` is mixed in but **`addObserver(this)` is never called**, so `didChangeAppLifecycleState` never runs and the resume refresh is dead code. | controller `:48`, `:157-163` | T02 |
| F2 | **P0** | `_getAttendanceToday` only **sets** fields when the response has them and never **clears** them. After the cron reset (nulls), the old `checkInTime`, `checkOutTime`, `breakTime`, `breakEndTime` and `breakDuration` stay in memory. | controller `:366-450` | T02, T03, T04 |
| F3 | **P0** | **Root cause of `00h -12m`:** on a new day, the stale break pair from yesterday (e.g. 60 min) is subtracted from today's live duration: `dif = now − checkIn − (breakEnd − breakStart)`. At 08:48 after an 08:00 check-in this gives −12 min, which formats as `00h -12m` because `inMinutes.remainder(60)` is negative. There is no clamp. | controller `:703-716`, `:774-783` | T03 |
| F4 | P0 | The negative or stale `workDurationMinutes` is **sent to the backend** on check-out. | controller `:712`, `:743`; selfie `:379` | T03 |
| F5 | P1 | `_loadInitialData` decides whether to reset based on the **stale pre-fetch** status, so the reset is skipped when yesterday ended as `checked_out`. | controller `:185-200` | T02/T03 |
| F6 | P1 | All `HH:mm:ss` values are anchored to the **device date** (`DateTime.now()`), not the backend `date`. `_serverTime` is synced only when the timer restarts. `_lastDisplayTime` (the monotonic guard) is never reset, so the clock can freeze after a backward re-sync. | controller `:372-430`, `:629-685`, `:850-861` | T03 |
| F7 | P1 | Offline detection is dead code. `HttpService` emits `"Tidak ada koneksi"` / `"Terhubung"`, but attendance compares against `"No connection"`. `_runInitialOnce` is a no-op after the first run, so reconnecting never refetches. | controller `:130-136`, `:179`; view `:42`; `lib/base/services/http_service.dart:105-111` | T02 |
| F8 | P1 | A failed `GET today` is ignored silently (`(l) {}`). The UI keeps stale state with no feedback. | controller `:367` | T02/T04 |
| F9 | P1 | **Location stream leak:** every `_getAttendanceToday` call runs `_initLocation` → `_startLocationStream`, which creates a new subscription without cancelling the previous one. Multiple 1 Hz GPS streams pile up. | controller `:453`, `:522-537` | T06 |
| F10 | P1 | After any selfie return other than a check-in success (including the user backing out), the GPS stream is cancelled. `currentPosition` and `isLocationValid` stay frozen at the last value. | controller `:747-754` | T04/T06 |
| F11 | P1 | **Shimmer is a fixed `notStarted` layout** (map + clock + round Check In button) and **replaces the whole body** whenever `isLoadingAttendance` is true. This covers initial load, pull-to-refresh, every break action and every post-action refetch. | view `:39-45`, `:456-530` | T05 |
| F12 | P1 | Because of F11, the map widget is disposed and re-created on every refresh or action (`dispose` nulls `googleMapController` and `isMapReady`). This causes map reinitialization and flicker. | view `:39-45`, map state `dispose` (~view `:559`) | T06 |
| F13 | P2 | `isLoadingAttendance` is a single flag shared by `_getAttendanceLocation` and `_getAttendanceToday`, which run concurrently. Whichever finishes first clears it. | controller `:211/296`, `:362/454` | T05 |
| F14 | P2 | `officePolygons` is never cleared before rebuilding, so polygons are duplicated on every location reload. | controller `:227-228`, `:264` | T06 |
| F15 | P2 | `hasTakenBreak` is never set to `true`, so the client-side duplicate-break guard has no effect. `startBreakTime` sets `breakTime` optimistically before the POST and does not roll it back on failure. | controller `:803-808`, `:828-831` | T04 |
| F16 | P2 | `onRefresh` does not await `_loadInitialData`, so the refresh indicator closes immediately. | controller `:202-208` | T05/T06 |
| F17 | P2 | When `nearestOffice` is null, `_getNearestLocationId` crashes on `!`. `attendanceId!` and `currentPosition!` have the same risk. | controller `:813-819`, `:1185-1189` | T04 |
| F18 | P2 | The 1 s `_timer` runs whenever the tab exists, in every state (including notStarted and checkedOut). It ticks `displayTime`, which rebuilds the `Obx`. | controller `:665-673` | T06 |
| F19 | P3 | `_buildTimesInfo` uses the device date (`DateTime.now()`) rather than the backend `date`. | view `:177-179` | T03 |
| F20 | info | Records send device `date` with a server-derived `time`. This is a backend contract, so it is not changed here and only noted. | selfie `:375-376`; controller `:816`, `:945` | — |

## 3. Root-cause summary

- **T02 (stale after midnight):** F1 + F2 + F5 + F7. The process survives overnight in the `IndexedStack`, nothing refetches on resume, and even a refetch would keep stale fields.
- **T03 (negative duration):** F2 → F3, made worse by F6. Fix: reset all derived fields from each response, derive everything from backend `date`/`server_time`, and clamp at ≥ 0 as a safety net. Not a timezone bug.
- **T05/T06 (shimmer/flicker/map):** F11 + F12 + F13. Separate initial load from background refresh.

## 4. Assumptions to confirm (not verifiable from client code)

- Exact `status` string the backend returns after cron (`not_started` vs `''`). The client maps both the same way.
- Whether `checked_in_time` and the other times come back as `null` or `""` after reset. `""` would throw in `DateFormat.parse`, which is not caught at `:375`.
- Server timezone of `server_time` (assumed to match the check-in times, since all come from one backend).

## 5. Test coverage

There are no attendance tests. `test/` contains only OCR tests and `widget_test.dart`.

## 6. T02 + T03 implementation (branch `fix/attendance-stabilization`, uncommitted)

| Finding | Fix |
|---|---|
| F1 | `addObserver` in `onInit`, `removeObserver` in `onClose`. On resume the app refetches silently, throttled to once per 30 s; a previous-day record is always refetched. `_initLocation` still runs on resume. |
| F2/F5 | New `_applyAttendanceToday` overwrites **every** day-specific field from each response, including nulls: times, break, `hasTakenBreak`, break countdown, total hours, end-day message. The stale pre-fetch reset was removed. |
| F3/F4 | `computeWorkDuration` / `formatHoursMinutes` (`utils/attendance_time.dart`) clamp at ≥ 0, so a negative value is never shown or sent. |
| F6 | All times are anchored to backend `date` (device date only as fallback). A value more than 1 h earlier than check-in rolls to the next day (night shift, server clock after midnight); smaller gaps are treated as clock skew. Server clock is re-synced on every fetch, and the monotonic guard is re-based. `""` or invalid times return null instead of throwing. |
| F7 | Uses the real offline string. Going offline keeps the last state visible (shimmer only if nothing has loaded yet) and disables actions. Reconnecting triggers a silent refetch. |
| — | While the screen is open, if the server clock passes midnight with a previous-day record still shown, the app retries silently up to 3×, 2 min apart (covers a late cron). Nothing runs in the background. |
| — | A newer request always wins: stale responses are dropped by sequence number. |
| F9 | `_startLocationStream` cancels the previous subscription first. |

Tests: `test/attendance/attendance_time_test.dart` (14 cases, including the `-12m` regression and the night shift). Full suite: 35/35 pass. `flutter analyze` on the module: clean.

Not yet verified on a device. Remaining for T04–T06: F8, F10–F18 (the pull-to-refresh and action shimmer is unchanged).
Out of scope, but the same bug exists elsewhere: `home_controller.dart:118,133` also compares against `"No connection"`.

## 7. T04–T07 implementation (branch `fix/attendance-stabilization`, uncommitted)

| Finding | Task | Fix |
|---|---|---|
| F8 | T04 | A failed fetch now shows a snackbar for user-initiated loads; background refreshes fail silently. If the first load fails, the screen shows an error state with **Coba Lagi** and pull-to-refresh, instead of a fake not_started screen. |
| F10 | T04 | The GPS stream is stopped only once the refetched status is `checked_out`. Backing out of the selfie screen no longer freezes the location. |
| F15 | T04 | Break start/end apply nothing optimistically. The UI changes only through the backend refetch. A failed POST is also followed by a refetch, in case the server stored it. |
| F17 | T04 | `_ensureActionAllowed` guards every action. It waits for any refresh in flight, then checks that the action is valid for the **latest** status (`checked_in`←notStarted, `break_start`←checkedIn, `break_end`←breakStart, `checked_out`←checkedIn/breakEnd), that the device is inside the geofence, and that a position and nearest office exist. Missing `server_time` blocks the selfie flow. The `!` crashes are gone. |
| — | T04 | The `_actionInProgress` lock means repeated taps submit only once. |
| F11/F13 | T05 | The full-screen placeholder appears only while nothing has loaded yet. It is neutral (the state is unknown), so it is never a fake Check In layout. Pull, resume, reconnect and post-action refreshes keep the content on screen. While an action runs, only the action area shows `AttendanceActionShimmer(status)`, shaped like that state's buttons: the Check In circle, Check Out + Break, End Break, Check Out, or nothing. The location fetch no longer toggles the page loading flag. |
| F16 | T05 | `onRefresh` is awaited, so the indicator stays until the data arrives. |
| F12 | T06 | The map is no longer torn down on refresh. The map slot and the action rows have their own `Obx`, so a GPS update no longer rebuilds the whole page. |
| F14 | T06 | Polygons are cleared before rebuilding. |
| F18 | T06 | On `paused`: stop the clock timer, the break timer and the GPS stream. On `resumed`: restart them. In `checked_out`, the per-second clock rebuild is skipped. |
| F21 (new) | T06 | `_fitMapBounds` re-scheduled itself every 200 ms forever when no map was built (the `checked_out` layout). Bounds are now stored and applied when `isMapReady` turns true. |
| F22 (new) | T06 | A post-frame break countdown, and async continuations, could start timers or streams after `onClose` (logout). Guarded with `isClosed`. Found by the tests. |
| — | T06 | GPS/permission dialogs are not stacked on resume. Turning GPS off or revoking permission invalidates the last position, so actions are disabled. Allowing permission from the dialog now starts the stream. |
| F19 | T06 | The date line uses the server clock. |

Cold-start placeholder decision: the last status is **not** persisted. A cached status could show the previous account's state after logout or an account switch. The cost is a neutral placeholder on cold start. This needs Product Owner sign-off if a state-specific cold-start shimmer is required.

### T07 regression results

The tests are in `test/attendance/`: `attendance_time_test.dart` (14), `attendance_shimmer_test.dart` (8) and `attendance_controller_test.dart` (29). They run the real controller with a fake repository and fake GPS (`attendance_test_fakes.dart`). Full suite: **69/69 pass**. `flutter analyze` on attendance, validation_selfie, bottomnavbar and the tests: clean.

| Scenario | Automated |
|---|---|
| Initial `not_started` | ✅ |
| Break start success / failure / duplicate taps / invalid state | ✅ |
| Break end success | ✅ |
| Check-in / check-out (selfie screen) | ⚠ guard path only; the selfie POST needs manual testing |
| Failed requests (first load, background refresh) | ✅ |
| GPS disabled / permission denied forever | ✅ |
| Outside geofence / low accuracy / mock location | ✅ |
| Network unavailable at launch and mid-session, reconnect | ✅ |
| Minimised and resumed (throttle, previous-day refetch, GPS/timer pause) | ✅ |
| Midnight reset, previous-day vs new-day, the `-12m` regression, night shift | ✅ |
| Out-of-order responses | ✅ |
| Shimmer per state | ✅ (component level) |
| Terminated and reopened | ⚠ manual: a cold start is the same path as the initial load |
| Foreground across real midnight (bounded retry) | ⚠ manual: uses the wall clock |

### Manual device checklist (still needed before PO approval)

1. Check in, check out and both break actions on Android and iOS, against staging.
2. Leave the app minimised across 00:00, then reopen. It should show not_started without pulling to refresh.
3. Keep the screen open across 00:00. It should reset within about 2–6 minutes of the cron running.
4. Fully close the app and reopen it, both in checked_in and in checked_out state.
5. Turn GPS off, then on, while the app is in the background.
6. Use airplane mode on the attendance screen. The last state should stay and actions should be disabled.
7. Visually check the action-area shimmer for each state, and confirm the map does not flicker on pull-to-refresh.

Known, not changed (backend contract, F20): records still send the device `date`/`time`. The selfie POST still uses the `server_time` from the last fetch.
