import 'package:equatable/equatable.dart';

class Content extends Equatable {
  const Content({
    required this.id,
    required this.name,
    required this.body,
    required this.recordType,
    required this.recordId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String body;
  final String recordType;
  final int recordId;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        body,
        recordType,
        recordId,
        createdAt,
        updatedAt,
      ];
}
