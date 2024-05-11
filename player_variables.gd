extends Node

var position: set = position_set, get = position_get
var rotation: set = rotation_set, get = rotation_get

func position_set(new_position: Vector2) -> void:
    position = new_position

func position_get() -> Vector2:
    return position

func rotation_set(new_rotation: float) -> void:
    rotation = new_rotation

func rotation_get() -> float:
    return rotation