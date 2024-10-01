import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/profile/domain/entities/download_params.dart';
import 'package:iroyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class DownloadFile implements UseCase<DownloadParams, ParamsDownload> {
  DownloadFile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, DownloadParams>> call(ParamsDownload params) {
    return repository.downloadFile(url: params.url, fileName: params.fileName);
  }
}

class ParamsDownload extends Equatable {
  const ParamsDownload({
    required this.url,
    required this.fileName,
  });

  final String url;
  final String fileName;

  @override
  List<Object?> get props => [url, fileName];
}
