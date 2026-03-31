import 'package:equatable/equatable.dart';

class AttendanceLocationEntity extends Equatable {
  final int locationID;
  final String fullName;
  final String location;
  final String typeArea;
  final List<List<double>> polygon;
  final Stkamurd stkamurd;

  AttendanceLocationEntity({
    required this.locationID,
    required this.fullName,
    required this.location,
    required this.typeArea,
    required this.polygon,
    required this.stkamurd,
  });

  @override
  List<Object?> get props =>
      [locationID, fullName, location, typeArea, polygon, stkamurd];
}

class Stkamurd {
  final int radius;
  final double longtitude;
  final double latitude;

  Stkamurd({
    required this.radius,
    required this.longtitude,
    required this.latitude,
  });

  factory Stkamurd.fromJson(Map<String, dynamic> json) => Stkamurd(
        radius: json["radius"],
        longtitude: double.parse(json["longtitude"].toString()),
        latitude: double.parse(json["latitude"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "radius": radius,
        "longtitude": longtitude,
        "latitude": latitude,
      };
}
