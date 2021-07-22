import 'package:shared_preferences/shared_preferences.dart';

import 'better_try_catch.dart';
import 'operation.dart';
import 'operations_handler.dart';

class BootOperator implements OperationsHandler {
  SharedPreferences prefs;

  BootOperator(this.prefs);

  @override
  bool isExecuted(String mark) {
    return prefs.getBool(mark) ?? false;
  }

  @override
  setExecuted(Operation operation) {
    prefs.setBool(operation.mark, true);
    operation.executed = true;
  }

  @override
  executeOnce(Operation operation, block) {
    if (!isExecuted(operation.mark))
      runCatching(block).onSuccess((value) {
        setExecuted(operation);
      });
  }

  @override
  List<Operation> getAllOperations() {
    return prefs.getKeys().map((String key) {
      bool value = prefs.getBool(key) ?? false;
      bool executed = value;
      return Operation(key, executed);
    }).toList();
  }
}
