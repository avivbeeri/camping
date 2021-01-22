import "math" for Vec

class Entity {
  construct new() {
    _pos = Vec.new()
  }

  pos { _pos }

  move(direction) {
    _pos = _pos + direction
  }
}

