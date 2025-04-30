import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double characterX = 100;
  double characterY = 300;
  double moveSpeed = 5.0;
  double roomSize = 0;

  static const double characterWidth = 50;
  static const double characterHeight = 70;

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
        title: const Text('Game'),
        backgroundColor: const Color(0xFFE18AAA),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          roomSize = min(constraints.maxWidth, constraints.maxHeight * 0.8);
          final roomOffsetX = (constraints.maxWidth - roomSize) / 2;
          final roomOffsetY =
              (constraints.maxHeight - roomSize) / 2 - 30; // move upward

          return Stack(
            children: [
              // Game Area
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

              // Character
              Positioned(
                left: roomOffsetX + characterX,
                top: roomOffsetY + characterY,
                child: Image.asset(
                  'images/i_front.png',
                  width: characterWidth,
                  height: characterHeight,
                ),
              ),

              // D-Pad Controller (now centered at bottom)
              Positioned(
                left: (constraints.maxWidth - 144) / 2, // center horizontally
                bottom: 20,
                child: Column(
                  children: [
                    DPadButton(
                      icon: Icons.arrow_upward,
                      onPressed: () => moveCharacter(0, -moveSpeed),
                    ),
                    Row(
                      children: [
                        DPadButton(
                          icon: Icons.arrow_back,
                          onPressed: () => moveCharacter(-moveSpeed, 0),
                        ),
                        const SizedBox(width: 48),
                        DPadButton(
                          icon: Icons.arrow_forward,
                          onPressed: () => moveCharacter(moveSpeed, 0),
                        ),
                      ],
                    ),
                    DPadButton(
                      icon: Icons.arrow_downward,
                      onPressed: () => moveCharacter(0, moveSpeed),
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

class DPadButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const DPadButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPressed(),
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(1),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
