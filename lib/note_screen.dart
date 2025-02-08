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

    if (notesData != null) {
      try {
        final decodedData = jsonDecode(notesData);

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

  Future<void> _addNote() async {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFF7879A), width: 2.0),
                  ),
                ),
                cursorColor: Colors.black,
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: ('Content'),
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFFF7879A), width: 2.0),
                  ),
                ),
                maxLines: 5,
                cursorColor: Colors.black,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'title': titleController.text,
                'content': contentController.text,
                'timestamp': DateTime.now().toString().substring(0, 16),
              });
            },
            child: Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        notes.add(result);
        filteredNotes = List.from(notes);
        _saveNotes();
      });
    }
  }

  Future<void> _editNote(int index) async {
    TextEditingController titleController =
        TextEditingController(text: filteredNotes[index]['title']);
    TextEditingController contentController =
        TextEditingController(text: filteredNotes[index]['content']);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(247, 135, 154, 100), width: 2.0),
                  ),
                ),
                cursorColor: Colors.black,
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromRGBO(247, 135, 154, 100), width: 2.0),
                  ),
                ),
                maxLines: 5,
                cursorColor: Colors.black,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'title': titleController.text,
                'content': contentController.text,
                'timestamp': DateTime.now().toString().substring(0, 16),
              });
            },
            child: Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        // Find the original note in the 'notes' list and update it
        for (int i = 0; i < notes.length; i++) {
          if (notes[i]['title'] == filteredNotes[index]['title'] &&
              notes[i]['content'] == filteredNotes[index]['content']) {
            notes[i] = result;
            break;
          }
        }
        filteredNotes =
            List.from(notes); // Update filtered list *after* editing
        _saveNotes(); // Save *after* the state update
      });
    }
  }

  Future<void> _deleteNote(int index) async {
    setState(() {
      for (int i = 0; i < notes.length; i++) {
        if (notes[i]['title'] == filteredNotes[index]['title'] &&
            notes[i]['content'] == filteredNotes[index]['content']) {
          notes.removeAt(i);
          break;
        }
      }
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
                  // Added const
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black54), // Added const
                onChanged: _filterNotes,
              )
            : const Text('Simple Notes',
                style: TextStyle(color: Colors.black54)), // Added const
        backgroundColor:
            const Color.fromRGBO(247, 135, 154, 100), // Added const
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
            margin: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10), // Added const
            color: Colors.white70,
            child: ListTile(
              title: Text(filteredNotes[index]['title']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(filteredNotes[index]['content']!),
                  const SizedBox(height: 10), // Added const
                  Text('Last edit: ${filteredNotes[index]['timestamp']}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)), // Added const
                ],
              ),
              onTap: () => _editNote(index),
              trailing: IconButton(
                icon: const Icon(Icons.delete, // Added const
                    color: Color.fromRGBO(247, 135, 154, 100)),
                onPressed: () => _deleteNote(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Theme(
        // Wrapped in a Theme widget
        data: ThemeData(
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color.fromRGBO(
                247, 135, 154, 100), // const and explicit color
          ),
        ),
        child: FloatingActionButton(
          onPressed: _addNote,
          child: const Icon(Icons.add, color: Colors.white), // Added const
        ),
      ),
    );
  }
}
