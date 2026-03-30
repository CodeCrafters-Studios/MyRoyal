import 'package:MyRoyal/app/modules/profile/domain/entities/download_params.dart';

class DownloadParamsModel extends DownloadParams {
  const DownloadParamsModel({required super.url, required super.fileName});

  factory DownloadParamsModel.fromDownloadParams(DownloadParams json) =>
      DownloadParamsModel(
        url: json.url,
        fileName: json.fileName,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'file_name': fileName,
      };
}
