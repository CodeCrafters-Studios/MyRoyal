// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   late GoogleMapController mapController;
//   final Completer<GoogleMapController> _controller = Completer();
//   late Future<bool> _getCurrentLocationFuture;
//   LatLng? _currentPosition;
//   String? _locationError;

//   @override
//   void initState() {
//     _getCurrentLocationFuture = _getCurrentLocation();
//     super.initState();
//   }

//   Future<bool> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled, return error.
//       setState(() {
//         _locationError = "Location services are disabled.";
//       });
//       return false;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, return error.
//         setState(() {
//           _locationError = "Location permissions are denied.";
//         });
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, return error.
//       setState(() {
//         _locationError = "Location permissions are permanently denied.";
//       });
//       return false;
//     }

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         timeLimit: const Duration(seconds: 15),
//       );
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//       });
//       return true;
//     } catch (e) {
//       // Handle any other errors.
//       setState(() {
//         _locationError = "Failed to get location: ${e.toString()}";
//       });
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<bool>(
//         future: _getCurrentLocationFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || !snapshot.data!) {
//             return Center(
//               child: Text(
//                 _locationError ?? "Unknown error occurred",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             );
//           } else if (_currentPosition != null) {
//             return GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition!,
//                 zoom: 18,
//               ),
//               onMapCreated: (controller) {
//                 _controller.complete(controller);
//               },
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("1"),
//                   position: _currentPosition!,
//                 ),
//                 const Marker(
//                   markerId: MarkerId("2"),
//                   position: LatLng(-6.8617228, 107.5010659),
//                 ),
//                 // Add more markers here
//               },
//               circles: {
//                 Circle(
//                   circleId: const CircleId("2"),
//                   center: const LatLng(-6.8617228, 107.5010659),
//                   radius: 25.r,
//                   strokeWidth: 2,
//                   fillColor: const Color(0xFF006491).withOpacity(0.2),
//                 ),
//               },
//               // ToDo: Add polygon
//             );
//           } else {
//             return const Center(
//               child: Text("Failed to determine location."),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
