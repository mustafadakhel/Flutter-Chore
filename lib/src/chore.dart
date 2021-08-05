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
  /// Use this to register a new chore with a unique [mark]
  ///
  /// [mark] the unique mark for the chore
  /// [times] the number of times to do the chore (defaults to 1)
  /// [f] the method that is invoked only as many times as set in
  /// the [times] parameter
  ///
  /// returns a [_ChoreRunner] instance which enables you to run the chore
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
  /// Use this to initialize a new builder that is used to build
  /// a new chore
  ///
  /// returns a [_ChoreFuncBuilder] instance which enables you to set
  /// the function to be invoked
  static _ChoreFuncBuilder builder() {
    _assertInitialized();
    return _instance._builder();
  }

  _ChoreRunner _newChore(
    String mark,
    Function(int time) f, {
    int times = 1,
  }) {
    return _ChoreFuncBuilder.withBuilder(_ChoreBuilder(_butler!))
        .invoke(f)
        .times(times)
        .mark(mark);
  }

  _ChoreFuncBuilder _builder() {
    return _ChoreFuncBuilder.withBuilder(_ChoreBuilder(_butler!));
  }

  /// Registers a new chore that runs only once
  ///
  /// Use this to register a new chore that runs only once with
  /// a unique [mark]
  ///
  /// [mark] the unique mark for the chore
  /// [f] the method that is invoked only once
  ///
  /// returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner once(String mark, f()) {
    _assertInitialized();
    return _instance._once(mark, f);
  }

  /// Registers a new chore that runs only twice
  ///
  /// Use this to register a new chore that runs only twice with
  /// a unique [mark]
  ///
  /// [mark] the unique mark for the chore
  /// [f] the method that is invoked only twice
  ///
  /// returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner twice(String mark, f(int time)) {
    _assertInitialized();
    return _instance._twice(mark, f);
  }

  /// Registers a new chore that runs only thrice
  ///
  /// Use this to register a new chore that runs only thrice with
  /// a unique [mark]
  ///
  /// [mark] the unique mark for the chore
  /// [f] the method that is invoked only thrice
  ///
  /// returns a [_ChoreRunner] instance which enables you to run the chore
  static _ChoreRunner thrice(String mark, f(int time)) {
    _assertInitialized();
    return _instance._thrice(mark, f);
  }

  _ChoreRunner _once(String mark, f()) {
    return _ChoreFuncBuilder.withBuilder(_ChoreBuilder(_butler!))
        .invoke((_) {
          f();
        })
        .once()
        .mark(mark);
  }

  _ChoreRunner _twice(String mark, f(int time)) {
    return _ChoreFuncBuilder.withBuilder(_ChoreBuilder(_butler!))
        .invoke(f)
        .twice()
        .mark(mark);
  }

  _ChoreRunner _thrice(String mark, f(int time)) {
    return _ChoreFuncBuilder.withBuilder(_ChoreBuilder(_butler!))
        .invoke(f)
        .thrice()
        .mark(mark);
  }

  /// Get all the registered chores
  ///
  /// Use this to get a list of all the chores that has been registered
  /// using any chore methods
  ///
  /// returns a list of [ChoreItem] representing all the registered chores
  static List<ChoreItem> getAllChores() {
    _assertInitialized();
    return _instance._getAllChores();
  }

  List<ChoreItem> _getAllChores() {
    return _butler?.getAllChores() ?? [];
  }

  static _assertInitialized() {
    if (_butler == null) throw Exception("Chore has not been initialized");
  }
}

class _ChoreBuilder {
  late ChoreItem _choreItem = ChoreItem._empty();
  _ChoreButler _butler;

  _ChoreBuilder(this._butler);

  _ChoreRunner mark(String mark) {
    String internalMark = "$_base_key$mark";
    _choreItem
      ..mark = internalMark
      ..timesRemaining =
          _butler.timesRemaining(internalMark) ?? _choreItem._times
      ..done = _choreItem.timesRemaining == 0;
    return _ChoreRunner(_choreItem, _butler);
  }
}

class _ChoreFuncBuilder {
  _ChoreBuilder _builder;

  _ChoreFuncBuilder.withBuilder(this._builder);

  _ChoreTimesBuilder invoke(f(int time)) {
    _builder._choreItem._func = f;
    return _ChoreTimesBuilder.withBuilder(_builder);
  }
}

class _ChoreTimesBuilder {
  _ChoreBuilder _builder;

  _ChoreTimesBuilder.withBuilder(this._builder);

  _ChoreBuilder times(int times) {
    _builder._choreItem._times = times;
    return _builder;
  }

  _ChoreBuilder once() {
    _builder._choreItem._times = 1;
    return _builder;
  }

  _ChoreBuilder twice() {
    _builder._choreItem._times = 2;
    return _builder;
  }

  _ChoreBuilder thrice() {
    _builder._choreItem._times = 3;
    return _builder;
  }
}

class _ChoreRunner {
  ChoreItem _choreItem;
  _ChoreButler _butler;

  _ChoreRunner(this._choreItem, this._butler);

  _ChoreJanitor run() {
    _choreItem = _butler.run(_choreItem);
    return _ChoreJanitor(_choreItem);
  }
}

class _ChoreJanitor {
  ChoreItem _choreItem;

  _ChoreJanitor(this._choreItem);

  _ChoreJanitor ifDone(func()) {
    if (_choreItem.done) func();
    return this;
  }

  _ChoreJanitor beforeLastTime(func()) {
    if (_choreItem.timesRemaining == 1) func();
    return this;
  }

  _ChoreJanitor onSecondTime(func()) {
    if (_choreItem.timesRemaining == _choreItem._times - 2) func();
    return this;
  }
}

class ChoreItem {
  late Function(int time) _func;
  late String mark;
  late bool done;
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
    return "$className( mark = $mark, timesRemaining=$timesRemaining, executed = $done)";
  }
}

class _ChoreButler {
  SharedPreferences prefs;

  _ChoreButler(this.prefs);

  ChoreItem decreaseTimes(ChoreItem choreItem) {
    if (!choreItem.done) {
      choreItem.timesRemaining -= 1;
      prefs.setInt(choreItem.mark, choreItem.timesRemaining);
    }
    return choreItem;
  }

  bool isDone(ChoreItem choreItem) {
    int? times = timesRemaining(choreItem.mark);
    if (times == null) registerChore(choreItem);
    return timesRemaining(choreItem.mark)! == 0;
  }

  ChoreItem run(ChoreItem choreItem) {
    if (!isDone(choreItem))
      return runCatching(() {
            choreItem._func(choreItem._times - (choreItem.timesRemaining - 1));
          }).onSuccess((value) {
            return decreaseTimes(choreItem);
          }).getOrNull() ??
          choreItem;
    else
      return choreItem;
  }

  List<ChoreItem> getAllChores() {
    return prefs
        .getKeys()
        .where((String key) => key.startsWith("$_base_key"))
        .map(
          (String mark) => ChoreItem._withTimesRemaining(
              timesRemaining: timesRemaining(mark) ?? 1, mark: mark)
            ..mark = mark.split('.').last,
        )
        .toList();
  }

  int? timesRemaining(String mark) {
    return prefs.getInt(mark);
  }

  registerChore(ChoreItem choreItem) {
    prefs.setInt(choreItem.mark, choreItem._times);
  }
}
