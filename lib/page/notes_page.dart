import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqflite_database_example/db/notes_database.dart';
import 'package:sqflite_database_example/model/note.dart';
import 'package:sqflite_database_example/page/edit_note_page.dart';
import 'package:sqflite_database_example/page/note_detail_page.dart';
import 'package:sqflite_database_example/widget/note_card_widget.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text(
              'Notes',
              style: TextStyle(fontSize: 24),
            ),
            actions: [MySelection(),
            ],
          ),
          body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : notes.isEmpty
                    ? Text(
                        'No Notes',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      )
                    : buildNotes(),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddEditNotePage()),
              );

              refreshNotes();
            },
          ),
        ),
  );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: notes.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];

          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}

class MySelection extends StatelessWidget {
  const MySelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _navigationSelection(context);
      },
      icon: Icon(Icons.account_circle),

    );
  }
}



void _navigationSelection(BuildContext context)
async{
  final result = await Navigator.push(context,
    MaterialPageRoute(
        builder: (context) => SelectionScreen()),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$result')));
}


class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("Developer info"),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Name: Karthik Prasad', style: TextStyle(color: Colors.teal, fontSize: 20),),
            Text('Email: karthikprasadvittla@gmail.com', style: TextStyle(color: Colors.teal, fontSize: 20),),
            Text('Course: B.E.', style: TextStyle(color: Colors.teal, fontSize: 20),),
            Text('Branch: Electronics and communication', style: TextStyle(color: Colors.teal, fontSize: 20),),
            Text('College: Vivekananda college of Engineering and Technology, Puttur', style: TextStyle(color: Colors.teal, fontSize: 20),),
            Text('State: Karnataka', style: TextStyle(color: Colors.teal, fontSize: 20),),
          ],

        ),
      ),
    );
  }
}
