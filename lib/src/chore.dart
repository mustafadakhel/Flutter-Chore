import 'package:shared_preferences/shared_preferences.dart';

import 'better_try_catch.dart';

class Chore {
  static _ChoreButler? butler;

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
    butler = _ChoreButler(prefs);
  }

  static _ChoreBuilder invoke(f()) {
    return _instance._invoke(f);
  }

  static _ChoreBuilder invokeOnce(f()) {
    return _instance._invokeOnce(f);
  }

  static _ChoreBuilder invokeTwice(f()) {
    return _instance._invokeTwice(f);
  }

  static _ChoreBuilder invokeThrice(f()) {
    return invokeThrice(f);
  }

  _ChoreBuilder _invoke(f()) {
    return _ChoreBuilder(butler!)._func(f);
  }

  _ChoreBuilder _invokeOnly(f(), int times) {
    return _invoke(f).times(times);
  }

  _ChoreBuilder _invokeOnce(f()) {
    return _invoke(f).once();
  }

  _ChoreBuilder _invokeTwice(f()) {
    return _invoke(f).twice();
  }

  _ChoreBuilder _invokeThrice(f()) {
    return _invoke(f).thrice();
  }

  static List<ChoreItem> getAllChores() {
    return _instance._getAllChores();
  }

  List<ChoreItem> _getAllChores() {
    return butler?.getAllChores() ?? [];
  }
}

class _ChoreBuilder {
  late ChoreItem _choreItem = ChoreItem._empty();
  _ChoreButler butler;

  _ChoreBuilder(this.butler);

  _ChoreBuilder _func(f()) {
    _choreItem._func = f;
    return this;
  }

  _ChoreBuilder times(int times) {
    _choreItem._times = times;
    return this;
  }

  _ChoreBuilder once() {
    _choreItem._times = 1;
    return this;
  }

  _ChoreBuilder twice() {
    _choreItem._times = 2;
    return this;
  }

  _ChoreBuilder thrice() {
    _choreItem._times = 3;
    return this;
  }

  _ChoreRunner mark(String mark) {
    String internalMark = "flutter.chore.$mark";
    _choreItem
      ..mark = internalMark
      ..timesRemaining = butler.timesRemaining(internalMark) ?? _choreItem._times
      ..done = _choreItem.timesRemaining == 0;
    return _ChoreRunner(_choreItem, butler);
  }
}

class _ChoreRunner {
  ChoreItem _choreItem;
  _ChoreButler _butler;

  _ChoreRunner(this._choreItem, this._butler);

  run() {
    _butler.run(_choreItem);
  }
}

class ChoreItem {
  late Function() _func;
  late String mark;
  late bool done;
  int timesRemaining = 1;
  int _times = 1;

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

  decreaseTimes(ChoreItem choreItem) {
    if (choreItem.timesRemaining != 0)
      prefs.setInt(choreItem.mark, choreItem.timesRemaining - 1);
  }

  bool isDone(ChoreItem choreItem) {
    int? times = prefs.getInt(choreItem.mark);
    if (times == null) registerChore(choreItem);
    return timesRemaining(choreItem.mark)! == 0;
  }

  setDone(ChoreItem choreItem) {
    prefs.setInt(choreItem.mark, 0);
    choreItem.done = true;
  }

  run(ChoreItem choreItem) {
    if (!isDone(choreItem))
      runCatching(choreItem._func).onSuccess((value) {
        decreaseTimes(choreItem);
      });
  }

  List<ChoreItem> getAllChores() {
    return prefs
        .getKeys()
        .where((String key) => key.startsWith("flutter.chore."))
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

  ChoreItem getChoreItemWithMark(String mark) {
    int times = timesRemaining(mark) ?? 1;
    ChoreItem item =
        ChoreItem._withTimesRemaining(timesRemaining: times, mark: mark);
    item..done = isDone(item);
    return item;
  }
}
