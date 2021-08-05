import 'package:flutter/material.dart';
import 'package:flutter_chore/flutter_chore.dart';

class OneTimeChorePage extends StatefulWidget {
  const OneTimeChorePage({Key? key}) : super(key: key);

  @override
  _OneTimeChorePageState createState() => _OneTimeChorePageState();
}

class _OneTimeChorePageState extends State<OneTimeChorePage> {
  String text = "";

  @override
  void initState() {
    runOnce();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("One times"),
      ),
      body: Center(child: Text(text)),
    );
  }

  runOnce() {
    Chore.once("one_time_chore", () {
      setState(() {
        text = "This is your first time";
      });
    }).run().ifDone(() {
      setState(() {
        text = "Everything is done";
      });
    });
  }
}
