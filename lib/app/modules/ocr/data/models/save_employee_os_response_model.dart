class SaveEmployeeOsResponseModel {
  final int code;
  final String message;
  final dynamic data;

  SaveEmployeeOsResponseModel({
    required this.code,
    required this.message,
    this.data,
  });

  factory SaveEmployeeOsResponseModel.fromJson(Map<String, dynamic> json) =>
      SaveEmployeeOsResponseModel(
        code: (json['code'] as num?)?.toInt() ?? 0,
        message: json['message']?.toString() ?? '',
        data: json['data'],
      );

  bool get success => code == 200;
}
