import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap?.location.updateSettings(LocationComponentSettings(enabled: true, pulsingEnabled: true, puckBearingEnabled: true));
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
        onMapCreated: _onMapCreated,
        onTapListener: (coordinates) {
          print('${coordinates.x} ${coordinates.y}');
        },
        styleUri: 'mapbox://styles/fahimh21/clocyv5oc00gk01qv6dtf5kjf',
        resourceOptions: ResourceOptions(
            accessToken:
                'pk.eyJ1IjoiZmFoaW1oMjEiLCJhIjoiY2xvNXM2Mml0MGQ5NTJqcW5kMGU0bDZtYyJ9.NlwdKychv2iqGuNF2-TDyA'));
  }
}
