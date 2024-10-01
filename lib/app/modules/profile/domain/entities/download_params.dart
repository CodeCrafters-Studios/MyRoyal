import 'package:equatable/equatable.dart';

class DownloadParams extends Equatable {
  const DownloadParams({required this.url, required this.fileName});

  final String url;
  final String fileName;

  @override
  List<Object?> get props => [url, fileName];
}
