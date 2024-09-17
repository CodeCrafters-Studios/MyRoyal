import 'package:equatable/equatable.dart';

class DetailProgressEntities extends Equatable {
  const DetailProgressEntities({
    required this.fullName,
    required this.positionName,
    required this.sectionName,
    required this.state,
    required this.createdAt,
    required this.approvedAt,
    required this.forLabel,
  });

  final String fullName;
  final String positionName;
  final String sectionName;
  final String state;
  final String createdAt;
  final String? approvedAt;
  final String forLabel;

  @override
  List<Object?> get props => [
        fullName,
        positionName,
        sectionName,
        state,
        createdAt,
        approvedAt,
        forLabel,
      ];
}
