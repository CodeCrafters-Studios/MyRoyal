class UserJdeEntity {
  final int code;
  final String message;
  final Data data;

  UserJdeEntity({
    required this.code,
    required this.message,
    required this.data,
  });
}

class Data {
  final String status;
  final String username;
  final List<Datum> data;

  Data({
    required this.status,
    required this.username,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        username: json["username"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "username": username,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final String userid;

  Datum({
    required this.userid,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userid: json["userid"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
      };
}
