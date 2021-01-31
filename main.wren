import "graphics" for Canvas, ImageData, Color, Font
import "dome" for Window
import "input" for Keyboard
import "math" for Vec
import "./keys" for InputGroup
import "./entities" for Player, Camera
import "./core/world" for World
import "./nokia" for Nokia

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

class Tilesheet {
  construct new(path) {
    _image = ImageData.loadFromFile(path)
  }

  draw(sx, sy, sw, sh, dx, dy) {
    draw(sx, sy, sw, sh, dx, dy, false)
  }

  draw (sx, sy, sw, sh, dx, dy, invert) {
    _image.transform({
      "srcX": sx, "srcY": sy,
      "srcW": sw, "srcH": sw,
      "mode": "MONO",
      "foreground": invert ? Nokia.bg : Nokia.fg,
      "background": Color.none // invert ? Nokia.fg : Nokia.bg
    }).draw(dx, dy)
  }
}

var CustomSheet = Tilesheet.new("res/camp-tiles.png")
var SmallSheet = Tilesheet.new("res/small.png")
var T = 0
var F = 0



class Game {
  static init() {
    var scale = 6
    Nokia.init("horizontal")
    Font.load("classic", "res/nokia.ttf", 8)
    Canvas.font = "classic"
    Window.lockstep = true
    Window.resize(Canvas.width * scale, Canvas.height * scale)
    __player = Player.new()
    __camera = Camera.new()
    __moving = false

    __world = World.new()
    __world.addEntity("camera", __camera)
    __world.addEntity("player", __player)
  }

  static update() {
    T = T + (1/60)
    F = (T * 2).floor % 2

    if (!__moving) {
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
      if (move.length > 0) {
        __player.vel = move
      }
    }

    __world.update()
    __moving = __camera.vel.length > 0
    // Nokia.synth.playTone(110, 50)

    __invert = Nokia.getInput("1").down
    if (Nokia.getInput("1").justPressed) {
      Nokia.synth.playTone(440, 50)
    }
  }
  static draw(dt) {
    var X_OFFSET = 4
    if (__invert) {
      Canvas.cls(Nokia.fg)
    } else {
      Canvas.cls(Nokia.bg)
    }
    var cx = (Canvas.width - X_OFFSET - 20) / 2
    var cy = Canvas.height / 2 - 4
    Canvas.offset(cx-__camera.pos.x * 8 -X_OFFSET, cy-__camera.pos.y * 8)
    var x = Canvas.width - 20
    CustomSheet.draw(0, 0, 16, 16, 8*3, 0, __invert)
    CustomSheet.draw(16 + (F * 8), 0, 8, 8, 8 + X_OFFSET, 24, __invert)
    // SmallSheet.draw(4*8, 0, 8, 8, __player.pos.x * 8 + X_OFFSET, __player.pos.y * 8, __invert)


    Canvas.offset()
    if (__moving) {
      // SmallSheet.draw(4*8, 0, 8, 8, cx, cy, __invert)
      CustomSheet.draw(32 + (F * 8), 0, 8, 8, cx, cy, __invert)
    } else {
      CustomSheet.draw(16 + (F * 8), 8, 8, 8, cx, cy, __invert)
    }
    Canvas.rectfill(x, 0, 20, Canvas.height, Nokia.fg)
    Canvas.line(x+1, 0, x+1, Canvas.height, Nokia.bg)

    // Canvas.print("Hello world", 0,0, Nokia.fg)
  }


}
