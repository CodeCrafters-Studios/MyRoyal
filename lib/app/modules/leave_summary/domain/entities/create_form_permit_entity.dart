import 'package:equatable/equatable.dart';

class CreateFormPermitEntity extends Equatable {
  final int id;
  final String codeNo;

  const CreateFormPermitEntity({
    required this.id,
    required this.codeNo,
  });

  @override
  List<Object?> get props => [id, codeNo];
}
