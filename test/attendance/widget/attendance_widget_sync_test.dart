import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_sync.dart';

import 'fake_widget_store.dart';

const bounds = WidgetMapBounds(
  north: -6.1990,
  south: -6.2010,
  east: 106.8180,
  west: 106.8160,
);

void main() {
  group('projectToMapImage', () {
    test('centre of the bounds is the centre of the image', () {
      final p = projectToMapImage(-6.2000, 106.8170, bounds)!;
      expect(p.x, closeTo(0.5, 1e-6));
      expect(p.y, closeTo(0.5, 1e-3));
    });

    test('corners map to 0 and 1', () {
      final tl = projectToMapImage(-6.1990, 106.8160, bounds)!;
      final br = projectToMapImage(-6.2010, 106.8180, bounds)!;
      expect(tl.x, closeTo(0, 1e-9));
      expect(tl.y, closeTo(0, 1e-9));
      expect(br.x, closeTo(1, 1e-9));
      expect(br.y, closeTo(1, 1e-9));
    });

    test('north is up: a point further north has a smaller y', () {
      final north = projectToMapImage(-6.1995, 106.8170, bounds)!;
      final south = projectToMapImage(-6.2005, 106.8170, bounds)!;
      expect(north.y, lessThan(south.y));
    });

    test('outside the image or degenerate bounds gives null', () {
      expect(projectToMapImage(-6.3000, 106.8170, bounds), isNull);
      expect(projectToMapImage(-6.2000, 106.9000, bounds), isNull);
      expect(
          projectToMapImage(-6.2, 106.8,
              const WidgetMapBounds(north: 1, south: 1, east: 2, west: 1)),
          isNull);
    });
  });

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

    test('location defaults to unknown', () {
      final json = const AttendanceWidgetPayload(signedIn: true).toJson();
      expect(json['mapDotX'], -1);
      expect(json['mapDotY'], -1);
      expect(json['locationAtEpochMs'], 0);
      expect(json['insideArea'], -1);
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
      await sync.saveMapSnapshot(Uint8List(1), DateTime(2026, 11, 19), bounds);
    });

    test('map snapshot at most once per day, reset on clear', () async {
      final store = FakeWidgetStore();
      final sync = AttendanceWidgetSync(store: store);
      final day = DateTime(2026, 11, 19, 8);

      expect(sync.needsMapSnapshot(day), isTrue);
      await sync.saveMapSnapshot(Uint8List.fromList([1, 2, 3]), day, bounds);
      expect(store.files[AttendanceWidgetSync.mapKey], isNotNull);
      expect(sync.needsMapSnapshot(DateTime(2026, 11, 19, 17)), isFalse);
      expect(sync.needsMapSnapshot(DateTime(2026, 11, 20, 0, 5)), isTrue);

      expect(sync.mapBounds, same(bounds));

      await sync.clear();
      expect(sync.needsMapSnapshot(DateTime(2026, 11, 19, 17)), isTrue);
      expect(sync.mapBounds, isNull);
    });

    test('a failed snapshot write is retried later', () async {
      final sync = AttendanceWidgetSync(store: FakeWidgetStore(fail: true));
      final day = DateTime(2026, 11, 19);
      await sync.saveMapSnapshot(Uint8List(1), day, bounds);
      expect(sync.needsMapSnapshot(day), isTrue);
    });
  });
}
