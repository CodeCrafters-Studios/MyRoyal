import 'package:equatable/equatable.dart';

class CancelFormLeaveParamsEntity extends Equatable {
  final String type;
  final int level;
  final String codeNo;

  const CancelFormLeaveParamsEntity({
    required this.type,
    required this.level,
    required this.codeNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'level': level,
      'code_no': codeNo,
    };
  }

  @override
  List<Object?> get props => [type, codeNo];
}
