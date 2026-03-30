import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_location_entity.dart';

class AttendanceLocationModel extends AttendanceLocationEntity {
  AttendanceLocationModel({
    required super.fullName,
    required super.location,
    required super.typeArea,
    required super.polygon,
    required super.stkamurd,
  });

  factory AttendanceLocationModel.empty() => AttendanceLocationModel(
        fullName: '',
        location: '',
        typeArea: '',
        polygon: [],
        stkamurd: Stkamurd(
          radius: 0,
          longtitude: 0.0,
          latitude: 0.0,
        ),
      );

  factory AttendanceLocationModel.fromJson(Map<String, dynamic> json) =>
      AttendanceLocationModel(
        fullName: json["full_name"],
        location: json["location"],
        typeArea: json["type_area"],
        polygon: json["polygon"] == null
            ? []
            : List<List<double>>.from(json["polygon"]!
                .map((x) => List<double>.from(x.map((x) => x?.toDouble())))),
        stkamurd: json["stkamurd"] == null
            ? Stkamurd(
                radius: 0,
                longtitude: 0.0,
                latitude: 0.0,
              )
            : Stkamurd.fromJson(json["stkamurd"]),
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "location": location,
        "type_area": typeArea,
        "polygon": List<dynamic>.from(
            polygon.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "stkamurd": stkamurd.toJson(),
      };
}
