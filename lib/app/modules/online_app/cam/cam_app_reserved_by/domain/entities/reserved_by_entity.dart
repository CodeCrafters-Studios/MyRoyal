import 'package:equatable/equatable.dart';

class ReservedByEntity extends Equatable {
  final int code;
  final String message;
  final ReservedByData? data;

  const ReservedByEntity({
    required this.code,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [code, message, data];
}

class ReservedByData extends Equatable {
  final bool status;
  final String userid;
  final List<Datum> data;

  const ReservedByData({
    required this.status,
    required this.userid,
    required this.data,
  });

  factory ReservedByData.fromJson(Map<String, dynamic> json) => ReservedByData(
        status: json["status"],
        userid: json["userid"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "userid": userid,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [status, userid, data];
}

class Datum extends Equatable {
  final String userId;
  final String genericKey;
  final String date;
  final String time;
  final bool button;

  const Datum({
    required this.userId,
    required this.genericKey,
    required this.date,
    required this.time,
    required this.button,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        userId: json["user_id"],
        genericKey: json["generic_key"],
        date: json["date"],
        time: json["time"],
        button: json["button"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "generic_key": genericKey,
        "date": date,
        "time": time,
        "button": button,
      };

  @override
  List<Object?> get props => [userId, genericKey, date, time, button];
}
