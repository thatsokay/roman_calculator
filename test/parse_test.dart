import 'package:flutter_test/flutter_test.dart';

import 'package:roman_calculator/parse.dart';

void main() {
  group('Parse', () {
    const parseResults = {
      'I': 1, // Simple numbers
      'V': 5,
      'X': 10,
      'L': 50,
      'C': 100,
      'D': 500,
      'M': 1000,
      'VII': 7, // Compound numbers
      'CXI': 111,
      'IV': 4, // Subtractions
      'IX': 9,
      'XC': 90,
      'XIX': 19,
      'XCI': 91,
      'N': 0, // Zero and nothing
      '': null,
      'A': null, // Invalid characters
      'XAI': null,
      'IC': null, // Invalid ordering
      'VX': null,
      'IIV': null,
      'VV': null,
      'VIV': null,
      'IVI': null,
      'IIII': null,
    };

    parseResults.forEach(
      (symbol, result) => test(symbol, () {
        expect(parseRoman(symbol), equals(result));
      }),
    );
  });

  group('Generate', () {
    const generateResults = {
      1: 'I',
      5: 'V',
      10: 'X',
      50: 'L',
      100: 'C',
      500: 'D',
      1000: 'M',
      7: 'VII',
      101: 'CI',
      4: 'IV',
      9: 'IX',
      0: 'N',
      -1: '-I', // Negative numbers
      -4: '-IV',
      4000: null, // Big numbers
      9000: null,
      250000: null,
    };

    generateResults.forEach(
      (number, result) => test(number.toString(), () {
        expect(generateRoman(number), equals(result));
      })
    );
  });
}
