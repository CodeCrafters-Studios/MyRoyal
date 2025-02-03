import 'package:equatable/equatable.dart';

class PayrollDownloadUrlEntity extends Equatable {
  final int code;
  final String message;
  final Data data;

  const PayrollDownloadUrlEntity(
      {required this.code, required this.message, required this.data});

  @override
  List<Object?> get props => [code, message, data];
}

class Data {
  final String pathUrl;

  Data({
    required this.pathUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pathUrl: json["path_url"],
      );

  Map<String, dynamic> toJson() => {
        "path_url": pathUrl,
      };
}
