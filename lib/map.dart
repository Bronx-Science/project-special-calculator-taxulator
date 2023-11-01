import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:taxulator/access_location.dart';
import 'package:taxulator/calculator_view.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapboxMap? mapboxMap;
  CircleAnnotation? circleAnnotation;
  CircleAnnotationManager? circleAnnotationManager;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.annotations.createCircleAnnotationManager().then((value) {
      circleAnnotationManager = value;
      circleAnnotationManager!
          .addOnCircleAnnotationClickListener(AnnotationClickListener());
    });
  }

  _onTapListener(ScreenCoordinate coordinates, BuildContext context) {
    print('${coordinates.x} ${coordinates.y}');
    circleAnnotationManager?.create(CircleAnnotationOptions(
      geometry:
          Point(coordinates: Position(coordinates.y, coordinates.x)).toJson(),
      circleRadius: 8.0,
      circleOpacity: 0.0,
      circleStrokeColor: Colors.green.value,
      circleStrokeOpacity: 1.0,
      circleStrokeWidth: 2.0,
    ));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => FutureBuilder(
            future: fetchTaxRateManual(
                latitude: coordinates.x, longitude: coordinates.y),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CalculatorView(
                    taxRate: jsonDecode(snapshot.data!.body)[0]['total_rate']);
              } else {
                print(snapshot.connectionState);
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                return const SafeArea(
                    child: SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: Center(child: CircularProgressIndicator())));
              }
            })));
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
        onMapCreated: _onMapCreated,
        onTapListener: (coordinates) => _onTapListener(coordinates, context),
        styleUri: 'mapbox://styles/fahimh21/clocyv5oc00gk01qv6dtf5kjf',
        resourceOptions: ResourceOptions(
            accessToken:
                'pk.eyJ1IjoiZmFoaW1oMjEiLCJhIjoiY2xvNXM2Mml0MGQ5NTJqcW5kMGU0bDZtYyJ9.NlwdKychv2iqGuNF2-TDyA'));
  }
}

class AnnotationClickListener extends OnCircleAnnotationClickListener {
  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.geometry}");
  }
}
