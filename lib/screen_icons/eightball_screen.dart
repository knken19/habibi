import 'package:flutter/material.dart';
import 'dart:math';

class eightBallscreen extends StatefulWidget {
  const eightBallscreen({super.key});

  @override
  State<eightBallscreen> createState() => _eightBallscreenState();
}

class _eightBallscreenState extends State<eightBallscreen>
    with SingleTickerProviderStateMixin {
  int ballNumber = 1;
  final Random random = Random();
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final List<String> answers = [
    "Yes",
    "Yas gurl!",
    "Definitely",
    "Absolutely!",
    "That's\nfor sure",
    "No",
    "That's a\nbig NO",
    "Disagree",
    "There is\nno way",
    "Definitely\nnot",
    "Maybe",
    "Not sure",
    "It depends",
    "Ask again",
    "Uncertain",
    "Ask Ken"
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: Offset(0, 0), end: Offset(15, -15)), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(20, -20), end: Offset(-15, 15)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(-20, 20), end: Offset(10, -10)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(15, -15), end: Offset(-10, 10)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(-15, 15), end: Offset(5, -5)), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(10, -10), end: Offset(-5, 5)), weight: 1),
      TweenSequenceItem(
          tween: Tween(begin: Offset(-10, 10), end: Offset(0, 0)), weight: 1),
    ]).animate(_controller);
  }

  void shakeBall() {
    _controller.forward(from: 0).whenComplete(() {
      setState(() {
        ballNumber = random.nextInt(16);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Game',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Color(0xFFBE5985),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: Text(
              'Ask a question\nand tap the ball!',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 238, 125, 162)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 100),
          Center(
            child: GestureDetector(
              onTap: shakeBall,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _animation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.fromARGB(255, 230, 196, 207),
                        Color.fromARGB(255, 238, 125, 162),
                        Color.fromARGB(255, 221, 93, 136),
                        Color.fromARGB(255, 197, 82, 121)
                      ],
                      center: Alignment(-0.3, -0.3),
                      radius: 1.2,
                    ),
                    color: Color.fromARGB(255, 238, 125, 162),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 25,
                        spreadRadius: 8,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          answers[ballNumber],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
