import 'package:equatable/equatable.dart';

class DetailUserCreatedEntities extends Equatable {
  const DetailUserCreatedEntities({
    required this.fullName,
    required this.positionName,
    required this.sectionName,
  });

  final String? fullName;
  final String? positionName;
  final String? sectionName;

  @override
  List<Object?> get props => [fullName, positionName, sectionName];
}
