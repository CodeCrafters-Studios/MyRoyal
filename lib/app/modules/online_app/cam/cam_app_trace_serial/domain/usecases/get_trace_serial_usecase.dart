import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_model.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/data/models/trace_serial_params_model.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/domain/repositories/trace_serial_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetTraceSerialUsecase
    implements UseCase<TraceSerialModel, TraceSerialParamsModel> {
  GetTraceSerialUsecase(this.repository);

  final TraceSerialRepository repository;

  @override
  Future<Either<Failure, TraceSerialModel>> call(
      TraceSerialParamsModel params) {
    return repository.getTraceSerial(params.toJson());
  }
}
