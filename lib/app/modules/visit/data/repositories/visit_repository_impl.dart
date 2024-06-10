import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/visit/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/visit/domain/entities/locations.dart';
import 'package:iroyal/app/modules/visit/domain/repositories/visit_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class VisitRepositoryImpl extends VisitRepository {
  VisitRepositoryImpl({required this.localData});

  final VisitLocalDataSources localData;

  @override
  Future<Either<Failure, List<Locations>>> getLocations() async {
    try {
      final r = await localData.fetchLocations();
      AppUtils.logApp('rRESPONSE:::: $r');
      return Right(r);
    } catch (e) {
      return const Left(LocalDataFailure());
    }
  }
}
