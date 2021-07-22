import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_boot/flutter_boot.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Boot();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
  });
}
