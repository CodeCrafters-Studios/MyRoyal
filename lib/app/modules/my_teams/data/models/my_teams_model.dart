import 'package:MyRoyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:MyRoyal/app/modules/my_teams/data/models/gender_distribution_model.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/entities/my_teams.dart';

class MyTeamsModel extends MyTeams {
  const MyTeamsModel({
    required super.hasChildren,
    required super.averageAge,
    required super.genderDistribution,
    required super.children,
  });

  factory MyTeamsModel.fromJson(Map<String, dynamic> json) => MyTeamsModel(
        hasChildren: json['has_children'],
        averageAge: json['average_age'],
        genderDistribution:
            GenderDistributionModel.fromJson(json['gender_distribution']),
        children: List<ChildModel>.from(
            json["children"].map((x) => ChildModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'hasChildren': hasChildren,
        'average_age': averageAge,
        'gender_distribution': genderDistribution.toJson(),
        'children': List<dynamic>.from(children.map((x) => x.toJson())),
      };
}
