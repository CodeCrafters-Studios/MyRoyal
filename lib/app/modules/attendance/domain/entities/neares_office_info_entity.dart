class NearestOfficeInfo {
  final String locationName;
  final String type;
  final double distanceToCenter;
  final double distanceToBoundary;
  final double radius;
  final bool inside;

  NearestOfficeInfo({
    required this.locationName,
    required this.type,
    required this.distanceToCenter,
    required this.distanceToBoundary,
    required this.radius,
    required this.inside,
  });
}
