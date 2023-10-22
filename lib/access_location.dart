import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';

Future<Response> fetchTaxRate(String postalCode) {
  return get(
      Uri.parse(
          'https://sales-tax-by-api-ninjas.p.rapidapi.com/v1/salestax?zip_code=$postalCode'),
      headers: {
        'X-RapidAPI-Key': '1cb4d18987msh1658afed41f819dp1a9f31jsnb68285f5c5e1',
        'X-RapidAPI-Host': 'sales-tax-by-api-ninjas.p.rapidapi.com'
      });
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Response> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true);
  print('${position.latitude} ${position.longitude}');
  List<Placemark> addy = await placemarkFromCoordinates(
      position.latitude, position.longitude,
      localeIdentifier: 'en_US');
  return fetchTaxRate(addy[0]!.postalCode!);
}
