import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_history.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class TrackingDocumentRepositoriesImpl extends TrackingDocumentRepository {
  TrackingDocumentRepositoriesImpl({required this.remoteData});

  final TrackingDocumentRemoteDataSources remoteData;

  @override
  Future<Either<Failure, TrackingDocumentOnProgress>>
      getTrackingDocumentOnProgress() async {
    try {
      final r = await remoteData.getTrackingDocumentOnProgress();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TrackingDocumentHistory>>
      getTrackingDocumentHistory() async {
    try {
      final r = await remoteData.getTrackingDocumentHistory();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
