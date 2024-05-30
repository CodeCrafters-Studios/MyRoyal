import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/tracking_document/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document.dart';
import 'package:iroyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class TrackingDocumentRepositoriesImpl extends TrackingDocumentRepository {
  TrackingDocumentRepositoriesImpl({required this.remoteData});

  final TrackingDocumentRemoteDataSources remoteData;

  @override
  Future<Either<Failure, List<TrackingDocument>>> getTrackingDocument() async {
    try {
      final r = await remoteData.getTrackingDocument();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
