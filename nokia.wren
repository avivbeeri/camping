import "graphics" for Canvas, Color
import "input" for Keyboard
import "plugin" for Plugin

Plugin.load("synth")
import "synth" for Synth

var BG = Color.hex("#c7f0d8")
var FG = Color.hex("#43523d")

class Nokia {
  static init(orientation) {
    if (orientation == "horizontal") {
      Canvas.resize(84, 48)
    } else {
      Canvas.resize(48, 84)
    }
    Synth.volume = 0.5
  }

  static synth { Synth }

  static getInput(key) {

    if (!(key is Num)) {
      key = Num.fromString(key)
    }
    if (key is Num) {
      return Keyboard[key.toString]
    }
  }

  static fg { FG }
  static bg { BG }
}

