import 'package:flutter/material.dart';
import 'package:flutter_chore/flutter_chore.dart';

class TwoTimesChorePage extends StatefulWidget {
  const TwoTimesChorePage({Key? key}) : super(key: key);

  @override
  _TwoTimesChorePageState createState() => _TwoTimesChorePageState();
}

class _TwoTimesChorePageState extends State<TwoTimesChorePage> {
  String text = "";

  @override
  void initState() {
    runTwoTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Two times"),
      ),
      body: Center(child: Text(text)),
    );
  }

  runTwoTimes() {
    Chore.twice("two_times_chore", (int time) {
      setState(() {
        text = "Time $time";
      });
    }).run().beforeLastTime(() {
      setState(() {
        text = "This is your first time";
      });
    }).onSecondTime(() {
      setState(() {
        text = "This is your second time";
      });
    }).ifDone(() {
      setState(() {
        text = "Everything is done";
      });
    });
  }
}
