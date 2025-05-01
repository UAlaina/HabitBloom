import 'package:flutter/material.dart';
import 'package:habittracker/notes/addnotes_page.dart';
import 'package:habittracker/models/notesDbHelper.dart';

class ListNotesPage extends StatefulWidget {
  @override
  _ListNotesPageState createState() => _ListNotesPageState();
}

class _ListNotesPageState extends State<ListNotesPage> {
  final _dbHelper = NotesDbHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes List'),
      ),
      body: _notes.isEmpty
          ? Center(child: Text('No notes available.'))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          _fetchNotes();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}