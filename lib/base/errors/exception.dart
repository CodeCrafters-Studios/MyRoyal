class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.responseData});

  final String? message;
  final int? statusCode;
  final dynamic responseData;
}

class CacheException implements Exception {
  CacheException(this.message);

  final String message;
}

class BiometricsException implements Exception {
  BiometricsException(this.message);

  final String message;
}

class LocalDataException implements Exception {
  LocalDataException(this.message);

  final String message;
}
