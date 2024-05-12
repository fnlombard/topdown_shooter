class_name LineController
extends Object

var _line_maps: Dictionary = {}
var _parent: Node2D # Required to draw the lines.

func _init(parent: Node2D) -> void:
    self._parent = parent

func tick() -> void:
    """
    Go through each of the lines and update the edge positions.
    """
    pass

func remove_area(area: Area2D) -> void:
    for line in self._line_maps[area]:
        self._parent.remove_child(line)
    self._line_maps.erase(area)

func add_area(area: Area2D) -> void:
    """
    Process area and calculate lines to the edges.
    """
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

    print("No CollisionShape2D found in the area.")

func _process_rect(rect_area: Area2D, shape: RectangleShape2D) -> void:
    var player_center = PlayerVariables.position_get()
    var player_rotation = PlayerVariables.rotation_get()

    var shape_center = rect_area.global_position
    var extents = shape.extents

    var corners = [
        shape_center + extents.rotated(player_rotation),
        shape_center + Vector2(extents.x, -extents.y).rotated(player_rotation),
        shape_center - extents.rotated(player_rotation),
        shape_center + Vector2( - extents.x, extents.y).rotated(player_rotation)
    ]

    self._line_maps[rect_area] = []
    var lines = self._line_maps[rect_area]

    for corner in corners:
        var line = _create_line(player_center, corner)

        lines.append(line)
        self._parent.add_child(line)

func _create_line(point_a: Vector2, point_b: Vector2) -> Line2D:
    var line = Line2D.new()
    line.default_color = Color(1, 0, 0)
    line.width = 2

    line.add_point(point_a)
    line.add_point(point_b)

    return line