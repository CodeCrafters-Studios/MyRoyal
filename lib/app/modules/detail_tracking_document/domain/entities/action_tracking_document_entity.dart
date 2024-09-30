import 'package:equatable/equatable.dart';

class ActionTrackingDocumentEntity extends Equatable {
  const ActionTrackingDocumentEntity({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final String data;

  @override
  List<Object?> get props => [code, message, data];
}
