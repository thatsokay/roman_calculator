import 'package:flutter/material.dart';
import 'dart:math';

import 'parse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  String _operation = '+'; // Last selected operation

  /// Returns a button that displays the given string and appends the calculator input with the given string when pressed.
  FlatButton numberButton(String value) {
    return FlatButton(
      onPressed: () {
        setState(() {
          _error = false;
          _input += value;
          if (_operation == '=') {
            // Reset calculator if previous operation was an evaluation
            _result = null;
            _operation = '+';
          }
        });
      },
      child: Text(value, style: TextStyle(fontSize: 32.0)),
    );
  }

  /// Returns a button that displays the given string and sets the calculator operation to the given string when pressed.
  FlatButton operationButton(String value) {
    return FlatButton(
      onPressed: () {
        setState(() {
          if (_input.isEmpty) {
            // Just change operation if empty input
            _operation = value;
            return;
          }

          var parseResult = parseRoman(_input);

          if (parseResult == null) {
            // Show error and reset calculator on parsing error
            _error = true;
            _input = '';
            _result = 0;
            _operation = '+';
            return;
          }

          var result = _result ?? 0;

          switch (_operation) {
            // Apply last operation on parsed input
            case '+':
              _result = result + parseResult;
              break;
            case '−':
              _result = result - parseResult;
              break;
            case '×':
              _result = result * parseResult;
              break;
            case '÷':
              if (parseResult == 0) {
                // Dividing by 0 returns 0
                _result = 0;
                break;
              }
              _result = result ~/ parseResult;
              break;
            case '=':
              break;
            default:
              throw 'Invalid operation';
          }

          _input = '';
          _operation = value;
        });
      },
      child: Text(value, style: TextStyle(fontSize: 32.0)),
    );
  }

  /// Returns a delete button that removes the rightmost character from the input string.
  FlatButton deleteButton() {
    return FlatButton(
      onPressed: () {
        setState(() {
          _error = false;
          _input = _input.substring(0, max(_input.length - 1, 0));
        });
      },
      child: Text('Del', style: TextStyle(fontSize: 32.0)),
    );
  }

  FlatButton clearButton() {
    /* Returns a clear button that sets the input to an empty string.
     */
    return FlatButton(
      onPressed: () {
        setState(() {
          _error = false;
          _result = null;
          _input = '';
          _operation = '+';
        });
      },
      child: Text('Clear', style: TextStyle(fontSize: 32.0)),
    );
  }

  /// Returns a table of buttons.
  Table generateButtons() {
    var buttons = [
      [deleteButton(), clearButton(), operationButton('÷')],
      [numberButton('D'), numberButton('M'), operationButton('×')],
      [numberButton('L'), numberButton('C'), operationButton('−')],
      [numberButton('V'), numberButton('X'), operationButton('+')],
      [numberButton('N'), numberButton('I'), operationButton('=')],
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
