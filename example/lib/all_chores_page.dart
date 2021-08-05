import 'package:flutter/material.dart';
import 'package:flutter_chore/flutter_chore.dart';

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
