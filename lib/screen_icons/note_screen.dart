import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> with WidgetsBindingObserver {
  List<Map<String, String>> notes = [];
  List<Map<String, String>> filteredNotes = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveNotes();
    }
  }

  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesData = prefs.getString('notes');

    try {
      final decodedData = jsonDecode(notesData!);

      if (decodedData is List) {
        List<Map<String, String>> loadedNotes = [];
        for (var item in decodedData) {
          if (item is Map) {
            Map<String, String> stringMap = {};
            item.forEach((key, value) {
              stringMap[key] = value.toString();
            });
            loadedNotes.add(stringMap);
          }
        }

        setState(() {
          notes = loadedNotes;
          filteredNotes = List.from(notes);
        });
      } else {
        print("Error: Data in SharedPreferences is not a list.");
      }
    } catch (e) {
      print("Error decoding or loading notes: $e");
    }
  }

  Future<void> _saveNotes() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('notes', json.encode(notes));
      print("Notes saved successfully.");
    } catch (e) {
      print("Error saving notes: $e");
    }
  }

  void _filterNotes(String query) {
    setState(() {
      filteredNotes = notes
          .where((note) =>
              note['title']!.toLowerCase().contains(query.toLowerCase()) ||
              note['content']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _navigateToNoteEditor({Map<String, String>? note, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(note: note),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          notes[index] = result;
        } else {
          notes.add(result);
        }
        filteredNotes = List.from(notes);
        _saveNotes();
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
      filteredNotes = List.from(notes);
      _saveNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black54),
                onChanged: _filterNotes,
              )
            : const Text('My Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFBE5985),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search,
                color: Colors.black54),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchController.clear();
                _filterNotes('');
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.white70,
            child: ListTile(
              title: Text(filteredNotes[index]['title']!),
              subtitle: Text(
                filteredNotes[index]['content']!.split("\n").first,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => _navigateToNoteEditor(
                  note: filteredNotes[index], index: index),
              trailing: IconButton(
                icon: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 238, 125, 162)),
                onPressed: () => _deleteNote(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 238, 125, 162),
        onPressed: () => _navigateToNoteEditor(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class NoteEditorScreen extends StatelessWidget {
  final Map<String, String>? note;
  NoteEditorScreen({super.key, this.note});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = note?['title'] ?? '';
    contentController.text = note?['content'] ?? '';

    return Scaffold(
      appBar: AppBar(
          title: Text(note == null ? 'New Note' : 'Edit Note'),
          backgroundColor: Color.fromARGB(255, 238, 125, 162)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 238, 125, 162), width: 2.0),
                  ),
                ),
                cursorColor: Colors.black),
            const SizedBox(height: 10),
            Expanded(
                child: TextField(
                    controller: contentController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      labelText: 'Content',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 238, 125, 162),
                            width: 2.0),
                      ),
                      alignLabelWithHint: true,
                    ),
                    maxLines: null,
                    cursorColor: Colors.black,
                    expands: true)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 238, 125, 162),
        onPressed: () {
          Navigator.pop(context, {
            'title': titleController.text,
            'content': contentController.text,
            'timestamp': DateTime.now().toString().substring(0, 16),
          });
        },
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}
