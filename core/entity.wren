import "math" for Vec

class Entity {
  construct new() {
    _pos = Vec.new()
    _vel = Vec.new()

    // Lower is better
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

