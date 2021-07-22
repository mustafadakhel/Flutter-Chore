import 'package:flutter/material.dart';
import 'package:flutter_boot/flutter_boot.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Boot.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boot Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Boot Demo'),
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
    Boot.executeOnce("sample", () {
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
