import 'package:equatable/equatable.dart';

class EditProfileResponse extends Equatable {
  const EditProfileResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final Data data;

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}

class Data {
  final int id;

  Data({
    required this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
