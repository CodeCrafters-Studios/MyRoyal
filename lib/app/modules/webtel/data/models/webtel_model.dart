import 'package:iroyal/app/modules/webtel/data/models/webtel_data_model.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';

class WebtelModel extends Webtel {
  const WebtelModel(
      {required super.code, required super.message, required super.data});

  factory WebtelModel.fromJson(Map<String, dynamic> json) => WebtelModel(
        code: json["code"],
        message: json["message"],
        data: Map.from(json["data"]).map((k, v) =>
            MapEntry<String, List<WebtelDataModel>>(
                k,
                List<WebtelDataModel>.from(
                    v.map((x) => WebtelDataModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": Map.from(data).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}
