extends Node2D

var LineMap = preload ("res://utils/LineMap.gd")

func add_line(line: Line2D) -> void:
    add_child(line)

var line_maps: Array[LineMap] = []

func _process(_delta):
    _draw_lines()

func _draw_lines():
    for line_map in line_maps:
        line_map.update_lines(Vector2(0, 0))

func _on_player_area_observe_remove(area: Area2D):
    line_maps.erase(area)

func _on_player_area_observe_add(area: Area2D):
    line_maps.append(area)
