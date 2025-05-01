import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

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

  TextStyle _textStyle() => TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Us', style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Color(0xFFE18AAA),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              Color(0xFFE18AAA),
              Color(0xFFF5F5F5),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Time together since',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'September 8, 2022',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Image.asset(
                              'images/habibi.jpg',
                              fit: BoxFit.cover,
                              width: 320,
                              height: 320,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$years Years', style: _textStyle()),
                            Text('$months Months', style: _textStyle()),
                            Text('$days Days', style: _textStyle()),
                            Text('$hours Hours', style: _textStyle()),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/us1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.favorite, color: Color(0xFFE18AAA), size: 30),
                      SizedBox(width: 10),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/us2.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
