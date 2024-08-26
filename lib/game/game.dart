import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:test_app/game/bullet.dart';
import 'package:test_app/game/player.dart';
import 'dart:math' as math;

import 'package:test_app/game/strip.dart';

class MainGame extends FlameGame with PanDetector {
  late final BuildContext context;
  late Player player;
  late Player player2;
  late Strip strip;
  late Strip strip2;
  Vector2? _pointerStartPosition;
  late Timer _bulletTimer;  // Timer to shoot bullets
  late SpriteSheet spriteSheet;
  bool _isGameOver = false; // Flag to indicate if the game is over

  MainGame(this.context);

  @override
  Future<void> onLoad() async {
    await images.load('spaceship.png');

    spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('spaceship.png'),
      columns: 8,
      rows: 6,
    );

    // 30 -> offset to not start at the middle with the ship
    final initialPosition = Vector2(size.x / 2, (size.y * 3 / 4) + 30);
    final initialPosition2 = Vector2(size.x / 2, (size.y * 1 / 4) - 30);

    //TODO: HOZZAADNI A SZINES SAVOKAT A HAJOK UTAN

    player = Player(
      sprite: spriteSheet.getSpriteById(6),
      size: Vector2(64, 64),
      position: initialPosition,
      name: "Józsi",
      bulletOffset: Vector2(-10, -45),
      playerShootVector: Vector2(0, -1),
    );

    player.anchor = Anchor.center;
    add(player);

    strip = Strip(
      sprite: spriteSheet.getSpriteById(46),
      size: Vector2(64, 64),
      position: player.position + Vector2(10, 10),
      moveDir:
    );
    strip.anchor = Anchor.center;
    add(strip);

    player2 = Player(
      sprite: spriteSheet.getSpriteById(6),
      size: Vector2(64, 64),
      position: initialPosition2,
      name: "Pityu",
      bulletOffset: Vector2(10, 45),
      playerShootVector: Vector2(0, 1),
    );

    player2.anchor = Anchor.center;
    player2.angle = math.pi;

    add(player2);

    strip2 = Strip(
      sprite: spriteSheet.getSpriteById(47),
      size: Vector2(64, 64),
      position: player2.position + Vector2(-10, -10),
    );
    strip2.anchor = Anchor.center;
    strip2.angle = math.pi;
    add(strip2);

    _bulletTimer = Timer(2.0, repeat: true, onTick: _shootBullet)..start();
  }

  void _shootBullet() {
    // Prevent shooting if game is over
    if (_isGameOver) return;

    final bullet = Bullet(
        sprite: spriteSheet.getSpriteById(29),
        size: Vector2(16, 32),
        position: player.getBulletSpawnPosition(),
        shootVector: player.playerShootVector,
        shooterName: player.name
    );

    add(bullet);

    final bullet2 = Bullet(
        sprite: spriteSheet.getSpriteById(29),
        size: Vector2(16, 32),
        position: player2.getBulletSpawnPosition(),
        shootVector: player2.playerShootVector,
        shooterName: player2.name
    );

    bullet2.angle = math.pi;

    add(bullet2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isGameOver) return; // Skip updates if game is over

    _bulletTimer.update(dt);  // Update the timer

    if (!player2.isAlive) {
      _isGameOver = true;
      showGameOverDialog(player.name);
    }

    if (!player.isAlive) {
      _isGameOver = true;
      showGameOverDialog(player2.name);
    }
  }

  @override
  void onPanDown(DragDownInfo info) {
    // Handle pan down event if needed
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_isGameOver) return; // Skip pan updates if game is over

    final pointerCurrentPosition = info.eventPosition.global;
    var delta = pointerCurrentPosition - _pointerStartPosition!;

    player.position.add(delta);
    player.position.x = player.position.x.clamp(0 + player.size.x / 2, size.x - player.size.x / 2);
    player.position.y = player.position.y.clamp(size.y / 2 + player.size.y / 2, size.y - player.size.y / 2);

    _pointerStartPosition = pointerCurrentPosition;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    if (!_isGameOver) {
      player.setMoveDir(Vector2(0, 0));
    }
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    if (!_isGameOver) {
      player.setMoveDir(Vector2(0, 0));
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final paint = Paint()
      ..color = Color(0xFFFFFFFF) // White color
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.y / 2),
      Offset(size.x, size.y / 2),
      paint,
    );
  }

  void showGameOverDialog(String winnerName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('The winner is $winnerName!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the root (MenuScreen)
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

}

