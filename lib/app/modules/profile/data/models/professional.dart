import 'package:iroyal/app/modules/profile/domain/entities/professional.dart';

class ProfessionalModel extends Professional {
  const ProfessionalModel({
    required super.company,
    required super.department,
    required super.position,
    required super.reportTo,
    required super.remainingLeave,
    required super.bpjsKesehatan,
    required super.bpjsTenagakerja,
    required super.active,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) =>
      ProfessionalModel(
        company: json["company"],
        department: json["department"],
        position: json["position"],
        reportTo: json["report_to"],
        remainingLeave: json["remaining_leave"],
        bpjsKesehatan: json["bpjs_kesehatan"],
        bpjsTenagakerja: json["bpjs_tenagakerja"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "company": company,
        "department": department,
        "position": position,
        "report_to": reportTo,
        "remaining_leave": remainingLeave,
        "bpjs_kesehatan": bpjsKesehatan,
        "bpjs_tenagakerja": bpjsTenagakerja,
        "active": active,
      };
}
