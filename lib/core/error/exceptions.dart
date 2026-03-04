class ServerException implements Exception {
  const ServerException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  const NetworkException();

  @override
  String toString() => 'NetworkException: No internet connection';
}
