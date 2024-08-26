import 'package:flutter/material.dart';
import 'package:test_app/game/menu.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Multiplayer Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(),  // Set GameScreen as the home widget
    ),
  );
}
