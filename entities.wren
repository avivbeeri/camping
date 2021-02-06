import "math" for Vec
import "./core/entity" for Entity
import "./events" for CollisionEvent, MoveEvent, EnterTentEvent, ExitTentEvent

class Tent is Entity {
  construct new() {
    super()
    size.x = 3
    size.y = 2
    _offset = Vec.new(1,1)
  }

  offset { _offset }

  notify(ctx, event) {
    if (event is CollisionEvent) {
      if (event.target == this) {
        if (event.pos == pos + offset) {
          event.cancel()
          return EnterTentEvent.new()
        }
      }
    }
    return event
  }
}

class Campfire is Entity {
  construct new() {
    super()
  }
}

class Player is Entity {
  construct new() {
    super()
  }

  handleCollision(ctx, pos) {
    var solid = ctx.map[pos]["solid"]
    var occupying = ctx.getEntitiesAtTile(pos.x, pos.y).where {|entity| !(entity is Player) }
    var solidEntity = false
    for (entity in occupying) {
      var event = entity.notify(ctx, CollisionEvent.new(this, entity, pos))
      if (!event.cancelled) {
        ctx.events.add(event)
        solidEntity = true
      }
    }
    return solid || solidEntity
  }

  update(ctx) {
    var old = pos * 1
    move()

    if (pos != old && handleCollision(ctx, pos)) {
      pos = old
    }

    if (pos != old) {
      ctx.events.add(MoveEvent.new(this))
      if (ctx.map[pos]["exit"]) {
        ctx.events.add(ExitTentEvent.new())
      }
    }
    if (vel.length > 0) {
      vel = Vec.new()
    }
  }
}

