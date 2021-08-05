import 'package:flutter/material.dart';
import 'package:flutter_chore/flutter_chore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Chore.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chore Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Chore Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                navigateTo(1);
              },
              child: Text("One time page"),
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(2);
              },
              child: Text("Two times page"),
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(3);
              },
              child: Text("Three times page"),
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(5);
              },
              child: Text("Five times page"),
            ),
            ElevatedButton(
              onPressed: () {
                navigateTo(0);
              },
              child: Text("All chores"),
            ),
          ],
        ),
      ),
    );
  }

  navigateTo(int i) {
    Widget page = OneTimeChorePage();
    switch (i) {
      case 0:
        {
          page = AllChoresPage();
          break;
        }
      case 1:
        {
          page = OneTimeChorePage();
          break;
        }
      case 2:
        {
          page = TwoTimesChorePage();
          break;
        }
      case 3:
        {
          page = ThreeTimesChorePage();
          break;
        }
      case 5:
        {
          page = FiveTimesChorePage();
          break;
        }
      default:
        {
          page = OneTimeChorePage();
          break;
        }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}

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

class AllChoresPage extends StatefulWidget {
  const AllChoresPage({Key? key}) : super(key: key);

  @override
  _AllChoresPageState createState() => _AllChoresPageState();
}

class _AllChoresPageState extends State<AllChoresPage> {
  int choresCount = 0;
  List<ChoreItem> chores = [];

  @override
  void initState() {
    chores = Chore.getAllChores();
    choresCount = chores.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All chores"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 24),
        shrinkWrap: true,
        primary: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "Chore: ${chores[index].mark}\n"
              "Times Remaining: ${chores[index].timesRemaining}\n"
              "Done: ${chores[index].done}\n",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          );
        },
        itemCount: choresCount,
      ),
    );
  }
}
