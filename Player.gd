extends Node2D

var is_dragged: bool = false
var drag_offset: Vector2 = Vector2(0, 0)
var _offset: Vector2 = Vector2(0, 0)

func _process(_delta):
    if not is_dragged:
        return

    var mousepos = get_viewport().get_mouse_position()
    self.position = Vector2(mousepos.x, mousepos.y) + _offset

func _on_area_2d_input_event(_viewport, event, _shape_idx):
    if not event is InputEventMouseButton:
        return

    if not is_dragged and event.pressed:
        _start_dragging(event.position)
    else:
        _stop_dragging()

    is_dragged = event.pressed

func _start_dragging(mouse_position: Vector2) -> void:
    _offset = self.position - mouse_position
    self.scale = Vector2(1, 1)

func _stop_dragging() -> void:
    self.scale = Vector2(1, 1)
