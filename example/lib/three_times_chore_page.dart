import 'package:flutter/material.dart';
import 'package:flutter_chore/flutter_chore.dart';

class ThreeTimesChorePage extends StatefulWidget {
  const ThreeTimesChorePage({Key? key}) : super(key: key);

  @override
  _ThreeTimesChorePageState createState() => _ThreeTimesChorePageState();
}

class _ThreeTimesChorePageState extends State<ThreeTimesChorePage> {
  String text = "";

  @override
  void initState() {
    runThreeTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Three times"),
      ),
      body: Center(child: Text(text)),
    );
  }

  runThreeTimes() {
    Chore.thrice("three_times_chore", (int time) {
      setState(() {
        text = "Time $time";
      });
    }).run().onSecondTime(() {
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
