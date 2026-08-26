import 'package:MyRoyal/app/modules/ocr/data/models/data_master_employee_os_model.dart';

class DataMasterEmployeeOsEntity {
  final List<DatumModel> religions;
  final List<DatumModel> maritalStatuses;
  final List<DatumModel> skills;
  final Map<String, String> bloodTypes;

  DataMasterEmployeeOsEntity({
    required this.religions,
    required this.maritalStatuses,
    required this.skills,
    required this.bloodTypes,
  });
}

class DatumEntity {
  final int id;
  final String name;

  DatumEntity({
    required this.id,
    required this.name,
  });
}
