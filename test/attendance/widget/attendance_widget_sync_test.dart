import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_sync.dart';

import 'fake_widget_store.dart';

void main() {
  group('AttendanceWidgetPayload', () {
    test('serialises the v1 contract without identity or location', () {
      final json = const AttendanceWidgetPayload(
        signedIn: true,
        status: 'checked_in',
        date: '2026-11-19',
        checkIn: '08:00',
        workedMinutesAtSync: 48,
        officeName: 'HQ',
      ).toJson();

      expect(json['schema'], 1);
      expect(json['status'], 'checked_in');
      expect(json['workedMinutesAtSync'], 48);
      expect(
        json.keys,
        isNot(anyOf(contains('token'), contains('latitude'),
            contains('longitude'), contains('name'), contains('nik'))),
      );
    });

    test('negative worked minutes are never published', () {
      final json = const AttendanceWidgetPayload(
              signedIn: true, workedMinutesAtSync: -12)
          .toJson();
      expect(json['workedMinutesAtSync'], 0);
    });

    test('signed-out payload', () {
      final json = const AttendanceWidgetPayload.signedOut().toJson();
      expect(json['signedIn'], isFalse);
      expect(json['status'], 'not_started');
      expect(json['checkIn'], '');
    });

    test('time helpers', () {
      expect(AttendanceWidgetPayload.hhmm(DateTime(2026, 1, 1, 8, 5)), '08:05');
      expect(AttendanceWidgetPayload.hhmm(null), '');
      expect(AttendanceWidgetPayload.ymd(DateTime(2026, 11, 9)), '2026-11-09');
      expect(AttendanceWidgetPayload.ymd(null), '');
    });
  });

  group('AttendanceWidgetSync', () {
    test('save writes one JSON key and refreshes widgets', () async {
      final store = FakeWidgetStore();
      await AttendanceWidgetSync(store: store).save(
          const AttendanceWidgetPayload(signedIn: true, status: 'break_end'));

      final json = jsonDecode(store.strings[AttendanceWidgetSync.dataKey]!);
      expect(json['status'], 'break_end');
      expect(store.refreshes, 1);
    });

    test('clear publishes signed-out state and removes the map', () async {
      final store = FakeWidgetStore()
        ..strings[AttendanceWidgetSync.mapKey] = '/old/map.jpg';
      await AttendanceWidgetSync(store: store).clear();

      final json = jsonDecode(store.strings[AttendanceWidgetSync.dataKey]!);
      expect(json['signedIn'], isFalse);
      expect(store.strings[AttendanceWidgetSync.mapKey], isNull);
      expect(store.refreshes, 1);
    });

    test('store failures never throw into the attendance flow', () async {
      final sync = AttendanceWidgetSync(store: FakeWidgetStore(fail: true));
      await sync.save(const AttendanceWidgetPayload(signedIn: true));
      await sync.clear();
      await sync.saveMapSnapshot(Uint8List(1), DateTime(2026, 11, 19));
    });

    test('map snapshot at most once per day, reset on clear', () async {
      final store = FakeWidgetStore();
      final sync = AttendanceWidgetSync(store: store);
      final day = DateTime(2026, 11, 19, 8);

      expect(sync.needsMapSnapshot(day), isTrue);
      await sync.saveMapSnapshot(Uint8List.fromList([1, 2, 3]), day);
      expect(store.files[AttendanceWidgetSync.mapKey], isNotNull);
      expect(sync.needsMapSnapshot(DateTime(2026, 11, 19, 17)), isFalse);
      expect(sync.needsMapSnapshot(DateTime(2026, 11, 20, 0, 5)), isTrue);

      await sync.clear();
      expect(sync.needsMapSnapshot(DateTime(2026, 11, 19, 17)), isTrue);
    });

    test('a failed snapshot write is retried later', () async {
      final sync = AttendanceWidgetSync(store: FakeWidgetStore(fail: true));
      final day = DateTime(2026, 11, 19);
      await sync.saveMapSnapshot(Uint8List(1), day);
      expect(sync.needsMapSnapshot(day), isTrue);
    });
  });
}
