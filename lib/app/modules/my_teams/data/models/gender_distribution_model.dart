import 'package:iroyal/app/modules/my_teams/domain/entities/gender_distribution.dart';

class GenderDistributionModel extends GenderDistribution {
  const GenderDistributionModel({
    required super.male,
    required super.female,
  });

  factory GenderDistributionModel.fromJson(Map<String, dynamic> json) =>
      GenderDistributionModel(
        male: json["male"]?.toDouble(),
        female: json["female"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "male": male,
        "female": female,
      };
}
