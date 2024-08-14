import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/profile/data/models/personal.dart';
import 'package:iroyal/app/modules/profile/data/models/professional.dart';

class ProfileData extends Equatable {
  const ProfileData({required this.personal, required this.professional});

  final PersonalModel personal;
  final ProfessionalModel professional;

  @override
  List<Object?> get props => [personal, professional];
}
