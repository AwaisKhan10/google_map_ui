// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_api/core/view_model/base_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingViewModel extends BaseViewModel {
  final Completer<GoogleMapController> completerController = Completer();
  LatLng sourceLocation = const LatLng(37.33500926, -122.03272188);
  LatLng destination = const LatLng(37.33429383, -122.06600055);
  LocationData? currentLocation;
  List<LatLng> polylinesCordinates = [];

  OrderTrackingViewModel() {
    getPolyPoints();
    getCurrentLocation();
  }

  getPolyPoints() async {
    print("Polyline inner");
    PolylinePoints polylinePoints = PolylinePoints();
    print("Polyline inner 1");

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: "AIzaSyAtnyzzRh7CbLyIs8DLMap4-OkHMtUVKSE",
        request: PolylineRequest(
          origin:
              PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polylinesCordinates.clear();
        for (PointLatLng point in result.points) {
          polylinesCordinates.add(LatLng(point.latitude, point.longitude));
        }
        print("Polyline coordinates updated: $polylinesCordinates");
        notifyListeners();
      } else {
        print("No points found in the polyline result.");
      }
    } catch (e) {
      print("polyline result error: $e");
    }

    notifyListeners();
  }

  getCurrentLocation() {
    Location location = Location();
    location.getLocation().then((location) {
      currentLocation = location;
      notifyListeners();
    });

    location.onLocationChanged.listen((newloc) {
      currentLocation = newloc;
      notifyListeners();
    });
    notifyListeners();
  }
}
