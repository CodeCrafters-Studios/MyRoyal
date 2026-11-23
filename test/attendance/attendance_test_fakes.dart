import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_location_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/repositories/attendance_repository.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_sync.dart';
import 'package:MyRoyal/base/errors/failures.dart';

import 'widget/fake_widget_store.dart';

const officeLat = -6.200000;
const officeLng = 106.816666;
const offlineStatus = 'Tidak ada koneksi';
const onlineStatus = 'Terhubung';

/// Builds a backend `today` payload through the real JSON parser.
AttendanceTodayModel todayResponse({
  String status = 'not_started',
  String? date = '2026-11-19',
  String? checkIn,
  String? checkOut,
  String? breakStart,
  String? breakEnd,
  String? serverTime = '08:48:00',
  int durationBreak = 60,
  int attendanceId = 42,
}) {
  return AttendanceTodayModel.fromJson({
    'attendance_id': attendanceId,
    'date': date,
    'status': status,
    'checked_in_time': checkIn,
    'checked_out_time': checkOut,
    'break_start_time': breakStart,
    'break_end_time': breakEnd,
    'server_time': serverTime,
    'duration_break': durationBreak,
  });
}

typedef TodayResult = Either<Failure, AttendanceTodayModel>;

class FakeAttendanceRepository implements AttendanceRepository {
  /// Responses served in order; the last one repeats.
  final List<TodayResult> todayResponses = [Right(todayResponse())];

  /// When set, the next `today` call waits on this completer instead.
  Completer<TodayResult>? nextTodayGate;

  int todayCalls = 0;
  final List<AttendanceRecordEntity> recorded = [];
  Either<Failure, void> recordResult = const Right(null);

  /// Applied to [todayResponses] after a successful record (simulates the
  /// backend state change).
  TodayResult? afterRecord;

  List<AttendanceLocationModel> locations = [
    AttendanceLocationModel(
      locationID: 7,
      fullName: 'HQ',
      location: 'HQ',
      typeArea: 'radius',
      polygon: const [],
      stkamurd: Stkamurd(radius: 50, latitude: officeLat, longtitude: officeLng),
    ),
  ];

  @override
  Future<TodayResult> getAttendanceToday() {
    todayCalls++;
    final gate = nextTodayGate;
    if (gate != null) {
      nextTodayGate = null;
      return gate.future;
    }
    final r = todayResponses.length > 1
        ? todayResponses.removeAt(0)
        : todayResponses.first;
    return Future.value(r);
  }

  @override
  Future<Either<Failure, void>> recordAttendance(
      AttendanceRecordEntity entity) async {
    recorded.add(entity);
    if (recordResult.isRight() && afterRecord != null) {
      todayResponses
        ..clear()
        ..add(afterRecord!);
    }
    return recordResult;
  }

  @override
  Future<Either<Failure, List<AttendanceLocationModel>>>
      getAttendanceLocation() async => Right(locations);
}

TodayResult failure() => const Left(ServerFailure(properties: ['boom']));

class FakeGeolocator extends GeolocatorPlatform {
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.whileInUse;
  final _positions = StreamController<Position>.broadcast();
  int streamsOpened = 0;

  int get activeListeners => _positions.hasListener ? _listeners : 0;
  int _listeners = 0;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<bool> openLocationSettings() async => true;

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) {
    streamsOpened++;
    late StreamController<Position> c;
    StreamSubscription<Position>? inner;
    c = StreamController<Position>(
      onListen: () {
        _listeners++;
        inner = _positions.stream.listen(c.add);
      },
      onCancel: () {
        _listeners--;
        inner?.cancel();
      },
    );
    return c.stream;
  }

  void emit({
    double lat = officeLat,
    double lng = officeLng,
    double accuracy = 5,
    bool mocked = false,
  }) {
    _positions.add(Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: accuracy,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
      isMocked: mocked,
    ));
  }
}

class Harness {
  Harness(this.tester);

  final WidgetTester tester;
  final repo = FakeAttendanceRepository();
  final geo = FakeGeolocator();
  final connection = onlineStatus.obs;
  final widgetStore = FakeWidgetStore();
  late AttendanceController controller;

  Future<AttendanceController> start() async {
    GeolocatorPlatform.instance = geo;
    AttendanceWidgetSync.instance = AttendanceWidgetSync(store: widgetStore);
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => const GetMaterialApp(home: Scaffold()),
    ));

    controller = AttendanceController(
      getAttendanceTodayUsecase: GetAttendanceTodayUsecase(repository: repo),
      recordAttendanceUsecase: RecordAttendanceUsecase(repository: repo),
      getAttendanceLocationUsecase:
          GetAttendanceLocationUsecase(repository: repo),
      connectionStatus: connection,
    );
    Get.put(controller);
    await settle();
    return controller;
  }

  /// Flushes microtasks and one timer tick without waiting on animations.
  Future<void> settle([Duration d = const Duration(milliseconds: 10)]) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(d);
    }
  }

  /// Puts the controller in a state where action buttons are usable.
  Future<void> makeActionsReady() async {
    controller.isMapReady.value = true;
    geo.emit();
    await settle();
  }

  Future<void> dispose() async {
    // Never await snackbar/dialog futures here: they complete through
    // animations, which only advance when the fake clock is pumped.
    if (Get.isDialogOpen ?? false) Get.back();
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    Get.delete<AttendanceController>(force: true);
    await tester.pumpWidget(const SizedBox());
    Get.reset();
  }
}
