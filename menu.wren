import "math" for M
import "graphics" for Canvas
import "./nokia" for Nokia
import "./core/scene" for Ui
import "./keys" for Actions

class Menu is Ui {
  construct new(ctx, actions) {
    super(ctx)
    if (actions.count % 2 != 0) {
      Fiber.abort("Items list must be multiples of 2")
    }
    _done = false
    _actions = actions
    _size = _actions.count / 2
    _cursor = 0
  }

  update() {
    if (Actions.cancel.justPressed) {
      _done = true
      return
    }
    if (Actions.confirm.justPressed) {
      var action = _actions[_cursor * 2 + 1]
      if (action == "cancel") {
        _done = true
      }
    } else if (Actions.up.justPressed) {
      _cursor = _cursor - 1
    } else if (Actions.down.justPressed) {
      _cursor = _cursor + 1
    }
    _cursor = M.mid(0, _cursor, _size - 1)
  }

  draw() {
    Canvas.cls(Nokia.bg)
    var y = 4
    var i = 0
    for (i in 0..._size) {
      if (i == _cursor) {
        Canvas.print(">", 0, y, Nokia.fg)

      }
      Canvas.print(_actions[i * 2], 8, y, Nokia.fg)
      y = y + 8
    }
  }

  finished { _done }
}
