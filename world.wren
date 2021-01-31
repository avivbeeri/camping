var MAP = [
  0,0,1,1,1,0,0,
  0,0,1,1,1,0,0,
  0,0,0,0,0,0,0,
  0,1,0,0,0,0,0,
  0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,
  0,0,0,0,0,0,0
]

class World {
  construct new() {
    _entities = []
    _events = []
    _data = {}
    _tagged = {}
  }

  getEntityByTag(tag) { _tagged[tag] }

  addEntity(tag, entity) {
    _tagged[tag] = entity
    addEntity(entity)
  }

  addEntity(entity) {
    _entities.add(entity)
    _entities.sort {|a, b| a.priority < b.priority}
  }

  events { _events }

  update() {
    _events.clear()
    _entities.each {|entity| entity.update(this) }
  }

  draw() {
    _entities.each {|entity| entity.draw(this) }
  }

  checkCollision(vec) { checkCollision(vec.x, vec.y) }
  checkCollision(x, y) {
    if ((0 <= y  && y < 6 && 0 <= x && x < 7))  {
      if (MAP[y * 7 + x] == 1 ) {
        return true
      }
    }
    return false
  }

  [key] { _data[key] }
  [key]=(v) { _data[key] = v }
}
