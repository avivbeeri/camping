import "core/dataobject" for DataObject
import "core/elegant" for Elegant

class Tile is DataObject {
  static new() {
    return Tile.new({})
  }
  construct new(data) {
    super(data)
  }

  toString { "Tile: %(texture), %(data)" }
}

var VOID_TILE = Tile.new({ "solid": true })
var EMPTY_TILE = Tile.new()

class TileMap {
  construct init() {
    _tiles = {}
  }

  clearAll() { _tiles = {} }
  clear(vec) { clear(vec.x, vec.y) }
  clear(x, y) {
    this[x, y] = Tile.new()
  }

  report() {
    for (key in _tiles.keys) {
      System.print(Elegant.unpair(key))
    }
  }

  [vec] {
    return this[vec.x, vec.y]
  }

  [vec]=(tile) {
    this[vec.x, vec.y] = tile
  }

  [x, y] {
    var sectionX = x >> 2
    var sectionY = y >> 2
    var pair = Elegant.pair(sectionX, sectionY)
    var section = _tiles[pair]
    if (section == null) {
      section = _tiles[pair] = (0...16).map {|i| Tile.new() }.toList
    }
    var subX = x & 0x3
    var subY = y & 0x3
    return section[4 * subY + subX]
  }

  [x, y]=(tile) {
    var sectionX = x >> 2
    var sectionY = y >> 2
    var pair = Elegant.pair(sectionX, sectionY)
    var section = _tiles[pair]
    if (!section) {
      section = _tiles[pair] = (0...16).map {|i| Tile.new() }.toList
    }
    var subX = x & 0x3
    var subY = y & 0x3
    section[4 * subY + subX] = tile
  }
}

