import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    IconButtonsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Us',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 238, 125, 162),
        onTap: _onItemTapped,
      ),
    );
  }
}

class IconButtonsScreen extends StatelessWidget {
  const IconButtonsScreen({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habibing',
            style: TextStyle(color: Colors.black54, fontSize: 24)),
        backgroundColor: Color.fromRGBO(247, 135, 154, 100),
      ),
      body: Column(
        children: [
          SizedBox(height: 60),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconBox(context, Icons.favorite, 'Heart', HeartScreen()),
                SizedBox(height: 60),
                _buildIconBox(context, Icons.image, 'Image', ImageScreen()),
                SizedBox(height: 60),
                _buildIconBox(
                    context, Icons.edit_note, 'Notepad', NoteScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBox(
      BuildContext context, IconData icon, String name, Widget page) {
    return GestureDetector(
      onTap: () => _navigateTo(context, page),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(5, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(icon, color: Color(0xFFF7879A), size: 100.0),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Timer _timer;
  late int years, months, days, hours;

  @override
  void initState() {
    super.initState();
    _calculateDuration();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _calculateDuration();
      });
    });
  }

  void _calculateDuration() {
    DateTime startDate = DateTime(2022, 9, 8);
    DateTime now = DateTime.now();
    now.difference(startDate);

    years = now.year - startDate.year;
    months = now.month - startDate.month;
    if (months < 0) {
      years -= 1;
      months += 12;
    }
    days = now.day - startDate.day;
    if (days < 0) {
      months -= 1;
      days += DateTime(now.year, now.month, 0).day;
    }
    hours = now.hour;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Us', style: TextStyle(color: Colors.black54, fontSize: 24)),
        backgroundColor: Color.fromRGBO(247, 135, 154, 100),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Time together since\nSeptember 8, 2022',
                  style: TextStyle(
                    color: Color.fromRGBO(230, 63, 90, 1),
                    fontSize: 26,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Container(
                  width: 360,
                  height: 360,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7879A),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        spreadRadius: 4,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('$years Years',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white)),
                      Text('$months Months',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white)),
                      Text('$days Days',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white)),
                      Text('$hours Hours',
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeartScreen extends StatefulWidget {
  const HeartScreen({super.key});

  @override
  _HeartScreenState createState() => _HeartScreenState();
}

class _HeartScreenState extends State<HeartScreen> {
  final List<Widget> _hearts = [];

  void _addHeart() {
    final key = UniqueKey();
    final double startPosition =
        Random().nextDouble() * MediaQuery.of(context).size.width;

    setState(() {
      _hearts.add(HeartAnimation(
        key: key,
        startPosition: startPosition,
        onAnimationEnd: () {
          setState(() {
            _hearts.removeWhere((element) => element.key == key);
          });
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Love',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: const Color.fromRGBO(247, 135, 154, 100),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              width: 350,
              height: 550,
              decoration: BoxDecoration(
                color: Color.fromRGBO(231, 188, 195, 1),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Text('''Hi, Love!
Happy Valentines Day!
                  
        Bilang pagalala kung gaano kita kamahal, ginawa ko 'tong gift na 'to para sa'yo. Sobrang proud ako sa lahat ng naachieve natin nang magkasama. Sobrang proud ako sa'yo at sa lahat ng effort mo to be the best you can be at masaya akong nakikita na masaya ka sa path na nilalakaran mo ngayon.
        Hindi ako magsasawang ulit-ulitin na nandito lang ako palagi para suportahan, tulungan, i-motivate, at mahalin ka sa bawat araw. Masaya akong maging parte ng buhay na binubuo mo para sa sarili mo, at gagawin ko lahat para tulungan ka hanggang sa makakaya ko. Alam kong alam mo naman na basta ikaw, kakayanin ko ang lahat.
        Nagkakaroon man tayo ng hindi pagkakaintindihan at 'di pagkakasundo sa mga bagay-bagay, ikaw pa rin ang pipiliin ko PALAGI. Sobrang pasasalamat ko na natagpuan ulit natin ang isa't isa. Sobrang swerte ko sa'yo bilang partner ko, kaibigan ko, kaharutan, kaaway, at soon—kapag umayon na sa atin ang panahon—magiging asawa ko.
        Salamat sa pagintindi, pag-gabay, pag-saway, at pagmamahal sa akin. Mahal na mahal kita.
        
        
        "Ngayon, ako ay luluhod
         bilang tapat mong tagapagmahal.
         Ang tumanda kasama ka,
         ito ang aking dasal"
         
         
    -Ken
         
         ''',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left),
              ),
            ),
          ),
          ..._hearts,
        ],
      ),
      floatingActionButton: Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.0),
        ),
        child: FloatingActionButton(
          onPressed: _addHeart,
          backgroundColor: Colors.red,
          child: const Icon(Icons.favorite, color: Colors.white, size: 50),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class HeartAnimation extends StatefulWidget {
  final double startPosition;
  final VoidCallback onAnimationEnd;

  const HeartAnimation(
      {super.key, required this.startPosition, required this.onAnimationEnd});

  @override
  _HeartAnimationState createState() => _HeartAnimationState();
}

class _HeartAnimationState extends State<HeartAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _positionAnimation =
        Tween<double>(begin: 50, end: 1000).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);

    _controller.forward().whenComplete(widget.onAnimationEnd);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: _positionAnimation.value,
          left: widget.startPosition,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 60,
            ),
          ),
        );
      },
    );
  }
}

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  List<String> quotes = [
    'Mananatili ang pangako\nSa bukas nang magkasama\nKatabi sa bawat umaga\nKayakap sa gabi ng ligaya',
    'Ikaw ang aking ilaw\nsa wagas na kadiliman',
    'Maging malabo man ang lahat,\nikaw ang aking kalinawan',
    'Ang bukas na masaya\nay ang bukas na kasama ka',
    'Malayo man ay mananatiling\nikaw at ako',
    'Sa bawat pagluha,\nhayaang sa balikat ko ang pagtulo\nKung nais ay pahinga\nLikod ko ang say\'o ay sasalo',
    'Ipagpapanatiling atin\nang bukas na darating',
    'Ikaw ang nag-iisang tiyak\nsa isang libong duda',
    'Maligaw man at mawala\nUmikot man sa kawalan\nDahil sa bawat kailan sino\'t saan\nIkaw lamang ang kasagutan',
    'Ang bawat daan ko\nay patungo pabalik sa\'yo',
    'Walang yaman ang makakatapat\nsa ligayang dulot mo',
    'Ulitin man ang panahon\nIkaw parin ang pipiliin ko',
    'Ikaw ang tanging sigurado\nsa lahat ng pagkabahala',
  ];

  List<String> imagePaths = [
    'images/image1.jpg',
    'images/image2.jpg',
    'images/image3.jpg',
    'images/image4.jpg',
    'images/image5.jpg',
    'images/image6.jpg',
    'images/image7.jpg',
    'images/image8.jpg',
    'images/image9.jpg',
    'images/image10.jpg',
    'images/image11.jpg',
    'images/image12.jpg',
    'images/image13.jpg',
    'images/image14.jpg',
    'images/image15.jpg',
    'images/image16.jpg',
    'images/image17.jpg',
    'images/image18.jpg',
    'images/image19.jpg',
    'images/image20.jpg',
  ];

  String currentQuote = "";
  String currentImage = "";

  @override
  void initState() {
    super.initState();
    _generateRandomContent();
  }

  void _generateRandomContent() {
    final random = Random();
    setState(() {
      currentQuote = quotes[random.nextInt(quotes.length)];
      currentImage = imagePaths[random.nextInt(imagePaths.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Color.fromRGBO(247, 135, 154, 100),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // Wrap the Image.asset in a Container
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.3),
                  BlendMode.saturation,
                ),
                child: Image.asset(
                  currentImage,
                  height: 350,
                  width: 350,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                currentQuote,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NoteScreen extends StatefulWidget {
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
                    borderSide: BorderSide(
                        color: Color.fromRGBO(247, 135, 154, 100), width: 2.0),
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
