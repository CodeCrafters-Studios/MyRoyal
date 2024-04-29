// import 'package:iroyal/app/modules/my_teams/data/models/my_teams_job_model.dart';
// import 'package:iroyal/app/modules/my_teams/domain/entities/children.dart';

// class ChildrenModel extends Children {
//   const ChildrenModel({
//     required super.id,
//     required super.fullName,
//     required super.isThisWeekEmployeeBirthday,
//     required super.job,
//     required super.children,
//   });

//   factory ChildrenModel.fromJson(Map<String, dynamic> json) => ChildrenModel(
//         id: json["id"],
//         fullName: json["full_name"],
//         isThisWeekEmployeeBirthday: json["is_this_week_employee_birthday"],
//         job: MyTeamsJobModel.fromJson(json["job"]),
//         children: List<ChildrenModel>.from(
//             json["children"].map((x) => ChildrenModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "full_name": fullName,
//         "is_this_week_employee_birthday": isThisWeekEmployeeBirthday,
//         "job": job.toJson(),
//         "children": List<dynamic>.from(children.map((x) => x.toJson())),
//       };
// }
