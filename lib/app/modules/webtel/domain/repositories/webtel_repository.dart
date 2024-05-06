import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class WebtelRepository {
  Future<Either<Failure, List<Webtel>>> getWebtel();
}
