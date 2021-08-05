import 'package:example/all_chores_page.dart';
import 'package:example/five_times_chore_page.dart';
import 'package:example/one_time_chore_page.dart';
import 'package:example/three_times_chore_page.dart';
import 'package:example/two_times_chore_page.dart';
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
