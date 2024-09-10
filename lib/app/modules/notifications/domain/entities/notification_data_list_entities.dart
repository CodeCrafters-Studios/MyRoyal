import 'package:equatable/equatable.dart';

class NotificationDataListEntities extends Equatable {
  const NotificationDataListEntities({
    required this.id,
    required this.createdAt,
    this.route = '',
    required this.body,
    required this.title,
    required this.isRead,
  });

  final int id;
  final DateTime createdAt;
  final String? route;
  final String body;
  final String title;
  final bool isRead;

  @override
  List<Object?> get props => [id, createdAt, route, body, title, isRead];
}
