import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_launch_handler.dart';

class _Target implements AttendanceWidgetActionTarget {
  final List<String> actions = [];

  @override
  void handleWidgetAction(String action) => actions.add(action);
}

void main() {
  Uri uri(String? action) => Uri.parse(
      'myroyal://attendance${action == null ? '' : '?action=$action'}');

  group('parseAction', () {
    test('known actions', () {
      for (final a in AttendanceWidgetLaunchHandler.actions) {
        expect(AttendanceWidgetLaunchHandler.parseAction(uri(a)), a);
      }
    });

    test('bare or unknown action opens the tab only', () {
      expect(AttendanceWidgetLaunchHandler.parseAction(uri(null)), 'open');
      expect(AttendanceWidgetLaunchHandler.parseAction(uri('delete_all')),
          'open');
    });

    test('foreign URIs are ignored', () {
      expect(AttendanceWidgetLaunchHandler.parseAction(null), isNull);
      expect(
          AttendanceWidgetLaunchHandler.parseAction(
              Uri.parse('https://attendance?action=check_in')),
          isNull);
      expect(
          AttendanceWidgetLaunchHandler.parseAction(
              Uri.parse('myroyal://payroll?action=check_in')),
          isNull);
    });
  });

  group('dispatch', () {
    late DateTime now;
    late bool signedIn;
    late int tabOpens;
    late StreamController<Uri?> clicks;
    late AttendanceWidgetLaunchHandler handler;

    setUp(() {
      now = DateTime(2026, 11, 19, 8);
      signedIn = true;
      tabOpens = 0;
      clicks = StreamController<Uri?>();
      handler = AttendanceWidgetLaunchHandler(
        isSignedIn: () async => signedIn,
        openAttendanceTab: () => tabOpens++,
        clicks: clicks.stream,
        initialUri: () async => null,
        now: () => now,
      );
    });

    // Not awaited: close() only completes once a listener got the done event.
    tearDown(() {
      clicks.close();
    });

    test('opens the tab and runs the action once the screen attaches',
        () async {
      await handler.onUri(uri('break_start'));
      expect(tabOpens, 1);
      expect(handler.hasPending, isTrue);

      final target = _Target();
      handler.attach(target);
      expect(target.actions, ['break_start']);
      expect(handler.hasPending, isFalse);
    });

    test('runs immediately when the screen is already attached', () async {
      final target = _Target();
      handler.attach(target);
      await handler.onUri(uri('check_out'));
      expect(target.actions, ['check_out']);
    });

    test('D4: tap while signed out is dropped, not replayed after login',
        () async {
      signedIn = false;
      await handler.onUri(uri('check_in'));
      expect(tabOpens, 0);
      expect(handler.hasPending, isFalse);

      signedIn = true;
      final target = _Target();
      handler.attach(target);
      expect(target.actions, isEmpty);
    });

    test('same action within the debounce window runs once', () async {
      final target = _Target();
      handler.attach(target);
      await handler.onUri(uri('break_start'));
      await handler.onUri(uri('break_start'));
      expect(target.actions, ['break_start']);

      now = now.add(const Duration(seconds: 3));
      await handler.onUri(uri('break_start'));
      expect(target.actions, ['break_start', 'break_start']);
    });

    test('expired tap is not executed', () async {
      await handler.onUri(uri('check_in'));
      now = now.add(const Duration(minutes: 3));
      expect(handler.hasPending, isFalse);

      final target = _Target();
      handler.attach(target);
      expect(target.actions, isEmpty);
    });

    test('plain open does not trigger an action', () async {
      final target = _Target();
      handler.attach(target);
      await handler.onUri(uri(null));
      expect(tabOpens, 1);
      expect(target.actions, isEmpty);
    });

    test('detached screen does not receive actions', () async {
      final target = _Target();
      handler
        ..attach(target)
        ..detach(target);
      await handler.onUri(uri('check_in'));
      expect(target.actions, isEmpty);
      expect(handler.hasPending, isTrue);
    });

    test('cold start URI and later clicks are both handled', () async {
      final target = _Target();
      final h = AttendanceWidgetLaunchHandler(
        isSignedIn: () async => true,
        openAttendanceTab: () {},
        clicks: clicks.stream,
        initialUri: () async => uri('check_in'),
        now: () => now,
      );
      await h.start();
      h.attach(target);
      expect(target.actions, ['check_in']);

      clicks.add(uri('break_start'));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(target.actions, ['check_in', 'break_start']);
      await h.dispose();
    });
  });
}
