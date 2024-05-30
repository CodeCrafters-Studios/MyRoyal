class ApiException implements Exception {
  ApiException(this.message);

  final String? message;
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
