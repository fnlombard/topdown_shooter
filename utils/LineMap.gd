class_name LineMap
extends Object

var _map: Dictionary = {}

func _init() -> void: pass

func add(area: Area2D) -> Array:
    assert(area is Area2D)
    self._map[area] = []
    var lines = self._map[area]
    return lines

func get_lines(area: Area2D) -> Array[Line2D]:
    if area in self._map:
        return self._map[area]
    return []

func remove(area: Area2D) -> void:
    assert(self._map.erase(area))
