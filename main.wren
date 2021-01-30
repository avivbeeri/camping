import "graphics" for Canvas, ImageData, Color
import "dome" for Window
import "nokia" for Nokia
import "entity" for Entity
import "input" for Keyboard
import "./keys" for InputGroup


var MAP = [
  0,0,1,1,1,0,0,
  0,0,1,1,1,0,0,
  0,0,0,0,0,0,0,
  0,1,0,0,0,0,0,
  0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,
  0,0,0,0,0,0,0
]

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
    Window.lockstep = true
    Window.resize(Canvas.width * scale, Canvas.height * scale)
    __player = Entity.new()
    __camera = Entity.new()
  }

  static update() {
    T = T + (1/60)
    F = (T * 2).floor % 2

    var oldPos = __player.pos * 1
    var dir = __player.pos - __camera.pos
    if (dir.length > 0) {
      System.print("%(__camera.pos) %(__player.pos)")
      __camera.pos = __camera.pos + dir.unit / 16
    }
    if (dir.length <= 0) {

      if (LEFT_KEY.firing) {
        __player.pos.x = __player.pos.x - 1
      } else if (RIGHT_KEY.firing) {
        __player.pos.x = __player.pos.x + 1
      } else if (UP_KEY.firing) {
        __player.pos.y = __player.pos.y - 1
      } else if (DOWN_KEY.firing) {
        __player.pos.y = __player.pos.y + 1
      }
      var newPos = __player.pos
      if (!(0 <= newPos.y  && newPos.y < 6 && 0 <= newPos.x && newPos.x < 7))  {
      }
      if (MAP[newPos.y * 7 + newPos.x] == 1 ) {
        __player.pos.x = oldPos.x
        __player.pos.y = oldPos.y
        if (DIR_KEYS.any {|key| key.justPressed }) {
          Nokia.synth.playTone(110, 50)
        }
      }
    }



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
    SmallSheet.draw(4*8, 0, 8, 8, cx, cy, __invert)
    Canvas.rectfill(x, 0, 20, Canvas.height, Nokia.fg)
    Canvas.line(x+1, 0, x+1, Canvas.height, Nokia.bg)

  }


}
