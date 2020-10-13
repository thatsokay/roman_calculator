import 'package:flutter/material.dart';
import 'dart:math';

import 'parse.dart';

void main() => runApp(RomanCalculatorApp());

class RomanCalculatorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roman Calculator',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto Slab',
      ),
      home: RomanCalculator(title: 'Roman Calculator'),
    );
  }
}

class RomanCalculator extends StatefulWidget {
  RomanCalculator({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RomanCalculatorState createState() => _RomanCalculatorState();
}

class _RomanCalculatorState extends State<RomanCalculator> {
  bool _error = false; // Displays error message if true
  int _result; // Current calculated result
  String _input = ''; // Roman numeral input
  Operation _operation = Operation.add; // Last selected operation

  /// Returns a button that displays the given string and appends the calculator input with the given string when pressed.
  CalculatorButton numberButton(String value) {
    return CalculatorButton(
      onPressed: () {
        setState(() {
          _error = false;
          _input += value;
          if (_operation == Operation.equals) {
            // Reset calculator if previous operation was an evaluation
            _result = null;
            _operation = Operation.add;
          }
        });
      },
      label: value,
    );
  }

  /// Returns a button that displays the given string and sets the calculator operation to the given string when pressed.
  CalculatorButton operationButton(Operation operation) {
    return CalculatorButton(
      onPressed: () {
        setState(() {
          if (_input.isEmpty) {
            // Just change operation if empty input
            _operation = operation;
            return;
          }

          var parseResult = parseRoman(_input);
          if (parseResult == null) {
            // Show error and reset calculator on parsing error
            _error = true;
            _input = '';
            _result = null;
            _operation = Operation.add;
            return;
          }

          _result = _operation.operate(_result ?? 0, parseResult);
          _input = '';
          _operation = operation;
        });
      },
      label: operation.label,
    ); // CalculatorButton
  }

  /// Returns a delete button that removes the rightmost character from the input string.
  CalculatorButton deleteButton() {
    return CalculatorButton(
      onPressed: () {
        setState(() {
          _error = false;
          _input = _input.substring(0, max(_input.length - 1, 0));
        });
      },
      label: 'Del',
    );
  }

  /// Returns a clear button that sets the input to an empty string.
  CalculatorButton clearButton() {
    return CalculatorButton(
      onPressed: () {
        setState(() {
          _error = false;
          _result = null;
          _input = '';
          _operation = Operation.add;
        });
      },
      label: 'Clear',
    );
  }

  /// Returns a table of buttons.
  Table generateButtons() {
    var buttons = [
      [deleteButton(), clearButton(), operationButton(Operation.divide)],
      [
        numberButton('D'),
        numberButton('M'),
        operationButton(Operation.multiply)
      ],
      [
        numberButton('L'),
        numberButton('C'),
        operationButton(Operation.subtract)
      ],
      [numberButton('V'), numberButton('X'), operationButton(Operation.add)],
      [numberButton('N'), numberButton('I'), operationButton(Operation.equals)],
    ];

    return Table(
      children: buttons
          .map((row) => TableRow(
              children: row
                  .map((button) => AspectRatio(
                        aspectRatio: 6 / 5,
                        child: button,
                      ))
                  .toList()))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _error
                      ? 'nope'
                      : _input.isNotEmpty
                          ? _input
                          : _result == null
                              ? ''
                              : generateRoman(_result) ?? 'nope',
                  key: Key('display'),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 60.0,
                    height: 1.5,
                    color: _input.isNotEmpty && parseRoman(_input) == null
                        ? Colors.red.shade700
                        : Colors.black,
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                top: 24, // Notification bar height
                left: 36,
                right: 36,
              ),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 12)
              ]),
            ),
          ),
          generateButtons(),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;

  const CalculatorButton({this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 32.0)),
    );
  }
}

enum Operation { add, subtract, multiply, divide, equals }

extension OperationExtension on Operation {
  String get label {
    switch (this) {
      case Operation.add:
        return '+';
      case Operation.subtract:
        return '−';
      case Operation.multiply:
        return '×';
      case Operation.divide:
        return '÷';
      case Operation.equals:
        return '=';
      default:
        throw 'Invalid operation';
    }
  }

  int operate(int a, int b) {
    switch (this) {
      case Operation.add:
        return a + b;
      case Operation.subtract:
        return a - b;
      case Operation.multiply:
        return a * b;
      case Operation.divide:
        if (b == 0) {
          // Dividing by 0 returns 0
          return 0;
        }
        return a ~/ b;
      case Operation.equals:
        return a;
      default:
        throw 'Invalid operation';
    }
  }
}
