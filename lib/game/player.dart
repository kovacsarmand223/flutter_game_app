import 'package:flame/components.dart';

class Player extends SpriteComponent {
  Vector2 _moveDir = Vector2(0, 0);
  double _speed = 500.0;
  String name = "";
  late Vector2 playerShootVector;
  bool isAlive = true;
  late Vector2 bulletOffset;

  Player({
    super.sprite,
    super.position,
    super.size,
    required this.name,
    Vector2? bulletOffset,
    Vector2? playerShootVector,
  }) : playerShootVector = playerShootVector ?? Vector2(0, -1),
        bulletOffset = bulletOffset ?? Vector2(0, 0); // Use default if null


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
    return position + bulletOffset; // Top-center of the player
  }
}
