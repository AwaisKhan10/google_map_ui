// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_map_api/core/others/screen_utils.dart';
import 'package:google_map_api/ui/screens/order_tracking_view_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderTrackingViewModel(),
      child: Consumer<OrderTrackingViewModel>(
        builder: (context, model, child) => Scaffold(
          body: model.currentLocation == null
              ? Center(
                  child: Text(
                    "Loading",
                    style: TextStyle(fontSize: 25.sp, color: Colors.black),
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(model.currentLocation!.latitude!,
                          model.currentLocation!.latitude!),
                      zoom: 12.5),
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: model.polylinesCordinates,
                      color: Colors.blue,
                      width: 10,
                    )
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(model.currentLocation!.latitude!,
                          model.currentLocation!.latitude!),
                    ),
                    Marker(
                      markerId: const MarkerId('source'),
                      position: model.sourceLocation,
                    ),
                    Marker(
                      markerId: const MarkerId('destination'),
                      position: model.destination,
                    ),
                  },
                ),
        ),
      ),
    );
  }
}
