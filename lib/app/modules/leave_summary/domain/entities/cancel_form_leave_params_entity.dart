import 'package:equatable/equatable.dart';

class CancelFormLeaveParamsEntity extends Equatable {
  final String type;
  final int level;
  final String codeNo;
  final String feedback;

  const CancelFormLeaveParamsEntity({
    required this.type,
    required this.level,
    required this.codeNo,
    required this.feedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'level': level,
      'code_no': codeNo,
      'feedback': feedback,
    };
  }

  @override
  List<Object?> get props => [type, codeNo, level, codeNo, feedback];
}
