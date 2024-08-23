import 'package:flame/components.dart';

class Bullet extends SpriteComponent {
  double _speed = 300;

  Bullet({
    super.sprite,
    super.position,
    super.size,
  });

  @override
  void update(double dt) {
    super.update(dt);

    // Move the bullet upwards
    position += Vector2(0, -1) * _speed * dt;

    // Remove the bullet if it goes off-screen
    if (position.y < 0) {
      removeFromParent();
    }
  }
}
