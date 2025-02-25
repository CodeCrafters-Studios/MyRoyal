import 'package:equatable/equatable.dart';

class ActionFormLeaveParamsEntity extends Equatable {
  final String type;
  final int level;
  final String codeNo;
  final String feedback;
  final String typeSubmission;

  const ActionFormLeaveParamsEntity({
    required this.type,
    required this.level,
    required this.codeNo,
    required this.feedback,
    required this.typeSubmission,
  });

  @override
  List<Object?> get props => [
        type,
        codeNo,
        level,
        codeNo,
        feedback,
        typeSubmission,
      ];
}
