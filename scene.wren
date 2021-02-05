import "graphics" for ImageData, Color, Canvas
import "./nokia" for Nokia

import "input" for Keyboard
import "math" for Vec, M
import "./tilesheet" for Tilesheet
import "./keys" for InputGroup, Actions
import "./entities" for Player, Tent, Campfire
import "./core/world" for World
import "./core/scene" for Scene, Ui
import "./core/map" for TileMap, Tile
import "./menu" for Menu
import "./events" for CollisionEvent, MoveEvent, EnterTentEvent

var CustomSheet = Tilesheet.new("res/camp-tiles.png")
var SmallSheet = Tilesheet.new("res/small.png")
var T = 0
var F = 0

var STATIC = false

class TransitionEffect is Ui {
  construct new(ctx) {
    super(ctx)
    _step = 0
  }
  speed { 0.3 }

  update() {
    _step = _step + 1/60
  }

  finished { _step >= speed * 4.5 }

  draw() {
    if (_step < speed) {
      for (y in 0...Canvas.height) {
        for (x in 0...Canvas.width) {
          if (y % 2 == 1 && x % 2 == 1) {
            Canvas.pset(x, y, Nokia.fg)
          }
        }
      }
    } else if (_step < speed * 2) {
      for (y in 0...Canvas.height) {
        for (x in 0...Canvas.width) {
          if (y % 2 != x % 2) {
            Canvas.pset(x, y, Nokia.fg)
          }
        }
      }
    } else if (_step < speed * 3) {
      for (y in 0...Canvas.height) {
        for (x in 0...Canvas.width) {
          if (y % 2 == 1 ||  x % 2 == 1) {
            Canvas.pset(x, y, Nokia.fg)
          }
        }
      }
    } else {
      Canvas.cls(Nokia.fg)
    }
    return true
  }

}
class CameraLerp is Ui {
  construct new(ctx, camera, goal) {
    super(ctx)
    _camera = camera
    _start = camera * 1
    _alpha = 0
    _goal = goal
  }

  finished {
    var dist = (_goal - _camera).length
    return _alpha >= 1 || dist < speed
  }

  speed { 1 / 24 }

  update() {
    _alpha = _alpha + speed

    var cam = _camera
    cam.x = M.lerp(_start.x, _alpha, _goal.x)
    cam.y = M.lerp(_start.y, _alpha, _goal.y)

    if (finished) {
      cam = _goal
    }

    // We need to modify the camera in place
    _camera.x = cam.x
    _camera.y = cam.y
  }
}

class WorldScene is Scene {
  construct new(args) {
    _camera = Vec.new()
    _moving = false
    _tried = false
    _ui = []

    var world = World.new()
    world.addEntity("player", Player.new())

    world.map = TileMap.init()
    world.map[0, 0] = Tile.new({ "floor": "grass" })

    var tent = world.addEntity(Tent.new())
    tent.pos.x = 2
    var fire = world.addEntity(Campfire.new())
    fire.pos.x = 1
    fire.pos.y = 3

    _worlds = []
    _worldIndex = 0

    pushWorld(world)
  }

  pushWorld(world) {
    _worlds.add(world)
    var player = world.getEntityByTag("player")
    _camera.x = player.pos.x
    _camera.y = player.pos.y
    _world = world
    _worldIndex = _worlds.count - 1
    return _worldIndex
  }

