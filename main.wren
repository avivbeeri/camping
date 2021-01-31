import "graphics" for Canvas, Font
import "dome" for Window
import "./nokia" for Nokia
import "./scene" for WorldScene





class Game {
  static init() {
    var scale = 6
    Nokia.init("horizontal")
    Canvas.font = "classic"
    Window.lockstep = true
    Window.resize(Canvas.width * scale, Canvas.height * scale)
    Font.load("classic", "res/nokia.ttf", 8)

    __scene = WorldScene.new()
  }

  static update() {
    __scene.update()
  }
  static draw(dt) {
    __scene.draw()
  }


}
