import 'package:MyRoyal/app/modules/dashboard/domain/entities/ptk_entity.dart';

class PtkModel extends PtkEntity {
  const PtkModel(super.open, super.closed, super.total);

  factory PtkModel.fromJson(Map<String, dynamic> json) => PtkModel(
        json["open"],
        json["closed"],
        json["total"],
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "closed": closed,
        "total": total,
      };
}
