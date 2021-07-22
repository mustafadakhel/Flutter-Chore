import 'package:shared_preferences/shared_preferences.dart';

import 'boot_builder.dart';
import 'boot_operator.dart';
import 'operation.dart';
import 'operations_handler.dart';

class Boot {
  static OperationsHandler? operator;

  init() async {
    await _initInternal();
  }

  _initInternal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    operator = BootOperator(prefs);
  }

  BootBuilder executeOnce(String mark, block()) {
    return BootBuilder.withMark(mark).execute(block);
  }

  List<Operation> getAllOperations() {
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
