import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/approval/data/models/approval_model.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class ApprovalRepository {
  Future<Either<Failure, List<ApprovalModel>>> getLeaveApproval();
}
