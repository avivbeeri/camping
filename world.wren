class World {
  construct new() {
    _entities = []
    _data = {}
  }

  addEntity(entity) {
    _entities.add(entity)
  }

  update() {
    _entities.each {|entity| entity.update(this) }
  }

  draw() {
    _entities.each {|entity| entity.draw(this) }
  }

  [key] { _data[key] }
  [key]=(v) { _data[key] = v }
}
