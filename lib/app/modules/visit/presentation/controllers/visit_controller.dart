import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iroyal/app/modules/visit/domain/entities/locations.dart';
import 'package:iroyal/app/modules/visit/domain/usecases/get_locations.dart';

class VisitController extends GetxController {
  VisitController({
    required this.getlocations,
  });

  final GetLocations getlocations;
  final RxString valueListener = ''.obs;
  final Rxn<LatLng> currentPosition = Rxn<LatLng>();
  final Rxn<LatLng> getPosition = Rxn<LatLng>();
  final RxnString locationError = RxnString();
  final RxList<Locations> locationsData = <Locations>[].obs;
  final RxInt setIndex = 0.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;

  late GoogleMapController mapController;
  final Completer<GoogleMapController> controller = Completer();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchLocations();
  }

  void clear() {
    valueListener.value = '';
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      currentPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      locationError.value = "Failed to get location: ${e.toString()}";
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (!this.controller.isCompleted) {
      mapController = controller;
      this.controller.complete(controller);
    }
  }

  Future<void> fetchLocations() async {
    final result = await getlocations();
    result.fold(
      (failure) {
        // handle failure
      },
      (locations) {
        locationsData.value = locations;
        updateMarkers(locations);
      },
    );
  }

  void setLocation(double lat, double lng, int index) {
    setIndex.value = index;
    getPosition.value = LatLng(lat, lng);
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18),
    );
  }

  void updateMarkers(List<Locations> locations) {
    markers.clear();
    for (var location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: LatLng(location.lat, location.long),
        ),
      );
    }
  }
}