  update() {
    _world = _worlds[_worldIndex]
    var player = _world.getEntityByTag("player")

    T = T + (1/60)
    F = (T * 2).floor % 2

    if (_ui.count > 0) {
      _ui[0].update()
      if (_ui[0].finished) {
        _ui.removeAt(0)
      }
      return
    }
    _moving = false

    _invert = Nokia.getInput("1").down
    if (Nokia.getInput("1").justPressed) {
      Nokia.synth.playTone(440, 50)
    }
    var pressed = false


    // Overworld interaction
    if (Actions.interact.justPressed) {
      _ui.add(Menu.new(_world, [
        "Sleep", "relax",
        "Cook", "cook",
        "Cancel", "cancel"
      ]))
      return
    }


    if (!_tried) {
      var move = Vec.new()
      if (Actions.left.firing) {
        move.x = -1
      } else if (Actions.right.firing) {
        move.x = 1
      } else if (Actions.up.firing) {
        move.y = -1
      } else if (Actions.down.firing) {
        move.y = 1
      }
      player.vel = move
    }
    pressed = Actions.directions.any {|key| key.down }

    _world.update()
    for (event in _world.events) {
      if (event is MoveEvent) {
        if (event.target is Player) {
          _moving = true
          _ui.add(CameraLerp.new(_world, _camera, event.target.pos))
        }
      } else if (event is CollisionEvent) {
        Nokia.synth.playTone(110, 50)
        _tried = true
        _moving = false
      } else if (event is EnterTentEvent) {
        System.print("Entering tent...")
        _ui.add(TransitionEffect.new(_world))
        /*
        _ui.add(Menu.new(_world, [
          "Sleep", "relax",
          "Cook", "cook",
          "Cancel", "cancel"
        ]))
        */
      }
    }
    if (!pressed) {
      _tried = false
    }
  }

  draw() {
    var player = _world.getEntityByTag("player")
    var X_OFFSET = 4
    if (_invert) {
      Canvas.cls(Nokia.fg)
    } else {
      Canvas.cls(Nokia.bg)
    }
    var cx = (Canvas.width - X_OFFSET - 20) / 2
    var cy = Canvas.height / 2 - 4
    if (!STATIC) {
      Canvas.offset(cx-_camera.x * 8 -X_OFFSET, cy-_camera.y * 8)
    }
    var x = Canvas.width - 20

    for (dy in -5...5) {
      for (dx in -7...7) {
        var x = player.pos.x + dx
        var y = player.pos.y + dy
        if (_world.map[x, y]["floor"] == "grass") {
          SmallSheet.draw(40, 32, 8, 8, x * 8 + X_OFFSET, y * 8, _invert)
        }
      }
    }

    for (entity in _world.entities) {
      if (STATIC && entity is Player) {
        // We draw this
        if (_moving) {
          // SmallSheet.draw(4*8, 0, 8, 8, cx, cy, _invert)
          CustomSheet.draw(32 + (F * 8), 0, 8, 8, entity.pos.x * 8 + X_OFFSET, entity.pos.y * 8, _invert)
        } else {
          CustomSheet.draw(16 + (F * 8), 8, 8, 8, entity.pos.x * 8 + X_OFFSET, entity.pos.y * 8, _invert)
        }

      } else if (entity is Tent) {
        CustomSheet.draw(0, 0, 16, 16, entity.pos.x * 8 + X_OFFSET * 2, entity.pos.y * 8, _invert)
      } else if (entity is Campfire) {
        CustomSheet.draw(16 + (F * 8), 0, 8, 8, entity.pos.x * 8 + X_OFFSET, entity.pos.y * 8, _invert)
      }
    }
    // Put a background on the player for readability
    if (!STATIC) {
      Canvas.offset()
      Canvas.rectfill(cx, cy, 8, 8, _invert ? Nokia.fg : Nokia.bg)
      // Draw player in screen center
      if (_moving) {
        // SmallSheet.draw(4*8, 0, 8, 8, cx, cy, _invert)
        CustomSheet.draw(32 + (F * 8), 0, 8, 8, cx, cy, _invert)
      } else {
        CustomSheet.draw(16 + (F * 8), 8, 8, 8, cx, cy, _invert)
      }
    }


    for (ui in _ui) {
      var block = ui.draw()
      if (block) {
        break
      }
    }

    // Draw UI overlay
    Canvas.rectfill(x, 0, 20, Canvas.height, Nokia.fg)
    Canvas.line(x+1, 0, x+1, Canvas.height, Nokia.bg)
  }

}
