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
  int _result = 0; // Current calculated result
  String _input = ''; // Roman numeral input
  String _operation = '+'; // Last selected operation

  FlatButton numberButton(String value) {
    /* Returns a button that displays the given string and appends the
     * calculator input with the given string when pressed.
     */
    return FlatButton(
      onPressed: () {
        setState(() {
          _error = false;
          _input += value;
          if (_operation == '=') {
            // Reset calculator if previous operation was an evaluation
            _result = 0;
            _operation = '+';
          }
        });
      },
      child: Text(value, style: TextStyle(fontSize: 18.0)),
    );
  }

  FlatButton operationButton(String value) {
    /* Returns a button that displays the given string and sets the calculator
     * operation to the given string when pressed.
     */
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

          switch (_operation) {
            // Apply last operation on parsed input
            case '+':
              _result += parseResult;
              break;
            case '−':
              _result -= parseResult;
              break;
            case '×':
              _result *= parseResult;
              break;
            case '÷':
              if (parseResult == 0) {
                // Dividing by 0 returns 0
                _result = 0;
                break;
              }
              _result = _result ~/ parseResult;
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
      child: Text(value, style: TextStyle(fontSize: 18.0)),
    );
  }

  FlatButton deleteButton() {
    /* Returns a delete button that removes the rightmost character from the
     * input string.
     */
    return FlatButton(
      onPressed: () {
        setState(() {
          _error = false;
          _input = _input.substring(0, max(_input.length - 1, 0));
        });
      },
      child: Text('Del', style: TextStyle(fontSize: 18.0)),
    );
  }

  FlatButton clearButton() {
    /* Returns a clear button that sets the input to an empty string.
     */
    return FlatButton(
      onPressed: () {
        setState(() {
          _error = false;
          _result = 0;
          _input = '';
          _operation = '+';
        });
      },
      child: Text('Clear', style: TextStyle(fontSize: 18.0)),
    );
  }

  List<Expanded> generateButtons() {
    /* Returns a list of expanded rows of buttons.
     */
    var buttonTexts = [
      [numberButton('M'), deleteButton(), operationButton('÷')],
      [numberButton('C'), numberButton('D'), operationButton('×')],
      [numberButton('X'), numberButton('L'), operationButton('−')],
      [numberButton('I'), numberButton('V'), operationButton('+')],
      [numberButton('N'), clearButton(), operationButton('=')],
    ];

    return buttonTexts
        .map(
          (row) => Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: row.map((button) => Expanded(child: button)).toList(),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Text(
            _error
                ? 'nope'
                : (_input.isEmpty
                    ? (generateRoman(_result) ?? 'nope')
                    : _input),
            key: Key('display'),
            style: TextStyle(fontSize: 48.0, height: 1.5),
          ),
          ...generateButtons(),
        ],
      ),
    );
  }
}
