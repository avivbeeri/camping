var SPEED = 18
import "math" for Vec

class Entity {
  construct new() {
    _pos = Vec.new()
    _vel = Vec.new()
    _priority = 1
  }

  pos { _pos }
  pos=(v) { _pos = v }

  vel { _vel }
  vel=(v) { _vel = v }

  priority=(v) { _priority = v }
  priority { _priority }

  move() {
    _pos = _pos + _vel
  }

  update(ctx) {}
  draw(ctx) {}
}

class Camera is Entity {
  construct new() {
    super()
    // This has to update after the player
    // or we will get inconsistent movement
    priority = 2
  }

  update(ctx) {
    var player = ctx.getEntityByTag("player")
    var dir = player.pos - pos
    if (dir.length > (1/SPEED)) {
      vel = dir.unit / SPEED
    } else {
      vel = Vec.new()
      pos = player.pos * 1
    }
    move()
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
    }
    vel = Vec.new()
  }
}

