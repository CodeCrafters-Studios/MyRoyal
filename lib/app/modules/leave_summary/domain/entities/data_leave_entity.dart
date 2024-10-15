import 'package:equatable/equatable.dart';

class DataLeaveEntity extends Equatable {
  const DataLeaveEntity({
    required this.codeNo,
    required this.reason,
    required this.revisionReject,
    required this.status,
    required this.periode,
    required this.typeLeave,
    required this.canCancel,
    required this.listPeriode,
  });

  final String codeNo;
  final String reason;
  final String? revisionReject;
  final String status;
  final Periode periode;
  final String typeLeave;
  final bool canCancel;
  final List<String> listPeriode;

  @override
  List<Object?> get props => [
        codeNo,
        reason,
        status,
        periode,
        typeLeave,
        canCancel,
        listPeriode,
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
