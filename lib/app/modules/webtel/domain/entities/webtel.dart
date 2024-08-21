import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/webtel/data/models/webtel_data_model.dart';

class Webtel extends Equatable {
  const Webtel({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final Map<String, List<WebtelDataModel>> data;

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
