import 'package:iroyal/app/modules/tracking_document/domain/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({required super.name});

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
