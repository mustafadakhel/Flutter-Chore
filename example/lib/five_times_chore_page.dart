import 'package:flutter/material.dart';
import 'package:flutter_chore/flutter_chore.dart';

class FiveTimesChorePage extends StatefulWidget {
  const FiveTimesChorePage({Key? key}) : super(key: key);

  @override
  _FiveTimesChorePageState createState() => _FiveTimesChorePageState();
}

class _FiveTimesChorePageState extends State<FiveTimesChorePage> {
  String text = "";

  @override
  void initState() {
    runFiveTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Five times"),
      ),
      body: Center(child: Text(text)),
    );
  }

  runFiveTimes() {
    Chore.builder()
        .invoke((int time) {
          setState(() {
            text = "Time $time";
          });
        })
        .times(5)
        .mark("five_times_chore")
        .run()
        .onSecondTime(() {
          setState(() {
            text = "This is your second time";
          });
        })
        .beforeLastTime(() {
          setState(() {
            text = "This is your fourth time";
          });
        })
        .ifDone(() {
          setState(() {
            text = "Everything is done";
          });
        });
  }
}
