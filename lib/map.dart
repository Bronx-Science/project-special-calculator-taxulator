import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MapWidget(
        resourceOptions: ResourceOptions(
            accessToken:
                'pk.eyJ1IjoiZmFoaW1oMjEiLCJhIjoiY2xvNXM2Mml0MGQ5NTJqcW5kMGU0bDZtYyJ9.NlwdKychv2iqGuNF2-TDyA'));
  }
}
