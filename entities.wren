import "math" for Vec
import "./core/entity" for Entity
import "./events" for CollisionEvent

class Camera is Entity {
  construct new(target) {
    super()
    _target = target


    // This has to update after the player
    // or we will get inconsistent movement
    priority = 2
  }

  update(ctx) {
    var dir = _target.pos - pos
    if (dir.length >= (1/speed)) {
      vel = dir.unit / speed
    }
    move()
    if (!moving) {
      vel = Vec.new()
      // Copy the target's position
      pos = _target.pos * 1
    }
  }

  // Higher is slower (This is how many steps we aim to take between tiles)
  // Powers of 2 are smoother
  speed  { 24 }

  moving {
    return (this.pos - _target.pos).length >= (1/speed)
  }

}

class Player is Entity {
  construct new() {
    super()
  }

  update(ctx) {
    var old = pos
    move()
    if (ctx.checkCollision(pos)) {
      pos = old
      ctx.events.add(CollisionEvent.new(this))
    }
    vel = Vec.new()
  }
}

