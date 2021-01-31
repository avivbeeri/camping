import "graphics" for ImageData, Color, Canvas
import "./nokia" for Nokia

import "input" for Keyboard
import "math" for Vec
import "./tilesheet" for Tilesheet
import "./keys" for InputGroup
import "./entities" for Player, Camera
import "./core/world" for World
import "./core/scene" for Scene

var UP_KEY = InputGroup.new([
  Keyboard["2"], Keyboard["up"], Keyboard["w"]
])
var DOWN_KEY = InputGroup.new([
  Keyboard["8"], Keyboard["down"], Keyboard["s"]
])
var LEFT_KEY = InputGroup.new([
  Keyboard["4"], Keyboard["left"], Keyboard["a"]
])
var RIGHT_KEY = InputGroup.new([
  Keyboard["6"], Keyboard["right"], Keyboard["d"]
])

var DIR_KEYS = [ UP_KEY, DOWN_KEY, LEFT_KEY, RIGHT_KEY ]
// Set frequency for smoother tile movement
DIR_KEYS.each {|key| key.frequency = 1 }

var CustomSheet = Tilesheet.new("res/camp-tiles.png")
var SmallSheet = Tilesheet.new("res/small.png")
var T = 0
var F = 0

class WorldScene is Scene {
  construct new(args) {
    _player = Player.new()
    _camera = Camera.new(_player)
    _moving = false

    _world = World.new()
    _world.addEntity("camera", _camera)
    _world.addEntity("player", _player)
  }

  update() {
    T = T + (1/60)
    F = (T * 2).floor % 2

    var pressed = false

    if (!_camera.moving) {
      var move = Vec.new()
      if (LEFT_KEY.firing) {
        move.x = -1
      } else if (RIGHT_KEY.firing) {
        move.x = 1
      } else if (UP_KEY.firing) {
        move.y = -1
      } else if (DOWN_KEY.firing) {
        move.y = 1
      }
      _player.vel = move
    }
    pressed = DIR_KEYS.any {|key| key.down }

    _world.update()
    _moving = _camera.moving || pressed

    // Nokia.synth.playTone(110, 50)

    _invert = Nokia.getInput("1").down
    if (Nokia.getInput("1").justPressed) {
      Nokia.synth.playTone(440, 50)
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

  }

}
