import "./core/event" for Event

class CollisionEvent is Event {

  construct new(target) {
    _target = target
  }

  target { _target }
}
