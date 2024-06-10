import 'package:equatable/equatable.dart';

class Locations extends Equatable {
  const Locations({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.lat,
    required this.long,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final double lat;
  final double long;

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phone,
        lat,
        long,
      ];
}
