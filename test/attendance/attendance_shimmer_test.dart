import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/views/components/attendance_shimmer.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => MaterialApp(home: Scaffold(body: child)),
    ));
  }

  int boxes() => find.byType(AttendanceShimmerBox).evaluate().length;

  testWidgets('initial placeholder is neutral (no Check In circle)',
      (tester) async {
    await pump(tester, const SingleChildScrollView(
        child: AttendanceInitialShimmer()));
    final circles = tester
        .widgetList<AttendanceShimmerBox>(find.byType(AttendanceShimmerBox))
        .where((b) => b.circle);
    expect(circles, isEmpty);
  });

  final expected = {
    AttendanceStatus.notStarted: 'action-shimmer-not-started',
    AttendanceStatus.checkedIn: 'action-shimmer-checked-in',
    AttendanceStatus.breakStart: 'action-shimmer-break-start',
    AttendanceStatus.breakEnd: 'action-shimmer-break-end',
    AttendanceStatus.checkedOut: 'action-shimmer-checked-out',
  };

  for (final e in expected.entries) {
    testWidgets('action placeholder matches ${e.key.name}', (tester) async {
      await pump(tester, AttendanceActionShimmer(status: e.key));
      expect(find.byKey(ValueKey(e.value)), findsOneWidget);
    });
  }

  testWidgets('checked_in shows two button placeholders (Check Out + Break)',
      (tester) async {
    await pump(tester,
        const AttendanceActionShimmer(status: AttendanceStatus.checkedIn));
    expect(boxes(), 2);
    final circles = tester
        .widgetList<AttendanceShimmerBox>(find.byType(AttendanceShimmerBox))
        .where((b) => b.circle);
    expect(circles, isEmpty);
  });

  testWidgets('not_started shows the Check In circle', (tester) async {
    await pump(tester,
        const AttendanceActionShimmer(status: AttendanceStatus.notStarted));
    final circles = tester
        .widgetList<AttendanceShimmerBox>(find.byType(AttendanceShimmerBox))
        .where((b) => b.circle);
    expect(circles, hasLength(1));
  });
}
