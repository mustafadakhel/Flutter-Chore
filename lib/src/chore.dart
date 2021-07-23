import 'package:shared_preferences/shared_preferences.dart';

import 'better_try_catch.dart';

const String _base_key = "flutter.chore.";

class Chore {
  static _ChoreButler? _butler;

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
    _butler = _ChoreButler(prefs);
  }

  static _ChoreRunner newChore(
    String mark,
    f(int time), {
    int times = 1,
  }) {
    return _instance._newChore(mark, f, times: times);
  }

  static _ChoreFuncBuilder builder() {
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

  static _ChoreRunner once(String mark, f()) {
    return _instance._once(mark, f);
  }

  static _ChoreRunner twice(String mark, f(int time)) {
    return _instance._twice(mark, f);
  }

  static _ChoreRunner thrice(String mark, f(int time)) {
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
        .twice()
        .mark(mark);
  }

  static List<ChoreItem> getAllChores() {
    return _instance._getAllChores();
  }

  List<ChoreItem> _getAllChores() {
    return _butler?.getAllChores() ?? [];
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
            ..mark = mark,
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
