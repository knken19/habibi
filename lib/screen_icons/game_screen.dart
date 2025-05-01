import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double characterX = 50;
  double characterY = 160;
  double moveSpeed = 5.0;
  double roomSize = 0;

  static const double characterWidth = 60;
  static const double characterHeight = 80;

  bool showMessage = false;
  Timer? _messageTimer;

  final List<String> messages = [
    'Hello, Habing ko! ^^',
    'I miss you na :3',
    'I love you so much ^3^',
    'Miss mo na ako?',
    'Mahal na mahal kita <3',
    'I love you palagi <3',
    'I love you most! ^3^',
    'Uwi ka na T_T',
    'Kain tayo?',
    'Bebetime na po :3',
    'Sleep tayo?',
    'Hi, Love!',
  ];

  String currentMessage = '';

  void moveCharacter(double dx, double dy) {
    setState(() {
      characterX = (characterX + dx).clamp(0, roomSize - characterWidth);
      characterY = (characterY + dy).clamp(0, roomSize - characterHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Habibi Room',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE18AAA),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          roomSize = min(constraints.maxWidth, constraints.maxHeight * 0.8);
          final roomOffsetX = (constraints.maxWidth - roomSize) / 2;
          final roomOffsetY = (constraints.maxHeight - roomSize) / 2 - 30;

          return Stack(
            children: [
              if (showMessage)
                Positioned(
                  top: roomOffsetY - 50,
                  left: (constraints.maxWidth - 200) / 2,
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      currentMessage,
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Positioned(
                left: roomOffsetX,
                top: roomOffsetY,
                child: SizedBox(
                  width: roomSize,
                  height: roomSize,
                  child: Image.asset(
                    'images/bg.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                left: roomOffsetX + characterX,
                top: roomOffsetY + characterY,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentMessage = (messages..shuffle()).first;
                      showMessage = true;
                    });

                    _messageTimer?.cancel();

                    _messageTimer = Timer(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {
                          showMessage = false;
                        });
                      }
                    });
                  },
                  child: Image.asset(
                    'images/i_front.png',
                    width: characterWidth,
                    height: characterHeight,
                  ),
                ),
              ),
              Positioned(
                left: (constraints.maxWidth - 144) / 2,
                bottom: 20,
                child: Column(
                  children: [
                    DPadButton(
                      icon: Icons.arrow_upward,
                      onPressed: () => moveCharacter(0, -moveSpeed),
                      onReleased: () {},
                    ),
                    Row(
                      children: [
                        DPadButton(
                          icon: Icons.arrow_back,
                          onPressed: () => moveCharacter(-moveSpeed, 0),
                          onReleased: () {},
                        ),
                        const SizedBox(width: 48),
                        DPadButton(
                          icon: Icons.arrow_forward,
                          onPressed: () => moveCharacter(moveSpeed, 0),
                          onReleased: () {},
                        ),
                      ],
                    ),
                    DPadButton(
                      icon: Icons.arrow_downward,
                      onPressed: () => moveCharacter(0, moveSpeed),
                      onReleased: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DPadButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback onReleased;

  const DPadButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.onReleased,
  });

  @override
  _DPadButtonState createState() => _DPadButtonState();
}

class _DPadButtonState extends State<DPadButton> {
  Timer? _holdTimer;

  void _startHolding() {
    widget.onPressed(); // initial tap
    _holdTimer = Timer.periodic(Duration(milliseconds: 100), (_) {
      widget.onPressed();
    });
  }

  void _stopHolding() {
    _holdTimer?.cancel();
    widget.onReleased();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startHolding(),
      onTapUp: (_) => _stopHolding(),
      onTapCancel: _stopHolding,
      child: Container(
        margin: const EdgeInsets.all(1),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(widget.icon, color: Colors.white, size: 24),
      ),
    );
  }
}
