import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/domain/repositories/trace_serial_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class TraceSerialRepositoryImpl implements TraceSerialRepository {
  TraceSerialRepositoryImpl(this.remoteData);

  final TraceSerialDataSources remoteData;

  @override
  Future<Either<Failure, TraceSerialModel>> getTraceSerial(params) async {
    try {
      final r = await remoteData.getTraceSerial(params);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
