import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Screen', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFBE5985),
      ),
    );
  }
}
