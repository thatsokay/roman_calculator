class Operation {
  final String label;
  final int Function(int, int) operate;

  const Operation({this.label, this.operate});
}

class Operations {
  // https://github.com/flutter/flutter/blob/f30b7f4db9/packages/flutter/lib/src/material/colors.dart#L200
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  // ignore: unused_element
  Operations._();

  static final add = Operation(label: '+', operate: (a, b) => a + b);
  static final subtract = Operation(label: '−', operate: (a, b) => a - b);
  static final multiply = Operation(label: '×', operate: (a, b) => a * b);
  static final divide = Operation(label: '÷', operate: (a, b) => a ~/ b);
  static final equals = Operation(label: '=', operate: (a, _b) => a);
}
