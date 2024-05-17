import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:iroyal/app/modules/my_teams/data/models/gender_distribution_model.dart';

class MyTeams extends Equatable {
  const MyTeams({
    required this.hasChildren,
    required this.averageAge,
    required this.genderDistribution,
    required this.children,
  });

  final bool hasChildren;
  final double averageAge;
  final GenderDistributionModel genderDistribution;
  final List<ChildModel> children;

  @override
  List<Object?> get props => [
        hasChildren,
        averageAge,
        genderDistribution,
        children,
      ];
}
