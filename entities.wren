import "math" for Vec
import "./core/entity" for Entity

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
    if (dir.length > (1 / speed)) {
      vel = dir.unit / speed
    } else {
      vel = Vec.new()
      // Copy the player's position
      pos = player.pos * 1
    }
    move()
  }

  // Higher is slower (This is how many steps we aim to take between tiles)
  // Powers of 2 are smoother
  speed  { 24 }

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

