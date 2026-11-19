import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_launch_handler.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_sync.dart';

import '../attendance_test_fakes.dart';

/// TASK 11: the widget only ever receives backend-confirmed state, and
/// widget taps go through the existing guarded attendance flow.
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
      AttendanceWidgetLaunchHandler.instance = null;
      await h.dispose();
    }
  }

  Map<String, dynamic>? published(Harness h) {
    final raw = h.widgetStore.strings[AttendanceWidgetSync.dataKey];
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  group('sync', () {
    testWidgets('publishes backend state after load', (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
            status: 'checked_in',
            checkIn: '08:00:00',
            serverTime: '08:48:00',
          )));
      }, (h) async {
        final json = published(h)!;
        expect(json['signedIn'], isTrue);
        expect(json['status'], 'checked_in');
        expect(json['date'], '2026-11-19');
        expect(json['checkIn'], '08:00');
        expect(json['workedMinutesAtSync'], 48);
        expect(h.widgetStore.refreshes, greaterThan(0));
      });
    });

    testWidgets('office name is added once GPS finds the nearest office',
        (tester) async {
      await run(tester, (h) async {
        expect(published(h)!['officeName'], '');
        h.geo.emit();
        await h.settle();
        expect(published(h)!['officeName'], 'HQ');
      });
    });

    testWidgets('midnight reset publishes not_started with cleared times',
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
            Right(todayResponse(status: 'not_started', serverTime: '00:05:00')),
          ]);
      }, (h) async {
        expect(published(h)!['status'], 'checked_out');
        await h.controller.onRefresh();
        await h.settle();

        final json = published(h)!;
        expect(json['status'], 'not_started');
        expect(json['checkIn'], '');
        expect(json['breakStart'], '');
        expect(json['checkOut'], '');
        expect(json['workedMinutesAtSync'], 0);
      });
    });

    testWidgets('failed POST never reaches the widget (no optimistic state)',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(status: 'checked_in', checkIn: '08:00:00')));
      }, (h) async {
        await h.makeActionsReady();
        h.repo.recordResult = failure().map((_) {});
        await h.controller.recordBreakStart();
        await h.settle();
        expect(published(h)!['status'], 'checked_in');
        expect(published(h)!['breakStart'], '');
      });
    });

    testWidgets('break_start publishes the allowance end', (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
            status: 'break_start',
            checkIn: '08:00:00',
            breakStart: '12:00:00',
            serverTime: '12:10:00',
            durationBreak: 60,
          )));
      }, (h) async {
        final json = published(h)!;
        expect(json['status'], 'break_start');
        expect(json['breakEndsAtEpochMs'],
            DateTime(2026, 11, 19, 13).millisecondsSinceEpoch);
        expect(json['workedMinutesAtSync'], 240);
      });
    });
  });

  group('widget taps', () {
    void checkedIn(Harness h) {
      h.repo.todayResponses
        ..clear()
        ..add(Right(todayResponse(status: 'checked_in', checkIn: '08:00:00')));
    }

    testWidgets('waits for GPS/map, then opens the normal confirm dialog',
        (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        h.controller.handleWidgetAction('break_start');
        await h.settle();
        expect(Get.isDialogOpen, isFalse, reason: 'not ready yet');

        await h.makeActionsReady();
        expect(Get.isDialogOpen, isTrue);
        expect(h.repo.recorded, isEmpty, reason: 'user must still confirm');
      });
    });

    testWidgets('action invalid for the current state is rejected',
        (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        await h.makeActionsReady();
        h.controller.handleWidgetAction('check_in');
        await h.settle();
        expect(Get.isDialogOpen, isFalse);
        expect(Get.isSnackbarOpen, isTrue);
      });
    });

    testWidgets('End Break before the countdown finishes is rejected',
        (tester) async {
      await run(tester, setup: (h) {
        h.repo.todayResponses
          ..clear()
          ..add(Right(todayResponse(
            status: 'break_start',
            checkIn: '08:00:00',
            breakStart: '12:00:00',
            serverTime: '12:10:00',
          )));
      }, (h) async {
        await h.makeActionsReady();
        await tester.pump(const Duration(seconds: 1));
        h.controller.handleWidgetAction('break_end');
        await h.settle();
        expect(Get.isDialogOpen, isFalse);
        expect(Get.isSnackbarOpen, isTrue);
      });
    });

    testWidgets('unknown action is ignored', (tester) async {
      await run(tester, setup: checkedIn, (h) async {
        await h.makeActionsReady();
        h.controller.handleWidgetAction('delete_all');
        await h.settle();
        expect(Get.isDialogOpen, isFalse);
        expect(Get.isSnackbarOpen, isFalse);
      });
    });

    testWidgets('launch handler delivers a cold-start tap to the controller',
        (tester) async {
      final handler = AttendanceWidgetLaunchHandler(
        isSignedIn: () async => true,
        openAttendanceTab: () {},
        clicks: const Stream.empty(),
        initialUri: () async => null,
      );
      AttendanceWidgetLaunchHandler.instance = handler;
      await handler.onUri(Uri.parse('myroyal://attendance?action=break_start'));

      await run(tester, setup: checkedIn, (h) async {
        expect(handler.hasPending, isFalse, reason: 'attached on init');
        await h.makeActionsReady();
        expect(Get.isDialogOpen, isTrue);
      });
    });
  });
}
