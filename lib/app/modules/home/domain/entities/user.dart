import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';

class User extends Equatable {
  const User({
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
