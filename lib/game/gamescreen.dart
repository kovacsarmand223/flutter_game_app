import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game.dart'; // Ensure the path to MainGame is correct

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MainGame(context),
      ),
    );
  }
}
