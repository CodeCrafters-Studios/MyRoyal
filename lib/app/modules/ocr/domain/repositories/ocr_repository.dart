import 'package:MyRoyal/app/modules/ocr/data/models/data_master_employee_os_model.dart';
import 'package:MyRoyal/app/modules/ocr/models/employee_os_model.dart';
import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_response_model.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class OcrRepository {
  Future<Either<Failure, ScanOcrResponseModel>> scanOcr(
      ScanOcrRequestModel request);
  Future<Either<Failure, EmployeeOsModel>> getEmployeeOs(params);
  Future<Either<Failure, DataMasterEmployeeOsModel>> getDataMasterEmployeeOs();
  Future<Either<Failure, SaveEmployeeOsResponseModel>> saveEmployeeOs(
      SaveEmployeeOsRequestModel request);
}
