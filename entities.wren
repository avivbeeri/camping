import "math" for Vec
import "./core/entity" for Entity
import "./events" for CollisionEvent

class Tent is Entity {
  construct new() {
    super()
    size.x = 3
    size.y = 2
  }
}
class Campfire is Entity {
  construct new() {
    super()
  }
}

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

  checkCollision(ctx, pos) {
    var solid = ctx.map[pos]["solid"]
    var occupying = ctx.getEntitiesAtTile(pos.x, pos.y).where {|entity| !(entity is Player || entity is Camera) }
    return solid || occupying.count > 0
  }

  update(ctx) {
    var old = pos
    move()

    if (checkCollision(ctx, pos)) {
      pos = old
      ctx.events.add(CollisionEvent.new(this))
    }
    vel = Vec.new()
  }
}

