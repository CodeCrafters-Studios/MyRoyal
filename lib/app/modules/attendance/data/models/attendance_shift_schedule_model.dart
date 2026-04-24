class AttendanceShiftScheduleModel {
  final DateTime shiftStart;
  final DateTime? breakStart;
  final DateTime? breakEnd;
  final DateTime shiftEnd;

  AttendanceShiftScheduleModel({
    required this.shiftStart,
    required this.breakStart,
    required this.breakEnd,
    required this.shiftEnd,
  });

  factory AttendanceShiftScheduleModel.fromJson(Map<String, dynamic> json) {
    return AttendanceShiftScheduleModel(
      shiftStart: DateTime.parse(
        json["shiftstart"],
      ),
      breakStart: json["breakstart"] != null
          ? DateTime.parse(
              json["breakstart"],
            )
          : null,
      breakEnd: json["breakend"] != null
          ? DateTime.parse(
              json["breakend"],
            )
          : null,
      shiftEnd: DateTime.parse(
        json["shiftend"],
      ),
    );
  }
}
