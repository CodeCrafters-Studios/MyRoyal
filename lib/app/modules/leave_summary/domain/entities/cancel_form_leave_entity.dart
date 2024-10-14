import 'package:equatable/equatable.dart';

class CancelFormLeaveEntity extends Equatable {
  const CancelFormLeaveEntity({
    required this.id,
    required this.codeNo,
  });

  final int id;
  final String codeNo;

  @override
  List<Object?> get props => [id, codeNo];
}
