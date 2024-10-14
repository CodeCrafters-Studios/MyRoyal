import 'package:equatable/equatable.dart';

class DataLeaveEntity extends Equatable {
  const DataLeaveEntity({
    required this.codeNo,
    required this.reason,
    required this.status,
    required this.periode,
    required this.typeLeave,
    required this.canCancel,
  });

  final String codeNo;
  final String reason;
  final String status;
  final Periode periode;
  final String typeLeave;
  final bool canCancel;

  @override
  List<Object?> get props => [
        codeNo,
        reason,
        status,
        periode,
        typeLeave,
        canCancel,
      ];
}

class Periode {
  final String start;
  final String end;

  Periode({
    required this.start,
    required this.end,
  });

  factory Periode.fromJson(Map<String, dynamic> json) => Periode(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}
