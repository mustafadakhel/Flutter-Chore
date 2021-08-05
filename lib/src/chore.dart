import 'package:shared_preferences/shared_preferences.dart';

import 'better_try_catch.dart';

const String _base_key = "flutter.chore.";

class Chore {
  static _ChoreButler? _butler;

  static final Chore _instance = Chore._();

  Chore._();

  factory Chore() {
    return _instance;
  }

  /// Initializes the package
  ///
  /// This should be called from the main method and you should await
  /// for it to complete
  static init() async {
    await _instance._init();
  }

  _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _butler = _ChoreButler(prefs);
  }

  /// Registers a new chore
  ///
  /// Used to register a new chore with a unique [mark], the chore will
  /// call the code block specified in the [f] parameter only as many
  /// times as specified in the [times] parameter which defaults to 1
  ///
  /// [mark] the unique mark for the chore
  /// [times] the number of times to do the chore (defaults to 1)
  /// [f] the code block that is called only as many times as set in
  /// the [times] parameter
  ///
  /// Returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner newChore(
    String mark,
    f(int time), {
    int times = 1,
  }) {
    _assertInitialized();
    return _instance._newChore(mark, f, times: times);
  }

  /// Registers a chore using a builder
  ///
  /// Used to initialize a new builder that is used to build
  /// a new chore
  ///
  /// Returns a [_ChoreFuncBuilder] instance which enables you to set
  /// the function to be called
  static _ChoreFuncBuilder builder() {
    _assertInitialized();
    return _instance._builder();
  }

  _ChoreRunner _newChore(
    String mark,
    Function(int time) f, {
    int times = 1,
  }) {
    return _ChoreFuncBuilder._withBuilder(_ChoreBuilder(_butler!))
        .invoke(f)
        .times(times)
        .mark(mark);
  }

  _ChoreFuncBuilder _builder() {
    return _ChoreFuncBuilder._withBuilder(_ChoreBuilder(_butler!));
  }

  /// Registers a new chore that runs only once
  ///
  /// Used to register a new chore with a unique [mark], the chore will
  /// call the code block specified in the [f] parameter only once
  ///
  /// [mark] the unique mark for the chore
  /// [f] the code block that is called only once
  ///
  /// Returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner once(String mark, f()) {
    _assertInitialized();
    return _instance._once(mark, f);
  }

  /// Registers a new chore that runs only twice
  ///
  /// Used to register a new chore with a unique [mark], the chore will
  /// call the code block specified in the [f] parameter only twice
  ///
  /// [mark] the unique mark for the chore
  /// [f] the code block that is called only twice
  ///
  /// Returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner twice(String mark, f(int time)) {
    _assertInitialized();
    return _instance._twice(mark, f);
  }

  /// Registers a new chore that runs only thrice
  ///
  /// Used to register a new chore with a unique [mark], the chore will
  /// call the code block specified in the [f] parameter only thrice
  ///
  /// [mark] the unique mark for the chore
  /// [f] the code block that is called only thrice
  ///
  /// Returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner thrice(String mark, f(int time)) {
    _assertInitialized();
    return _instance._thrice(mark, f);
  }

  _ChoreRunner _once(String mark, f()) {
    return _ChoreFuncBuilder._withBuilder(_ChoreBuilder(_butler!))
        .invoke((_) {
          f();
        })
        .once()
        .mark(mark);
  }

  _ChoreRunner _twice(String mark, f(int time)) {
    return _ChoreFuncBuilder._withBuilder(_ChoreBuilder(_butler!))
        .invoke(f)
        .twice()
        .mark(mark);
  }

  _ChoreRunner _thrice(String mark, f(int time)) {
    return _ChoreFuncBuilder._withBuilder(_ChoreBuilder(_butler!))
        .invoke(f)
        .thrice()
        .mark(mark);
  }

  /// Get all the registered chores
  ///
  /// Used to get a list of all the chores that has been registered
  /// using any chore methods
  ///
  /// Returns a list of [ChoreItem] representing all the registered chores
  static List<ChoreItem> getAllChores() {
    _assertInitialized();
    return _instance._getAllChores();
  }

  List<ChoreItem> _getAllChores() {
    return _butler?._getAllChores() ?? [];
  }

  static _assertInitialized() {
    if (_butler == null) throw Exception("Chore has not been initialized");
  }
}

class _ChoreBuilder {
  late ChoreItem _choreItem = ChoreItem._empty();
  _ChoreButler _butler;

  _ChoreBuilder(this._butler);

  /// Mark the chore with a unique identifier
  ///
  /// Used to set a unique mark to identify the chore
  ///
  /// [mark] the unique mark for the chore
  ///
  /// Returns a [_ChoreRunner] instance which enables you to run the chore
  _ChoreRunner mark(String mark) {
    String internalMark = "$_base_key$mark";
    _choreItem
      ..mark = internalMark
      ..timesRemaining =
          _butler._timesRemaining(internalMark) ?? _choreItem._times
      ..done = _choreItem.timesRemaining == 0;
    return _ChoreRunner(_choreItem, _butler);
  }
}

class _ChoreFuncBuilder {
  _ChoreBuilder _builder;

  _ChoreFuncBuilder._withBuilder(this._builder);

  /// Set the code block to be called
  ///
  /// Used to set the code block that will be called only as many times
  /// as will be set later in the times parameter
  ///
  /// [f] the code block that is called only as many times as will be set
  /// in the times parameter
  ///
  /// Returns a [_ChoreTimesBuilder] instance which enables you to set
  /// the number of times this code block should be called
  _ChoreTimesBuilder invoke(f(int time)) {
    _builder._choreItem._func = f;
    return _ChoreTimesBuilder._withBuilder(_builder);
  }
}

