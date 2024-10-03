import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  LeaveRepositoryImpl({required this.remoteData});

  final LeaveRemoteDataSources remoteData;

  @override
  Future<Either<Failure, LeaveModel>> getLeave() async {
    try {
      final r = await remoteData.getLeave();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
