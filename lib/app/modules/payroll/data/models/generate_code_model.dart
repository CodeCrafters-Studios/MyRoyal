import 'package:MyRoyal/app/modules/payroll/domain/entities/generate_code_entity.dart';

class GenerateCodeModel extends GenerateCodeEntity {
  GenerateCodeModel({required super.password});

  factory GenerateCodeModel.fromJson(Map<String, dynamic> json) {
    return GenerateCodeModel(
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() => {
        "password": password,
      };
}
