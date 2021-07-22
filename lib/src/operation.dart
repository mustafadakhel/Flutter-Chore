import 'boot.dart';

class Operation {
  String mark;
  bool executed;

  Operation._(this.mark, this.executed);

  static Operation fromMark(String mark) {
    String internalMark = "flutter.boot.$mark";
    bool executed = Boot.operator?.isExecuted(internalMark) ?? false;
    return Operation._(internalMark, executed);
  }

  @override
  String toString() {
    return "Operation( mark = $mark, executed = $executed)";
  }
}
