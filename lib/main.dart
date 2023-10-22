import 'dart:convert';
import 'dart:ui';

import 'package:provider/provider.dart';
import 'package:real_calculator_app/access_location.dart';
import 'package:real_calculator_app/calculator_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class ColorData extends ChangeNotifier {
  Color? _color;
  SharedPreferences? _prefs;

  ColorData() {
    _getSavedColor();
  }

  _getSavedColor() async {
    _prefs = await SharedPreferences.getInstance();
    _color = Color(_prefs!.getInt('color') ?? Colors.lightBlue.value);
    notifyListeners();
  }

  Color get color => _color ?? Colors.lightBlue;
  setColor(Color color) async {
    assert(_prefs != null);
    _color = color;
    await _prefs!.setInt('color', color.value);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorData(),
      child: const RealMaterialApp(),
    );
  }
}

class RealMaterialApp extends StatelessWidget {
  const RealMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Provider.of<ColorData>(context).color),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      home: FutureBuilder(
        future: determinePosition(),
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
        },
      ),
    );
  }
}
