import 'package:flutter/material.dart';
import 'dart:async';
import 'note_screen.dart';
import 'heart_screen.dart';
import 'image_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habibing',
            style: TextStyle(color: Colors.black54, fontSize: 24)),
        backgroundColor: Color(0xFFF7879A),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            _buildIconBox(context, Icons.favorite, 'Heart', HeartScreen()),
            _buildIconBox(context, Icons.image, 'Image', ImageScreen()),
            _buildIconBox(context, Icons.edit_note, 'Notepad', NoteScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox(
      BuildContext context, IconData icon, String name, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      ),
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
        padding: const EdgeInsets.all(20),
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
        backgroundColor: Color(0xFFF7879A),
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
