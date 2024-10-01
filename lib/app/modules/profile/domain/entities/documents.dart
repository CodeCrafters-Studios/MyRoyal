import 'package:equatable/equatable.dart';

class Documents extends Equatable {
  const Documents({
    required this.name,
    required this.type,
    required this.url,
    required this.ext,
  });

  final String name;
  final String type;
  final String url;
  final String ext;

  @override
  List<Object?> get props => [name, type, url, ext];
}
