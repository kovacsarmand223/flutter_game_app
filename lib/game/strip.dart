import 'package:flame/components.dart';

class Strip extends SpriteComponent {
  Vector2 _moveDir = Vector2(0, 0);
  double _speed = 500.0;
  Strip({
    super.sprite,
    super.position,
    super.size,
    required moveDir,
    required speed,
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
}