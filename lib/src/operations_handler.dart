import 'operation.dart';

abstract class OperationsHandler {
  bool isExecuted(String mark);

  setExecuted(Operation operation);

  executeOnce(Operation operation, block);

  List<Operation> getAllOperations();
}
