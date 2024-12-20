import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/dashboard/data/models/dashboard_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_late_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_permit_request_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_special_leave_request_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardModel>> getDashboardUseCase();
  Future<Either<Failure, DetailSpecialLeaveRequestModel>>
      getDetailSpecialLeaveRequestUseCase();
  Future<Either<Failure, DetailLateModel>> getDetailLateUseCase();
  Future<Either<Failure, DetailPermitRequestModel>>
      getDetailPermitRequestUseCase();
}
