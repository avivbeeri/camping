import "math" for Vec

class Entity {
  construct new() {
    _pos = Vec.new()
  }

  pos { _pos }
  pos=(v) { _pos = v }

  move(direction) {
    _pos = _pos + direction
  }
}

