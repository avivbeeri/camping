import "graphics" for Canvas, ImageData, Color
import "dome" for Window
import "nokia" for Nokia
import "entity" for Entity



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
      "background": invert ? Nokia.fg : Nokia.bg
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
    // Nokia.synth.playTone(440, 250)
  }

  static update() {
    T = T + (1/60)
    F = (T * 1).floor % 2
  }
  static draw(dt) {
    if (Nokia.getInput("1").down) {
      Canvas.cls(Nokia.fg)
    } else {
      Canvas.cls(Nokia.bg)
    }
    var x = Canvas.width - 20
    Canvas.rectfill(x, 0, 20, Canvas.height, Nokia.fg)
    Canvas.line(x+1, 0, x+1, Canvas.height, Nokia.bg)
    CustomSheet.draw(0, 0, 16, 16, 8*3, 0)
    CustomSheet.draw(16 + (F * 8), 0, 8, 8, 8, 24, true)
    SmallSheet.draw(4*8, 0, 8, 8, 0, 0)
  }


}
