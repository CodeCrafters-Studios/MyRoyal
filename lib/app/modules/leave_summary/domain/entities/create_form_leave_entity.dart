import 'package:equatable/equatable.dart';

class CreateFormLeaveEntity extends Equatable {
  final int id;
  final String codeNo;

  const CreateFormLeaveEntity({
    required this.id,
    required this.codeNo,
  });

  @override
  List<Object?> get props => [id, codeNo];
}
