import "graphics" for ImageData, Color, Canvas
import "./nokia" for Nokia

import "input" for Keyboard
import "math" for Vec
import "./tilesheet" for Tilesheet
import "./keys" for InputGroup, Actions
import "./entities" for Player, Camera
import "./core/world" for World
import "./core/scene" for Scene
import "./menu" for Menu
import "./events" for CollisionEvent

var CustomSheet = Tilesheet.new("res/camp-tiles.png")
var SmallSheet = Tilesheet.new("res/small.png")
var T = 0
var F = 0

class WorldScene is Scene {
  construct new(args) {
    _player = Player.new()
    _camera = Camera.new(_player)
    _moving = false
    _tried = false
    _ui = []

    _world = World.new()
    _world.addEntity("camera", _camera)
    _world.addEntity("player", _player)
  }

  update() {
    T = T + (1/60)
    F = (T * 2).floor % 2

    if (_ui.count > 0) {
      _ui[0].update()
      if (_ui[0].finished) {
        _ui.removeAt(0)
      }
      return
    }

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


    if (!_camera.moving && !_tried) {
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
      _player.vel = move
    }
    pressed = Actions.directions.any {|key| key.down }

    _world.update()
    _moving = _camera.moving || pressed
    for (event in _world.events) {
      if (event is CollisionEvent) {
        Nokia.synth.playTone(110, 50)
        _tried = true
      }
    }
    if (!pressed) {
      _tried = false
    }
  }

  draw() {
    var X_OFFSET = 4
    if (_invert) {
      Canvas.cls(Nokia.fg)
    } else {
      Canvas.cls(Nokia.bg)
    }
    var cx = (Canvas.width - X_OFFSET - 20) / 2
    var cy = Canvas.height / 2 - 4
    Canvas.offset(cx-_camera.pos.x * 8 -X_OFFSET, cy-_camera.pos.y * 8)
    var x = Canvas.width - 20
    CustomSheet.draw(0, 0, 16, 16, 8*3, 0, _invert)
    CustomSheet.draw(16 + (F * 8), 0, 8, 8, 8 + X_OFFSET, 24, _invert)
    // SmallSheet.draw(4*8, 0, 8, 8, _player.pos.x * 8 + X_OFFSET, _player.pos.y * 8, _invert)


    Canvas.offset()
    if (_moving) {
      // SmallSheet.draw(4*8, 0, 8, 8, cx, cy, _invert)
      CustomSheet.draw(32 + (F * 8), 0, 8, 8, cx, cy, _invert)
    } else {
      CustomSheet.draw(16 + (F * 8), 8, 8, 8, cx, cy, _invert)
    }
    Canvas.rectfill(x, 0, 20, Canvas.height, Nokia.fg)
    Canvas.line(x+1, 0, x+1, Canvas.height, Nokia.bg)

    // Canvas.print("Hello world", 0,0, Nokia.fg)
    for (ui in _ui) {
      ui.draw()
    }

  }

}
