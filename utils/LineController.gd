class_name LineController
extends Object

var _line_maps: Dictionary = {}
var _parent: Node2D # Required to draw the lines.

func _init(parent: Node2D) -> void:
    self._parent = parent

func tick() -> void:
    for area in self._line_maps.keys():
        process_area(area)

func process_area(area: Area2D) -> void:
    for child in area.get_children():
        if not child is CollisionShape2D:
            continue

        var shape = child.shape
        match shape.get_class():
            "RectangleShape2D":
                _process_rect(area, shape)
            "CircleShape2D":
                print("CircleShape2D", shape.radius)
            "CapsuleShape2D":
                print("CapsuleShape2D", shape.radius, shape.height)
            "ConvexPolygonShape2D", "ConcavePolygonShape2D":
                print("ConvexPolygonShape2D, ConcavePolygonShape2D", shape.points)
            _:
                print("Other Shape Type Detected:", child.shape)
        return

func _contains_line(line: Line2D) -> bool:
    for child in self._parent.get_children():
        if line == child:
            return true
    return false

func _remove_line(line: Line2D) -> void:
    self._parent.remove_child(line)

func _add_line(line: Line2D) -> void:
    self._parent.add_child(line)

func remove_area_lines(area: Area2D) -> void:
    for line in self._line_maps[area]:
        _remove_line(line)

    self._line_maps[area] = []

func remove_area(area: Area2D) -> void:
    remove_area_lines(area)
    self._line_maps.erase(area)

func add_area(area: Area2D) -> void:
    self._line_maps[area] = []
    process_area(area)

func _process_rect(rect_area: Area2D, shape: RectangleShape2D) -> void:
    var player_rotation = PlayerVariables.rotation_get()

    var shape_center = rect_area.global_position
    var extents = shape.extents

    var points = [
        shape_center + extents.rotated(player_rotation),
        shape_center + Vector2(extents.x, -extents.y).rotated(player_rotation),
        shape_center - extents.rotated(player_rotation),
        shape_center + Vector2( - extents.x, extents.y).rotated(player_rotation)
    ]

    _update_lines(self._line_maps[rect_area], points)

func _update_lines(lines: Array, points: Array) -> void:
    if not lines:
        _add_lines(lines, points)

    var player_center = PlayerVariables.position_get()
    for index in range(len(lines)):
        lines[index].set_point_position(0, player_center)
        lines[index].set_point_position(1, points[index])

        # I need to use raycasting for the detection.
        for area in self._line_maps.keys():
            if lines[index].intersect_polygons(area.polygon).size() > 0:
                _remove_line(lines[index])
                return

        if not _contains_line(lines[index]):
            _add_line(lines[index])

func _add_lines(lines: Array, points: Array) -> void:
    var player_center = PlayerVariables.position_get()
    for point in points:
        var line = _create_line(player_center, point)

        lines.append(line)
        _add_line(line)

func _create_line(point_a: Vector2, point_b: Vector2) -> Line2D:
    var line = Line2D.new()
    line.default_color = Color(1, 0, 0)
    line.width = 2

    line.add_point(point_a)
    line.add_point(point_b)

    return line