import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.properties = const []});

  // -- Notes
  // If the subclasses have some properties, they'll get passed to this constructor
  // so that Equatable can perform value comparison.
  // Failure([List properties = const <dynamic>[]]);

  final List<Object> properties;

  @override
  List<Object> get props => properties;
}

// General Failures
class ServerFailure extends Failure {
  const ServerFailure({super.properties});
}

class CacheFailure extends Failure {
  const CacheFailure({super.properties});
}

class BiometricsFailure extends Failure {
  const BiometricsFailure({super.properties});
}

class LocalDataFailure extends Failure {
  const LocalDataFailure({super.properties});
}
