import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:MyRoyal/app/modules/my_teams/data/models/my_teams_job_model.dart';

class Child extends Equatable {
  const Child({
    required this.id,
    required this.fullName,
    required this.isThisWeekEmployeeBirthday,
    required this.job,
    required this.children,
  });

  final int id;
  final String fullName;
  final bool isThisWeekEmployeeBirthday;
  final MyTeamsJobModel job;
  final List<ChildModel> children;

  @override
  List<Object?> get props => [
        id,
        fullName,
        isThisWeekEmployeeBirthday,
        job,
        children,
      ];
}
