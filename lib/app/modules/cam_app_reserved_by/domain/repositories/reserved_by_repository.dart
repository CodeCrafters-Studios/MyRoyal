import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/update_reserved_by_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ReservedByRepository {
  Future<Either<Failure, ReservedByModel>> getReservedBy(params);
  Future<Either<Failure, UpdateReservedByModel>> updateReservedBy(params);
}
