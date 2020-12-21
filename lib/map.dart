import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatelessWidget {
  Map({this.iit});

  final LatLng iit;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: {
        new Marker(
          markerId: new MarkerId("IIT"),
          position: iit,
          alpha: 1,
        )
      },
      initialCameraPosition: CameraPosition(target: iit, zoom: 17),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }
}
