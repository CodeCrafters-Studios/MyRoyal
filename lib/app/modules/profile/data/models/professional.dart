import 'package:iroyal/app/modules/profile/domain/entities/professional.dart';

class ProfessionalModel extends Professional {
  const ProfessionalModel({
    super.idCard = '',
    super.employeeNumber = '',
    super.reaminingLeave = 0,
    super.bpjsKesehatan = '',
    super.bpjsKetenagakerjaan = '',
    super.workEmail = '',
    super.position = '',
    super.department = '',
    super.joinDate = '',
    super.reportTo = '',
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) =>
      ProfessionalModel(
        idCard: json["id_card"],
        employeeNumber: json["employee_number"],
        reaminingLeave: json["reamining_leave"],
        bpjsKesehatan: json["bpjs_kesehatan"],
        bpjsKetenagakerjaan: json["bpjs_ketenagakerjaan"],
        workEmail: json["work_email"],
        position: json["position"],
        department: json["department"],
        joinDate: json["join_date"],
        reportTo: json["report_to"],
      );

  Map<String, dynamic> toJson() => {
        "id_card": idCard,
        "employee_number": employeeNumber,
        "reamining_leave": reaminingLeave,
        "bpjs_kesehatan": bpjsKesehatan,
        "bpjs_ketenagakerjaan": bpjsKetenagakerjaan,
        "work_email": workEmail,
        "position": position,
        "department": department,
        "join_date": joinDate,
        "report_to": reportTo,
      };
}
