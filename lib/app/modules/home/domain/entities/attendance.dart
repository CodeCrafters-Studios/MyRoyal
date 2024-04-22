import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  const Attendance({
    required this.todayCheckin,
    required this.yesterdayCheckin,
    required this.yesterdayCheckout,
  });

  final String todayCheckin;
  final String yesterdayCheckin;
  final String yesterdayCheckout;

  @override
  List<Object?> get props => [
        todayCheckin,
        yesterdayCheckin,
        yesterdayCheckout,
      ];
}
