import 'package:flutter/material.dart';

void main() {
  runApp(NotePadApp());
}

class NotePadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotePad',
      home: NotePadPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Note {
  String content;

  Note({required this.content});
}

class NotePadPage extends StatefulWidget {
  @override
  _NotePadPageState createState() => _NotePadPageState();
}

class _NotePadPageState extends State<NotePadPage> {
  List<Note> notes = [];
  final TextEditingController controller = TextEditingController();
  int? editingIndex;

  void saveNote() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (editingIndex != null) {
        notes[editingIndex!] = Note(content: text);
        editingIndex = null;
      } else {
        notes.add(Note(content: text));
      }
      controller.clear();
    });
  }

  void editNote(int index) {
    setState(() {
      controller.text = notes[index].content;
      editingIndex = index;
    });
  }

  void deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      if (editingIndex == index) {
        controller.clear();
        editingIndex = null;
      }
    });
  }

  void cancelEditing() {
    setState(() {
      controller.clear();
      editingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NotePad'),
        actions: [
          if (editingIndex != null)
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: cancelEditing,
              tooltip: 'Cancel Editing',
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Note Input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: editingIndex == null ? 'New Note' : 'Edit Note',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveNote,
              child: Text(editingIndex == null ? 'Add Note' : 'Update Note'),
            ),
            SizedBox(height: 20),

            // Notes List
            Expanded(
              child: notes.isEmpty
                  ? Center(child: Text('No notes yet.'))
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card(
                          child: ListTile(
                            title: Text(note.content),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => editNote(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => deleteNote(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
