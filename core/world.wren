import "core/dataobject" for DataObject

class World is DataObject {
  construct new() {
    super()
    _entities = []
    _events = []
    _tagged = {}
    _map = null
  }

  entities { _entities }
  map { _map }
  map=(v) { _map = v }

  getEntityByTag(tag) { _tagged[tag] }

  addEntity(tag, entity) {
    _tagged[tag] = entity
    return addEntity(entity)
  }

  addEntity(entity) {
    _entities.add(entity)
    _entities.sort {|a, b| a.priority < b.priority}
    return entity
  }

  events { _events }

  update() {
    _events.clear()
    _entities.each {|entity| entity.update(this) }
  }

  draw() {
    _entities.each {|entity| entity.draw(this) }
  }

  getEntitiesAtTile(x, y) {
    return _entities.where {|entity| entity.occupies(x, y) }
  }

  checkCollision(vec) { checkCollision(vec.x, vec.y) }
  checkCollision(x, y) {
    var solid = map[x, y]["solid"]
    var occupies = false
    if (!solid) {
      for (entity in _entities) {
        // Todo: There's no way to check the player
        if (entity["solid"] && entity.occupies(x, y)) {
          occupies = true
          break
        }
      }
    }
    return solid || occupies
  }
}
