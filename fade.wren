import "graphics" for ImageData, Canvas
import "nokia" for Nokia

var t1 = ImageData.create("t1", Canvas.width, Canvas.height)
for (y in 0...Canvas.height) {
  for (x in 0...Canvas.width) {
    if (y % 2 == 1 && x % 2 == 1) {
      t1.pset(x, y, Nokia.fg)
    }
  }
}

var t2 = ImageData.create("t2", Canvas.width, Canvas.height)
for (y in 0...Canvas.height) {
  for (x in 0...Canvas.width) {
    if (y % 2 != x % 2) {
      t2.pset(x, y, Nokia.fg)
    }
  }
}

var t3 = ImageData.create("t3", Canvas.width, Canvas.height)
for (y in 0...Canvas.height) {
  for (x in 0...Canvas.width) {
    if (y % 2 == 1 ||  x % 2 == 1) {
      t3.pset(x, y, Nokia.fg)
    }
  }
}

var FADE_FRAMES = [ t1, t2, t3 ]

