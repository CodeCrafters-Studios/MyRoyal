import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_record_model.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:iroyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:iroyal/app/modules/attendance/domain/repositories/attendance_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  AttendanceRepositoryImpl({required this.remoteDataSource});

  final AttendanceRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AttendanceTodayModel>> getAttendanceToday() async {
    try {
      final r = await remoteDataSource.getAttendanceToday();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, void>> recordAttendance(
      AttendanceRecordEntity entity) async {
    try {
      final model = AttendanceRecordModel(
        id: entity.id,
        status: entity.status,
        date: entity.date,
        time: entity.time,
        latitude: entity.latitude,
        longitude: entity.longitude,
        workDurationMinutes: entity.workDurationMinutes,
        file: entity.file,
      );

      await remoteDataSource.recordAttendance(model);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceLocationModel>>>
      getAttendanceLocation() async {
    try {
      final r = await remoteDataSource.getAttendanceLocation();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
