import 'package:equatable/equatable.dart';

class TapNotificationDataEntities extends Equatable {
  const TapNotificationDataEntities(this.id, this.recipientType, this.route);

  final int id;
  final String recipientType;
  final String route;

  @override
  List<Object?> get props => [id, recipientType, route];
}
