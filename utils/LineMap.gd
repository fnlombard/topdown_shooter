class_name LineMap

extends Object

var area: Area2D
var lines: Array[Line2D] = []
var parent_node

func _init(area: Area2D, parent: Node2D) -> void:
    self.area = area
    self.parent_node = parent

func update_lines(origin: Vector2) -> void: pass

func add_lines(origin: Vector2) -> void:
    for child in area.get_children():
        if not child is CollisionShape2D:
            continue

        var shape = child.shape
        match shape.get_class():
            "RectangleShape2D":
                _draw_lines_to_rect(area.global_position, shape)
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

func _draw_lines_to_rect(center: Vector2, shape: RectangleShape2D) -> void:
    var player_center = PlayerVariables.position_get()
    var player_rotation = PlayerVariables.rotation_get()
    var extents = shape.extents

    var corners = [
        center + extents.rotated(player_rotation),
        center + Vector2(extents.x, -extents.y).rotated(player_rotation),
        center - extents.rotated(player_rotation),
        center + Vector2( - extents.x, extents.y).rotated(player_rotation)
    ]

    for corner in corners:
        var line = _create_line(player_center, corner)
        self.lines.append(line)
        self.parent_node.add_line(line)

func _create_line(point_a: Vector2, point_b: Vector2) -> Line2D:
    var line = Line2D.new()
    line.default_color = Color(1, 0, 0)
    line.width = 2

    line.add_point(point_a)
    line.add_point(point_b)

    return line