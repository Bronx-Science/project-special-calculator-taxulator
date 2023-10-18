import 'package:flutter/material.dart';

Widget calcButton(
    String buttonText, Color buttonColor, void Function()? buttonPressed) {
  return Container(
    padding: const EdgeInsets.all(0),
    child: ElevatedButton(
      onPressed: buttonPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(1),
          minimumSize: Size(75, buttonText == '=' ? 150 : 75),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          backgroundColor: buttonColor),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    ),
  );
}
