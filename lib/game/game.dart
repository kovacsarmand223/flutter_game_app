import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:test_app/game/bullet.dart';
import 'package:test_app/game/player.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

class MainGame extends FlameGame with PanDetector {
  late Player player;
  vmath.Vector2? _pointerStartPosition;
  late Timer _bulletTimer;  // Timer to shoot bullets
  late SpriteSheet spriteSheet;

  @override
  Future<void> onLoad() async {
    await images.load('spaceship.png');

    spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: images.fromCache('spaceship.png'),
      columns: 8,
      rows: 6,
    );

    // Set initial position to be in the lower half of the screen
    final initialPosition = vmath.Vector2(size.x / 2, size.y * 3 / 4);

    player = Player(
      sprite: spriteSheet.getSpriteById(6),
      size: vmath.Vector2(64, 64),
      position: initialPosition,
    );

    player.anchor = Anchor.center;
    add(player);

    // Initialize the bullet shooting timer
    _bulletTimer = Timer(0.5, repeat: true, onTick: _shootBullet)..start();
  }

  void _shootBullet() {
    // Create a bullet at the player's position
    final bullet = Bullet(
      sprite: spriteSheet.getSpriteById(29),
      size: vmath.Vector2(16, 32),
      position: player.getBulletSpawnPosition(),
    );
    add(bullet);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _bulletTimer.update(dt);  // Update the timer
  }

  @override
  void onPanDown(DragDownInfo info) {
    // Handle the pan down event here if needed
  }

  @override
  void onPanStart(DragStartInfo info) {
    _pointerStartPosition = info.eventPosition.global;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final pointerCurrentPosition = info.eventPosition.global;

    // Calculate movement delta
    var delta = pointerCurrentPosition - _pointerStartPosition!;

    // Update player's position
    player.position.add(delta);

    // Keep the player within the lower half of the screen bounds
    player.position.x = player.position.x.clamp(0 + player.size.x / 2, size.x - player.size.x / 2);
    player.position.y = player.position.y.clamp(size.y / 2 + player.size.y / 2, size.y - player.size.y / 2);

    // Update the pointer start position to the current position
    _pointerStartPosition = pointerCurrentPosition;
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _pointerStartPosition = null;
    player.setMoveDir(Vector2(0, 0));
  }

  @override
  void onPanCancel() {
    _pointerStartPosition = null;
    player.setMoveDir(Vector2(0, 0));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw a line at the half of the screen (x-axis)
    final paint = Paint()
      ..color = Color(0xFFFFFFFF) // White color
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, size.y / 2),
      Offset(size.x, size.y / 2),
      paint,
    );
  }
}
