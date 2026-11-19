import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';

import 'attendance_test_fakes.dart';

/// Regression tests for EPIC 01 (attendance stabilization). Backend and GPS
/// are faked; the controller and its real state logic are exercised.
void main() {
  Future<void> run(
    WidgetTester tester,
    Future<void> Function(Harness h) body, {
    void Function(Harness h)? setup,
  }) async {
    final h = Harness(tester);
    setup?.call(h);
    await h.start();
    try {
      await body(h);
    } finally {
      await h.dispose();
    }
  }

  group('initial load & state mapping', () {
    testWidgets('not_started: no duration, check-in state', (tester) async {
      await run(tester, (h) async {
        final c = h.controller;
        expect(c.hasAttendanceData, isTrue);
        expect(c.isLoadingAttendance.value, isFalse);
        expect(c.attendanceStatus.value, AttendanceStatus.notStarted);
        await tester.pump(const Duration(seconds: 1));
        expect(c.liveWorkDuration.value, '--:--');
        expect(c.checkInTime.value, isNull);
      });
    });

    testWidgets('maps every backend status', (tester) async {
      final cases = {
        'checked_in': AttendanceStatus.checkedIn,
        'break_start': AttendanceStatus.breakStart,
        'break_end': AttendanceStatus.breakEnd,
        'checked_out': AttendanceStatus.checkedOut,
        'not_started': AttendanceStatus.notStarted,
        '': AttendanceStatus.notStarted,
      };
      for (final e in cases.entries) {
        expect(AttendanceStatusX.fromString(e.key), e.value, reason: e.key);
      }
    });

    testWidgets('checked_in with completed break: live duration',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
            status: 'break_end',
            checkIn: '08:00:00',
            breakStart: '12:00:00',
            breakEnd: '13:00:00',
            serverTime: '14:30:00',
          )));
      }, (h) async {
        await tester.pump(const Duration(seconds: 1));
        expect(h.controller.liveWorkDuration.value, '05h 30m');
        expect(h.controller.breakDuration.value, '01h 00m');
      });
    });

    testWidgets('checked_out: total hours from backend times',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
            status: 'checked_out',
            checkIn: '08:00:00',
            breakStart: '12:00:00',
            breakEnd: '13:00:00',
            checkOut: '17:00:00',
            serverTime: '17:05:00',
          )));
      }, (h) async {
        expect(h.controller.totalHours.value, '08h 00m');
        expect(h.controller.workDurationMinutes.value, 480);
        expect(h.controller.endDayMessage.value, isNotEmpty);
      });
    });

    testWidgets('first load failure shows error state, retry recovers',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..addAll([failure(), Right(todayResponse())]);
      }, (h) async {
        final c = h.controller;
        expect(c.hasAttendanceData, isFalse);
        expect(c.hasLoadError.value, isTrue);
        expect(c.isLoadingAttendance.value, isFalse);

        await c.onRefresh();
        await h.settle();
        expect(c.hasAttendanceData, isTrue);
        expect(c.hasLoadError.value, isFalse);
      });
    });
  });

  group('midnight reset (TASK 02/03)', () {
    testWidgets('reset to not_started clears every previous-day field',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..addAll([
            Right(todayResponse(
              status: 'checked_out',
              date: '2026-11-18',
              checkIn: '08:00:00',
              breakStart: '12:00:00',
              breakEnd: '13:00:00',
              checkOut: '17:00:00',
              serverTime: '17:05:00',
            )),
            Right(todayResponse(
                status: 'not_started', serverTime: '00:05:00')),
          ]);
      }, (h) async {
        final c = h.controller;
        expect(c.attendanceStatus.value, AttendanceStatus.checkedOut);

        await c.onRefresh();
        await h.settle();
        await tester.pump(const Duration(seconds: 1));

        expect(c.attendanceStatus.value, AttendanceStatus.notStarted);
        expect(c.checkInTime.value, isNull);
        expect(c.checkOutTime.value, isNull);
        expect(c.breakTime.value, isNull);
        expect(c.breakEndTime.value, isNull);
        expect(c.breakDuration.value, '');
        expect(c.hasTakenBreak.value, isFalse);
        expect(c.endDayMessage.value, '');
        expect(c.liveWorkDuration.value, '--:--');
        expect(c.workDurationMinutes.value, 0);
      });
    });

    testWidgets('regression: previous-day break no longer gives 00h -12m',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..addAll([
            Right(todayResponse(
              status: 'checked_out',
              date: '2026-11-18',
              checkIn: '08:00:00',
              breakStart: '12:00:00',
              breakEnd: '13:00:00',
              checkOut: '17:00:00',
              serverTime: '17:05:00',
            )),
            Right(todayResponse(
              status: 'checked_in',
              date: '2026-11-19',
              checkIn: '08:00:00',
              serverTime: '08:48:00',
            )),
          ]);
      }, (h) async {
        await h.controller.onRefresh();
        await h.settle();
        await tester.pump(const Duration(seconds: 1));

        expect(h.controller.liveWorkDuration.value, '00h 48m');
        expect(h.controller.workDurationMinutes.value, 48);
      });
    });

    testWidgets('night shift across midnight counts forward',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
            status: 'checked_in',
            date: '2026-11-18',
            checkIn: '22:00:00',
            serverTime: '01:00:00',
          )));
      }, (h) async {
        await tester.pump(const Duration(seconds: 1));
        expect(h.controller.liveWorkDuration.value, '03h 00m');
      });
    });
  });

  group('lifecycle & connectivity', () {
    testWidgets('resume within throttle does not refetch same-day record',
        (tester) async {
      await run(tester, (h) async {
        final before = h.repo.todayCalls;
        h.controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await h.settle();
        expect(h.repo.todayCalls, before);
      });
    });

    testWidgets('resume always refetches a previous-day record',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..addAll([
            Right(todayResponse(
              status: 'checked_out',
              date: '2026-11-18',
              checkIn: '08:00:00',
              checkOut: '17:00:00',
              serverTime: '00:10:00', // server already on the next day
            )),
            Right(todayResponse(status: 'not_started')),
          ]);
      }, (h) async {
        final before = h.repo.todayCalls;
        h.controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await h.settle();
        expect(h.repo.todayCalls, before + 1);
        expect(h.controller.attendanceStatus.value,
            AttendanceStatus.notStarted);
      });
    });

    testWidgets('pause stops GPS stream, resume restarts exactly one',
        (tester) async {
      await run(tester, (h) async {
        expect(h.geo.activeListeners, 1);
        h.controller.didChangeAppLifecycleState(AppLifecycleState.paused);
        await h.settle();
        expect(h.geo.activeListeners, 0);
        h.controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await h.settle();
        expect(h.geo.activeListeners, 1);
      });
    });

    testWidgets('repeated refresh/resume never stacks GPS subscriptions',
        (tester) async {
      await run(tester, (h) async {
        for (var i = 0; i < 3; i++) {
          await h.controller.onRefresh();
          h.controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
          await h.settle();
        }
        expect(h.geo.streamsOpened, greaterThan(1));
        expect(h.geo.activeListeners, 1);
      });
    });

    testWidgets('offline keeps state & disables actions; reconnect refetches',
        (tester) async {
      await run(tester, (h) async {
        await h.makeActionsReady();
        final c = h.controller;
        expect(c.areActionsReady, isTrue);

        h.connection.value = offlineStatus;
        await h.settle();
        expect(c.hasAttendanceData, isTrue, reason: 'last state kept');
        expect(c.areActionsReady, isFalse);

        final before = h.repo.todayCalls;
        h.connection.value = onlineStatus;
        await h.settle();
        expect(h.repo.todayCalls, before + 1);
        expect(c.areActionsReady, isTrue);
      });
    });

    testWidgets('offline at launch: no request until connected',
        (tester) async {
      await run(tester, setup: (h) => h.connection.value = offlineStatus,
          (h) async {
        expect(h.repo.todayCalls, 0);
        expect(h.controller.hasAttendanceData, isFalse);
        h.connection.value = onlineStatus;
        await h.settle();
        expect(h.repo.todayCalls, 1);
        expect(h.controller.hasAttendanceData, isTrue);
      });
    });

    testWidgets('failed background refresh keeps previous state',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..addAll([
            Right(todayResponse(status: 'checked_in', checkIn: '08:00:00')),
            failure(),
          ]);
      }, (h) async {
        h.connection.value = offlineStatus;
        await h.settle();
        h.connection.value = onlineStatus; // silent refresh -> failure
        await h.settle();
        expect(h.controller.attendanceStatus.value,
            AttendanceStatus.checkedIn);
        expect(h.controller.checkInTime.value, isNotNull);
      });
    });

    testWidgets('out-of-order responses: newest request wins',
        (tester) async {
      await run(tester, (h) async {
        final slow = Completer<TodayResult>();
        h.repo.nextTodayGate = slow;
        unawaited(h.controller.onRefresh()); // older request, held
        await h.settle();

        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(status: 'checked_in', checkIn: '08:00:00')));
        await h.controller.onRefresh(); // newer request
        await h.settle();

        slow.complete(Right(todayResponse(status: 'not_started')));
        await h.settle();
        expect(h.controller.attendanceStatus.value,
            AttendanceStatus.checkedIn);
      });
    });
  });

  group('GPS & geofence', () {
    testWidgets('inside radius is valid, far away is not', (tester) async {
      await run(tester, (h) async {
        final c = h.controller;
        h.geo.emit();
        await h.settle();
        expect(c.isLocationValid.value, isTrue);
        expect(c.nearestOffice.value?.locationId, 7);

        h.geo.emit(lat: officeLat + 0.05); // ~5.5 km, smoothed ~1 km
        await h.settle();
        expect(c.isLocationValid.value, isFalse);
      });
    });

    testWidgets('low accuracy fixes are ignored', (tester) async {
      await run(tester, (h) async {
        h.geo.emit(accuracy: 80);
        await h.settle();
        expect(h.controller.currentPosition.value, isNull);
      });
    });

    testWidgets('mock location flags spoofing and disables button',
        (tester) async {
      await run(tester, (h) async {
        h.geo.emit(mocked: true);
        await h.settle();
        expect(h.controller.isGpsSpoofing.value, isTrue);
        expect(h.controller.buttonEnabled.value, isFalse);
      });
    });

    testWidgets('GPS disabled: invalid location and a single dialog',
        (tester) async {
      await run(tester, setup: (h) => h.geo.serviceEnabled = false,
          (h) async {
        final c = h.controller;
        expect(c.isGpsActive.value, isFalse);
        expect(c.isLocationValid.value, isFalse);
        expect(Get.isDialogOpen, isTrue);

        // Resume while the dialog is open must not stack another one.
        c.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await h.settle();
        Get.back();
        await h.settle();
        expect(Get.isDialogOpen, isFalse);
      });
    });

    testWidgets('permission denied forever: no stream, settings dialog',
        (tester) async {
      await run(tester,
          setup: (h) => h.geo.permission = LocationPermission.deniedForever,
          (h) async {
        expect(h.geo.activeListeners, 0);
        expect(Get.isDialogOpen, isTrue);
        expect(h.controller.areActionsReady, isFalse);
      });
    });
  });

  group('actions (TASK 04)', () {
    void checkedIn(Harness h) {
      h.repo.todayResponses
        ..clear()
        ..add(Right(todayResponse(status: 'checked_in', checkIn: '08:00:00')));
    }

    testWidgets('break start success: state comes from backend refetch',
        (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        await h.makeActionsReady();
        h.repo.afterRecord = Right(todayResponse(
          status: 'break_start',
          checkIn: '08:00:00',
          breakStart: '12:00:00',
          serverTime: '12:00:05',
        ));

        await h.controller.recordBreakStart();
        await h.settle();

        expect(h.repo.recorded.single.status, 'break_start');
        expect(h.repo.recorded.single.locationID, 7);
        expect(h.controller.attendanceStatus.value,
            AttendanceStatus.breakStart);
        expect(h.controller.isPerformingAction.value, isFalse);
      });
    });

    testWidgets('break start failure: no optimistic state change',
        (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        await h.makeActionsReady();
        h.repo.recordResult = failure().map((_) {});
        final callsBefore = h.repo.todayCalls;

        await h.controller.recordBreakStart();
        await h.settle();

        expect(h.controller.attendanceStatus.value,
            AttendanceStatus.checkedIn);
        expect(h.controller.breakTime.value, isNull);
        expect(h.repo.todayCalls, callsBefore + 1,
            reason: 'refetch to confirm the real backend state');
        expect(Get.isSnackbarOpen, isTrue);
        expect(h.controller.isPerformingAction.value, isFalse);
      });
    });

    testWidgets('repeated taps submit only once', (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        await h.makeActionsReady();
        final a = h.controller.recordBreakStart();
        final b = h.controller.recordBreakStart();
        await Future.wait([a, b]);
        await h.settle();
        expect(h.repo.recorded, hasLength(1));
      });
    });

    testWidgets('action invalid for current state is rejected',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
              status: 'break_start',
              checkIn: '08:00:00',
              breakStart: '12:00:00',
              serverTime: '12:10:00')));
      }, (h) async {
        await h.makeActionsReady();
        await h.controller.recordBreakStart();
        await h.settle();
        expect(h.repo.recorded, isEmpty);
      });
    });

    testWidgets('action waits for in-flight refresh and re-validates',
        (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        await h.makeActionsReady();

        final gate = Completer<TodayResult>();
        h.repo.nextTodayGate = gate;
        unawaited(h.controller.onRefresh());
        await h.settle();

        final action = h.controller.recordBreakStart();
        gate.complete(Right(todayResponse(
            status: 'checked_out', checkIn: '08:00:00', checkOut: '17:00:00')));
        await action;
        await h.settle();

        expect(h.repo.recorded, isEmpty);
        expect(h.controller.attendanceStatus.value,
            AttendanceStatus.checkedOut);
      });
    });

    testWidgets('outside geofence: action rejected', (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        h.controller.isMapReady.value = true;
        h.geo.emit(lat: officeLat + 0.05);
        await h.settle();
        await h.controller.recordBreakStart();
        await h.settle();
        expect(h.repo.recorded, isEmpty);
      });
    });

    testWidgets('break end success clears countdown', (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
              status: 'break_start',
              checkIn: '08:00:00',
              breakStart: '12:00:00',
              serverTime: '13:05:00')));
      }, (h) async {
        await h.makeActionsReady();
        await tester.pump(const Duration(seconds: 1));
        expect(h.controller.isBreakTimerDone.value, isTrue);

        h.repo.afterRecord = Right(todayResponse(
            status: 'break_end',
            checkIn: '08:00:00',
            breakStart: '12:00:00',
            breakEnd: '13:05:00',
            serverTime: '13:05:02'));
        await h.controller.recordBreakEnd();
        await h.settle();

        expect(h.repo.recorded.single.status, 'break_end');
        expect(h.controller.attendanceStatus.value, AttendanceStatus.breakEnd);
        expect(h.controller.countTimes.value, '--:--:--');
        expect(h.controller.breakDuration.value, '01h 05m');
      });
    });

    testWidgets('break countdown runs from server time', (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
              status: 'break_start',
              checkIn: '08:00:00',
              breakStart: '12:00:00',
              serverTime: '12:15:00',
              durationBreak: 60)));
      }, (h) async {
        await tester.pump(const Duration(seconds: 1));
        expect(h.controller.countTimes.value, startsWith('00:4'));
        expect(h.controller.isBreakTimerDone.value, isFalse);
      });
    });
  });
}
