import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_tracking_document_entity.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/repositories/detail_tracking_document_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class DetailTrackingDocumentRepositoriesImpl
    implements DetailTrackingDocumentRepository {
  DetailTrackingDocumentRepositoriesImpl({required this.remoteData});

  final DetailTrackingDocumentRemoteDataSources remoteData;

  @override
  Future<Either<Failure, DetailTrackingDocumentEntity>>
      getDetailTrackingDocument(params) async {
    try {
      final r = await remoteData.getDetailTrackingDocument(params);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
