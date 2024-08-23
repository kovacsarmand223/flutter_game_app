import 'package:flame/components.dart';

class Player extends SpriteComponent {
  Vector2 _moveDir = Vector2(0, 0);
  double _speed = 500.0;

  Player({
    super.sprite,
    super.position,
    super.size,
  });

  @override
  void update(double dt) {
    super.update(dt);

    // Move the player based on input direction
    position += _moveDir.normalized() * _speed * dt;
  }

  void setMoveDir(Vector2 moveDir) {
    _moveDir = moveDir;
  }

  // Method to get the bullet spawn position
  Vector2 getBulletSpawnPosition() {
    return position + Vector2(0, -size.y / 2); // Top-center of the player
  }
}
