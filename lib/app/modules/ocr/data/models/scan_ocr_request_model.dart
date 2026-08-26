import 'dart:convert';
import 'package:dio/dio.dart';

class ScanOcrFieldInput {
  final String value;
  final double confidence;

  ScanOcrFieldInput({
    required this.value,
    required this.confidence,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'confidence': confidence,
    };
  }
}

class ScanOcrRequestModel {
  final Map<String, ScanOcrFieldInput> data;
  final String? file;
  final String? imagePath;
  final int id;

  ScanOcrRequestModel({
    required this.data,
    this.file,
    this.imagePath,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((key, value) => MapEntry(key, value.toJson())),
      if (file != null) 'file': file,
      'id': id,
    };
  }

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'data':
          jsonEncode(data.map((key, value) => MapEntry(key, value.toJson()))),
      'id': id,
    };

    if (imagePath != null && imagePath!.isNotEmpty) {
      final fileName = imagePath!.split('/').last;
      map['file'] = await MultipartFile.fromFile(
        imagePath!,
        filename: fileName,
      );
    }

    return FormData.fromMap(map);
  }
}
