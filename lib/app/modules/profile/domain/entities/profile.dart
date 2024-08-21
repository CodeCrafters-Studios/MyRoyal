import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/profile/data/models/profile_data_model.dart';

class Profile extends Equatable {
  const Profile({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final ProfileDataModel data;

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
