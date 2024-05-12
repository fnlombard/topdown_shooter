extends Node2D

var line_controller = LineController.new(self)

func _process(_delta):
    _draw_lines()

func _draw_lines():
    line_controller.tick()

func _on_player_area_observe_remove(area: Area2D):
    line_controller.remove_area(area)

func _on_player_area_observe_add(area: Area2D):
    line_controller.add_area(area)
