import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_approval_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class LeaveRepository {
  Future<Either<Failure, LeaveModel>> getLeave();
  Future<Either<Failure, SubtituteEmployeeEntity>> getSubtituteEmployee();
  Future<Either<Failure, CreateFormLeaveEntity>> createFormLeave(
    Map<String, dynamic> createFormLeaveParams,
  );
  Future<Either<Failure, CancelFormLeaveEntity>> cancelFormLeave(
    Map<String, dynamic> cancelFormLeaveParams,
  );
  Future<Either<Failure, List<LeaveApprovalModel>>> getLeaveApproval();
}
