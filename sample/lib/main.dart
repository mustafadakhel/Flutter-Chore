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
  String text = "This is not your first time";

  @override
  void initState() {
    Chore.executeOnce("sample", () {
      setState(() {
        text = "This is your first time";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}
