import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class TraceSerialRepository {
  Future<Either<Failure, TraceSerialModel>> getTraceSerial(params);
}
