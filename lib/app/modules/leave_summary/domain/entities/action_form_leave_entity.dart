import 'package:equatable/equatable.dart';

class ActionFormLeaveEntity extends Equatable {
  const ActionFormLeaveEntity({
    required this.id,
    required this.codeNo,
  });

  final int id;
  final String codeNo;

  @override
  List<Object?> get props => [id, codeNo];
}
