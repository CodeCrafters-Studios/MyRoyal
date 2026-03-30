import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final UserDataModel data;

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
