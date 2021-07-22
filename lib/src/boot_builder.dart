import 'boot.dart';
import 'operation.dart';

class BootBuilder {
  Operation operation;

  BootBuilder._(this.operation) {
    _alreadyExecuted = operation.executed;
  }

  bool _alreadyExecuted = false;

  static BootBuilder withMark(String mark) {
    return BootBuilder._(Operation.fromMark(mark));
  }

  bool isExecuted() {
    return _alreadyExecuted;
  }

  BootBuilder setExecuted() {
    Boot.operator?.setExecuted(operation);
    return this;
  }

  BootBuilder execute(block()) {
    Boot.operator?.executeOnce(operation, block);
    return this;
  }

  alreadyExecuted(operation()) {
    if (_alreadyExecuted) operation();
  }
}
