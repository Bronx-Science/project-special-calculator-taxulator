import 'dart:math';

import 'package:real_calculator_app/access_location.dart';
import 'package:real_calculator_app/calc_button.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:real_calculator_app/tax_rates.dart';

class CalculatorView extends StatefulWidget {
  final String location;
  const CalculatorView({Key? key, required this.location}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;
  final horizontal = ScrollController();

  buttonPressed(String buttonText) {
    // used to check if the result contains a decimal
    String doesContainDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return result = splitDecimal[0].toString();
        }
      }
      return result;
    }

    setState(() {
      if (buttonText == "AC") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "+/-") {
        if (equation[0] != '-') {
          equation = '-$equation';
        } else {
          equation = equation.substring(1);
        }
      } else if (buttonText == 'tax') {
        if (equation != "0") {
          final double taxRate = stateSalesTaxRatesAbbr[widget.location] ??
              stateSalesTaxRates[widget.location] ??
              0.0;
          equation =
              '($equation)×(1.00+${stateSalesTaxRates[widget.location]})';
          print(widget.location);
        }
      } else if (buttonText == "sin" || buttonText == "cos") {
        if (equation == '0') {
          equation + buttonText;
        } else if (equation.endsWith('+') ||
            equation.endsWith('÷') ||
            equation.endsWith('%') ||
            equation.endsWith('-')) {
          equation = equation + buttonText;
        } else {
          equation = '$buttonText($equation)';
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('%', '%');
        expression = expression.replaceAll('π', pi.toString());

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (expression.contains('%')) {
            result = doesContainDecimal(result);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black54,
          leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
          actions: const [
            Text('DEG', style: TextStyle(color: Colors.white38)),
            SizedBox(width: 20),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: RawScrollbar(
                  thumbVisibility: true,
                  thickness: 4,
                  controller: horizontal,
                  child: SingleChildScrollView(
                    reverse: true,
                    controller: horizontal,
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(result,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 60))),
                            Icon(Icons.more_vert,
                                color: Theme.of(context).primaryColor,
                                size: 30),
                            const SizedBox(width: 20),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(equation,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white38,
                                  )),
                            ),
                            IconButton(
                              icon: Icon(Icons.backspace_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 30),
                              onPressed: () {
                                buttonPressed("⌫");
                              },
                            ),
                            const SizedBox(width: 20),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        calcButton(
                            'sin', Colors.white10, () => buttonPressed('sin')),
                        const SizedBox(width: 10),
                        calcButton(
                            'cos', Colors.white10, () => buttonPressed('cos')),
                        const SizedBox(width: 10),
                        calcButton(
                            'π', Colors.white10, () => buttonPressed('π')),
                        const SizedBox(width: 10),
                        calcButton(
                            'TAX', Colors.white10, () => buttonPressed('tax'))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        calcButton(
                            'AC', Colors.white10, () => buttonPressed('AC')),
                        const SizedBox(width: 10),
                        calcButton(
                            '%', Colors.white10, () => buttonPressed('%')),
                        const SizedBox(width: 10),
                        calcButton(
                            '÷', Colors.white10, () => buttonPressed('÷')),
                        const SizedBox(width: 10),
                        calcButton(
                            "×", Colors.white10, () => buttonPressed('×')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        calcButton(
                            '7', Colors.white24, () => buttonPressed('7')),
                        const SizedBox(width: 10),
                        calcButton(
                            '8', Colors.white24, () => buttonPressed('8')),
                        const SizedBox(width: 10),
                        calcButton(
                            '9', Colors.white24, () => buttonPressed('9')),
                        const SizedBox(width: 10),
                        calcButton(
                            '-', Colors.white10, () => buttonPressed('-')),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        calcButton(
                            '4', Colors.white24, () => buttonPressed('4')),
                        const SizedBox(width: 10),
                        calcButton(
                            '5', Colors.white24, () => buttonPressed('5')),
                        const SizedBox(width: 10),
                        calcButton(
                            '6', Colors.white24, () => buttonPressed('6')),
                        const SizedBox(width: 10),
                        calcButton(
                            '+', Colors.white10, () => buttonPressed('+')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // calculator number buttons

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceAround
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                calcButton('1', Colors.white24,
                                    () => buttonPressed('1')),
                                const SizedBox(width: 10),
                                calcButton('2', Colors.white24,
                                    () => buttonPressed('2')),
                                const SizedBox(width: 10),
                                calcButton('3', Colors.white24,
                                    () => buttonPressed('3')),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                calcButton('+/-', Colors.white24,
                                    () => buttonPressed('+/-')),
                                const SizedBox(width: 10),
                                calcButton('0', Colors.white24,
                                    () => buttonPressed('0')),
                                const SizedBox(width: 10),
                                calcButton('.', Colors.white24,
                                    () => buttonPressed('.')),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        calcButton('=', Theme.of(context).primaryColor,
                            () => buttonPressed('=')),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