class _ChoreTimesBuilder {
  _ChoreBuilder _builder;

  _ChoreTimesBuilder._withBuilder(this._builder);

  /// Set the number of times
  ///
  /// Used to set the number of times the previously specified code
  /// block should be called
  ///
  /// [times] the number of times
  ///
  /// Returns a [_ChoreBuilder] instance which enables you to set
  /// a unique mark for the chore
  _ChoreBuilder times(int times) {
    _builder._choreItem._times = times;
    return _builder;
  }

  /// Set the chore to be done only once
  ///
  /// Used to specify that the previously specified code block should
  /// be called only once
  ///
  /// Returns a [_ChoreBuilder] instance which enables you to set
  /// a unique mark for the chore
  _ChoreBuilder once() {
    _builder._choreItem._times = 1;
    return _builder;
  }

  /// Set the chore to be done only twice
  ///
  /// Used to specify that the previously specified code block should
  /// be called only twice
  ///
  /// Returns a [_ChoreBuilder] instance which enables you to set
  /// a unique mark for the chore
  _ChoreBuilder twice() {
    _builder._choreItem._times = 2;
    return _builder;
  }

  /// Set the chore to be done only thrice
  ///
  /// Used to specify that the previously specified code block should
  /// be called only thrice
  ///
  /// Returns a [_ChoreBuilder] instance which enables you to set
  /// a unique mark for the chore
  _ChoreBuilder thrice() {
    _builder._choreItem._times = 3;
    return _builder;
  }
}

class _ChoreRunner {
  ChoreItem _choreItem;
  _ChoreButler _butler;

  _ChoreRunner(this._choreItem, this._butler);

  /// Do the chore
  ///
  /// If the chore has been previously done as many times as specified in
  /// the times parameter then invoke the [_ChoreJanitor.ifDone] method,
  /// else call the code block that was specified in the f parameter
  ///
  /// Returns a [_ChoreJanitor] instance which enables you to observe
  /// the chore running stages
  _ChoreJanitor run() {
    _choreItem = _butler._run(_choreItem);
    return _ChoreJanitor(_choreItem);
  }
}

class _ChoreJanitor {
  ChoreItem _choreItem;

  _ChoreJanitor(this._choreItem);

  /// Run a code block if the chore was done
  ///
  /// Used to set the code block to be called whenever the [_ChoreRunner.run]
  /// was called but the chore was already done
  ///
  /// [func] the code block that is called if the chore was done
  ///
  /// Returns a [_ChoreJanitor] instance which enables you to set
  /// more methods to observe the running steps
  _ChoreJanitor ifDone(func()) {
    if (_choreItem.done) func();
    return this;
  }

  /// Run a code block before the last time
  ///
  /// Used to set the code block to be called when the chore has
  /// only one time left to be done
  ///
  /// [func] the code block that is called before the last time
  ///
  /// Returns a [_ChoreJanitor] instance which enables you to set
  /// more methods to observe the running steps
  _ChoreJanitor beforeLastTime(func()) {
    if (_choreItem.timesRemaining == 1) func();
    return this;
  }

  /// Run a code block on the second time
  ///
  /// Used to set the code block to be called when this is the second
  /// time the chore has been done
  ///
  /// [func] the code block that is called on the second time
  ///
  /// Returns a [_ChoreJanitor] instance which enables you to set
  /// more methods to observe the running steps
  _ChoreJanitor onSecondTime(func()) {
    if (_choreItem.timesRemaining == _choreItem._times - 2) func();
    return this;
  }
}

class ChoreItem {
  late Function(int time) _func;

  /// The unique mark that is used to identify the chore
  late String mark;

  /// If the chore was already done as many times as specified
  late bool done;

  /// The number of times remaining for the chore to be done
  int timesRemaining = 1;

  int _times = 1;

  ChoreItem._();

  ChoreItem._withTimesRemaining(
      {required this.timesRemaining, required this.mark}) {
    this.done = timesRemaining == 0;
  }

  ChoreItem._empty();

  @override
  String toString() {
    String className = runtimeType.toString();
    return "$className( Mark = $mark, Times Remaining=$timesRemaining, Done = $done)";
  }
}

class _ChoreButler {
  SharedPreferences prefs;

  _ChoreButler(this.prefs);

  ChoreItem _decreaseTimes(ChoreItem choreItem) {
    if (!choreItem.done) {
      choreItem.timesRemaining -= 1;
      prefs.setInt(choreItem.mark, choreItem.timesRemaining);
    }
    return choreItem;
  }

  bool _isDone(ChoreItem choreItem) {
    int? times = _timesRemaining(choreItem.mark);
    if (times == null) _registerChore(choreItem);
    return _timesRemaining(choreItem.mark)! == 0;
  }

  ChoreItem _run(ChoreItem choreItem) {
    if (!_isDone(choreItem))
      return runCatching(() {
            choreItem._func(choreItem._times - (choreItem.timesRemaining - 1));
          }).onSuccess((value) {
            return _decreaseTimes(choreItem);
          }).getOrNull() ??
          choreItem;
    else
      return choreItem;
  }

  List<ChoreItem> _getAllChores() {
    return prefs
        .getKeys()
        .where((String key) => key.startsWith("$_base_key"))
        .map(
          (String mark) => ChoreItem._withTimesRemaining(
              timesRemaining: _timesRemaining(mark) ?? 1, mark: mark)
            ..mark = mark.split('.').last,
        )
        .toList();
  }

  int? _timesRemaining(String mark) {
    return prefs.getInt(mark);
  }

  _registerChore(ChoreItem choreItem) {
    prefs.setInt(choreItem.mark, choreItem._times);
  }
}
