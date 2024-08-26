import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:test_app/game/player.dart';
import 'dart:core'; // Ensure this import is there for ListExtensions

// Extension to add firstWhereOrNull functionality
extension IterableExtensions<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}

class Bullet extends SpriteComponent {
  double _speed = 200;
  Vector2 shootVector;
  String shooterName = "";

  Bullet({
    super.sprite,
    super.position,
    super.size,
    required this.shootVector,
    required this.shooterName,
  });

  @override
  void update(double dt) {
    super.update(dt);

    // Move the bullet upwards
    position += shootVector * _speed * dt;

    // Remove the bullet if it goes off-screen
    if (position.y < 0) {
      removeFromParent();
      return;
    }

    // Check for collision with player2
    final game = parent as FlameGame;

    // Safely access player2, allowing for a null return type
    final Player? player2 = game.children.whereType<Player>().firstWhereOrNull(
          (player) => player.name != shooterName && player.toRect().overlaps(toRect()),
    );

    // If player2 exists and collides with the bullet, remove both
    if (player2 != null) {
      player2.removeFromParent();
      player2.isAlive = false;
      removeFromParent();
    }
  }
}
