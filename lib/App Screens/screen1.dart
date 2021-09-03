import 'package:flutter/material.dart';
import 'package:to_do_app/App%20Screens/screen2.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:to_do_app/Database/db.dart';
import 'package:to_do_app/Utils/db_creation.dart';
import 'package:sqflite/sqflite.dart';

class Events extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventsState();
  }
}

class EventsState extends State<Events> {
  int a = 0;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<db> noteList;
  int count = 0;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: To Do App',
      style: optionStyle,
    ),
    Text(
      'Index 1: Home',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<db>();
      updateListView();
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('To Do App'),
        ),
        // body: screen2(),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            debugPrint('Fab clicked');
            navigateToDetail(db('', '', 2), 'Add Event');
          },
          tooltip: 'Add an event',
          child: Icon(Icons.add),
        ),
        bottomNavigationBar:
            BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
            backgroundColor: Colors.green,
          )
        ]));
  }

  ListView todo() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
        itemCount: a,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 4.0,
            child: ListTile(
                leading: Icon(
                  Icons.arrow_right,
                  color: Colors.blueAccent,
                ),
                title: Text(
                  'abc',
                  style: titleStyle,
                ),
                subtitle: Text('def'),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, noteList[position]);
                  },
                ),
                onTap: () {
                  debugPrint('Tile Clicked');
                  navigateToDetail(this.noteList[position], 'Edit Event');
                }),
          );
        });
  }

  void _delete(BuildContext context, db note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(db note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EventDetails(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<db>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
