import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/domain/entities/download_params.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, DownloadParams>> downloadFile({
    required String url,
    required String fileName,
  });
}
