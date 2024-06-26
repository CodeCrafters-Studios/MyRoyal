import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/profile/domain/entities/personal.dart';
import 'package:iroyal/app/modules/profile/domain/entities/professional.dart';

class Profile extends Equatable {
  const Profile({
    required this.personal,
    required this.professional,
  });

  final Personal personal;
  final Professional professional;

  @override
  List<Object?> get props => [
        personal,
        professional,
      ];
}
