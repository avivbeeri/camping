import "math" for Vec

class Entity {
  construct new() {
    _pos = Vec.new()
  }

  move(direction) {
    _pos = _pos + direction
  }
}

