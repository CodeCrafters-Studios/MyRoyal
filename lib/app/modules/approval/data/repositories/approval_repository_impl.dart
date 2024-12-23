import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/approval/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/approval/data/models/approval_model.dart';
import 'package:iroyal/app/modules/approval/domain/repositories/approval_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  ApprovalRepositoryImpl({required this.remoteData});

  final ApprovalRemoteDataSource remoteData;

  @override
  Future<Either<Failure, List<ApprovalModel>>> getLeaveApproval() async {
    try {
      final r = await remoteData.getLeaveApproval();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
