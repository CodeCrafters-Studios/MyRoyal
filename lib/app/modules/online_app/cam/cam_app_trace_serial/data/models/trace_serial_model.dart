import 'package:iroyal/app/modules/online_app/cam/cam_app_trace_serial/domain/entities/trace_serial_entity.dart';

class TraceSerialModel extends TraceSerialEntity {
  const TraceSerialModel(
      {required super.code, required super.message, required super.data});

  factory TraceSerialModel.empty() => TraceSerialModel(
        code: 0,
        message: '',
        data: Data(),
      );

  factory TraceSerialModel.fromJson(Map<String, dynamic> json) =>
      TraceSerialModel(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}
