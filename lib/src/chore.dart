import 'package:shared_preferences/shared_preferences.dart';

import 'better_try_catch.dart';

class Chore {
  static _OperationsHandler? _operator;

  static final Chore _instance = Chore._internal();

  Chore._();

  factory Chore() {
    return _instance;
  }

  Chore._internal();

  static init() async {
    await _instance._init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _operator = _ChoreOperator(prefs);
  }

  static _ChoreBuilder executeOnce(String mark, block()) {
    return _instance._executeOnce(mark, block);
  }

  static List<_Operation> getAllOperations() {
    _assertInitialized();
    return _instance._getAllOperations();
  }

  static bool isExecuted(String mark) {
    _assertInitialized();
    return _instance._isExecuted(mark);
  }

  static _assertInitialized() {
    assert(_operator != null, "Chore has not been initialized");
  }

  _ChoreBuilder _executeOnce(String mark, Function() block) {
    return _ChoreBuilder.withMark(mark)._executeOnce(block);
  }

  List<_Operation> _getAllOperations() {
    return _operator!.getAllOperations();
  }

  bool _isExecuted(String mark) {
    return _operator!.isExecuted(mark);
  }
}

class _Operation {
  String mark;
  bool executed;

  _Operation._(this.mark, this.executed);

  static _Operation fromMark(String mark) {
    String internalMark = "flutter.chore.$mark";
    bool executed = Chore._operator?.isExecuted(internalMark) ?? false;
    return _Operation._(internalMark, executed);
  }

  @override
  String toString() {
    return "Operation( mark = $mark, executed = $executed)";
  }
}

class _ChoreBuilder {
  _Operation _operation;

  _ChoreBuilder._(this._operation) {
    _alreadyExecuted = _operation.executed;
  }

  bool _alreadyExecuted = false;

  static _ChoreBuilder withMark(String mark) {
    return _ChoreBuilder._(_Operation.fromMark(mark));
  }

  bool _isExecuted() {
    return _alreadyExecuted;
  }

  _ChoreBuilder _setExecuted() {
    Chore._operator?.setExecuted(_operation);
    return this;
  }

  _ChoreBuilder _executeOnce(block()) {
    Chore._operator?.executeOnce(_operation, block);
    return this;
  }

  alreadyExecuted(operation()) {
    if (_alreadyExecuted) operation();
  }
}

class _ChoreOperator implements _OperationsHandler {
  SharedPreferences prefs;

  _ChoreOperator(this.prefs);

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
