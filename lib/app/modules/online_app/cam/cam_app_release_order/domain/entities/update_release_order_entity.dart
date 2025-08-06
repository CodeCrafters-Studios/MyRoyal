class UpdateReleaseOrderEntity {
  final int code;
  final String message;
  final Data data;

  UpdateReleaseOrderEntity({
    required this.code,
    required this.message,
    required this.data,
  });
}

class Data {
  final String status;
  final String message;

  Data({
    required this.status,
    required this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
