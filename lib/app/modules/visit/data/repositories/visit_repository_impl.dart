import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/visit/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/visit/domain/entities/locations.dart';
import 'package:MyRoyal/app/modules/visit/domain/repositories/visit_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class VisitRepositoryImpl extends VisitRepository {
  VisitRepositoryImpl({required this.localData});

  final VisitLocalDataSources localData;

  @override
  Future<Either<Failure, List<Locations>>> getLocations() async {
    try {
      final r = await localData.fetchLocations();
      return Right(r);
    } catch (e) {
      return const Left(LocalDataFailure());
    }
  }
}
