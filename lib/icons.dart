import 'package:flutter/material.dart';
import 'dart:math';
import 'screen_icons/calendar_screen.dart';
import 'screen_icons/note_screen.dart';
import 'screen_icons/heart_screen.dart';
import 'screen_icons/eightball_screen.dart';
import 'screen_icons/game_screen.dart';

class IconButtonsScreen extends StatelessWidget {
  const IconButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habibing',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Roboto')),
        backgroundColor: Color(0xFFBE5985),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 25.0, right: 10.0),
            child: Text(
              'For You',
              style: TextStyle(
                fontSize: 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.black54,
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 15),
                  _buildIconBox(
                      context, Icons.favorite, 'Heart', HeartScreen()),
                  _buildIconBox(
                      context, Icons.edit_note, 'Notepad', NoteScreen()),
                  _buildIconBox(context, Icons.calendar_month, 'Calendar',
                      CalendarScreen()),
                  _buildIconBox(
                      context, Icons.mood, 'eightBall', eightBallscreen()),
                  _buildIconBox(
                      context, Icons.gamepad_rounded, 'gamePad', GameScreen()),
                  SizedBox(width: 15),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200,
                child: Divider(
                  color: Colors.black26,
                  thickness: 1,
                ),
              ),
            ),
          ),
          Expanded(child: Center(child: ImageScreen())),
        ],
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
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Color(0xffEC7FA9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(4, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Icon(icon, color: Colors.white, size: 60.0),
      ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                currentImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
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
    );
  }
}
