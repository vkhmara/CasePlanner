import 'package:case_planner/Pages/AddNotePage.dart';
import 'package:case_planner/WorkWithData/TODOList.dart';
import 'package:case_planner/WorkWithData/Note.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Scaffold scaffold;
  String globalNote;
  List<Widget> arr = List();
  TODOList todoList = TODOList();
  Note tempNote;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.pink)),
        backgroundColor: Colors.white,
      ),
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: TODOList.count,
                itemBuilder: (context, pos) =>
                    Container(
                      margin: EdgeInsets.all(8.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF0FF050),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Start: ${Note.dateTimeToString(
                                todoList[pos].start)}"),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("End: ${Note.dateTimeToString(
                                todoList[pos].end)}"),
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "${todoList[pos].deal}",
                                  style: TextStyle(color: Colors.red[500])
                              )
                          ),
                        ],
                      ),
                    ),
              ),
            ),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddNotePage.route).then((note) {
                    if (note != null) {
                      setState(() {
                        TODOList.addNote(note);
                      });
                    }
                  });
                },
                color: Color(0x705f5f5f),
                textColor: Colors.black,
                child: Text('Add note')
            ),
          ]
      ),
    );
  }
}
