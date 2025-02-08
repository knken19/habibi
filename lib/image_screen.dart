import 'package:flutter/material.dart';

import 'dart:math';

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
        backgroundColor: Color(0xFFF7879A),
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
