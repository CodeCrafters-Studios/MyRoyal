import 'package:iroyal/app/modules/cam_app_trace_serial/domain/entities/trace_serial_params_entity.dart';

class TraceSerialParamsModel extends TraceSerialParamsEntity {
  TraceSerialParamsModel({required super.serial, required super.company});

  factory TraceSerialParamsModel.fromJson(Map<String, dynamic> json) =>
      TraceSerialParamsModel(
        serial: json["serial"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "serial": serial,
        "company": company,
      };
}
