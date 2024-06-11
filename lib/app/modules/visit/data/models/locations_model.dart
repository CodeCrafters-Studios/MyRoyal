import 'package:iroyal/app/modules/visit/domain/entities/locations.dart';

class LocationsModel extends Locations {
  const LocationsModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phone,
    required super.lat,
    required super.long,
  });

  factory LocationsModel.fromJson(Map<String, dynamic> json) => LocationsModel(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        phone: json['phone'],
        lat: json['lat'],
        long: json['long'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "phone": phone,
        "lat": lat,
        "long": long,
      };
}
