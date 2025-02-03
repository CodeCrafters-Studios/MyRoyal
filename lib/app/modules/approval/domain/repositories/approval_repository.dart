import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/approval/data/models/approval_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ApprovalRepository {
  Future<Either<Failure, List<ApprovalModel>>> getLeaveApproval();
}
