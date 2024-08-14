import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/profile/data/models/profile_data_model.dart';

class Profile extends Equatable {
  const Profile({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  final bool status;
  final int code;
  final String message;
  final ProfileDataModel data;

  @override
  List<Object?> get props => [
        status,
        code,
        message,
        data,
      ];
}
