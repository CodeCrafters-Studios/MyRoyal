import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/domain/repositories/ocr_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:dartz/dartz.dart';

class SaveEmployeeOsUsecase {
  final OcrRepository repository;

  SaveEmployeeOsUsecase({required this.repository});

  Future<Either<Failure, SaveEmployeeOsResponseModel>> call(
      SaveEmployeeOsRequestModel request) {
    return repository.saveEmployeeOs(request);
  }
}
