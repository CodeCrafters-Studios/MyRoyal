import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class LeaveRepository {
  Future<Either<Failure, LeaveModel>> getLeave();
}
