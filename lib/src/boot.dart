import 'package:shared_preferences/shared_preferences.dart';

import 'better_try_catch.dart';

class Boot {
  static _OperationsHandler? operator;

  init() async {
    await _initInternal();
  }

  _initInternal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    operator = _BootOperator(prefs);
  }

  _BootBuilder executeOnce(String mark, block()) {
    return _BootBuilder.withMark(mark).execute(block);
  }

  List<_Operation> getAllOperations() {
    assertInitialized();
    return operator!.getAllOperations();
  }

  bool isExecuted(String mark) {
    assertInitialized();
    return operator!.isExecuted(mark);
  }

  assertInitialized() {
    assert(operator != null, "Boot has not been initialized");
  }
}

class _Operation {
  String mark;
  bool executed;

  _Operation._(this.mark, this.executed);

  static _Operation fromMark(String mark) {
    String internalMark = "flutter.boot.$mark";
    bool executed = Boot.operator?.isExecuted(internalMark) ?? false;
    return _Operation._(internalMark, executed);
  }

  @override
  String toString() {
    return "Operation( mark = $mark, executed = $executed)";
  }
}

class _BootBuilder {
  _Operation operation;

  _BootBuilder._(this.operation) {
    _alreadyExecuted = operation.executed;
  }

  bool _alreadyExecuted = false;

  static _BootBuilder withMark(String mark) {
    return _BootBuilder._(_Operation.fromMark(mark));
  }

  bool isExecuted() {
    return _alreadyExecuted;
  }

  _BootBuilder setExecuted() {
    Boot.operator?.setExecuted(operation);
    return this;
  }

  _BootBuilder execute(block()) {
    Boot.operator?.executeOnce(operation, block);
    return this;
  }

  alreadyExecuted(operation()) {
    if (_alreadyExecuted) operation();
  }
}

class _BootOperator implements _OperationsHandler {
  SharedPreferences prefs;

  _BootOperator(this.prefs);

  @override
  bool isExecuted(String mark) {
    return prefs.getBool(mark) ?? false;
  }

  @override
  setExecuted(_Operation operation) {
    prefs.setBool(operation.mark, true);
    operation.executed = true;
  }

  @override
  executeOnce(_Operation operation, block) {
    if (!isExecuted(operation.mark))
      runCatching(block).onSuccess((value) {
        setExecuted(operation);
      });
  }

  @override
  List<_Operation> getAllOperations() {
    return prefs.getKeys().map((String key) {
      return _Operation.fromMark(key);
    }).toList();
  }
}

abstract class _OperationsHandler {
  bool isExecuted(String mark);

  setExecuted(_Operation operation);

  executeOnce(_Operation operation, block);

  List<_Operation> getAllOperations();
}
