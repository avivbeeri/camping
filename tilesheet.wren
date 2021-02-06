import "graphics" for ImageData, Color
import "./nokia" for Nokia

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

  getTile(sx, sy, invert) {
    return getTile(sx, sy, 8, 8, invert)
  }

  getTile(sx, sy, sw, sh, invert) {
    return _image.transform({
      "srcX": sx, "srcY": sy,
      "srcW": sw, "srcH": sh,
      "mode": "MONO",
      "foreground": invert ? Nokia.bg : Nokia.fg,
      "background": Color.none // invert ? Nokia.fg : Nokia.bg
    })
  }
}


