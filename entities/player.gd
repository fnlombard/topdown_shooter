extends CharacterBody2D

@export var speed = 400

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * speed

func _physics_process(_delta):
    get_input()
    move_and_slide()

func _on_area_2d_area_shape_entered(_area_rid: RID,
                                    area: Area2D,
                                    _area_shape_index: int,
                                    _local_shape_index: int):
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

func _draw_line(point_a: Vector2, point_b: Vector2) -> void:
    print("Drawing from: ", point_a, " to ", point_b)
    var line = Line2D.new()
    line.default_color = Color(1, 0, 0)
    line.width = 2

    line.add_point(point_a)
    line.add_point(point_b)

    add_child(line)

func _draw_lines_to_rect(center: Vector2, shape: RectangleShape2D) -> void:
    var player_center = global_position
    var extents = shape.extents
    var corners = [
        center + extents.rotated(rotation),
        center + Vector2(extents.x, -extents.y).rotated(rotation),
        center - extents.rotated(rotation),
        center + Vector2( - extents.x, extents.y).rotated(rotation)
    ]

    for corner in corners:
        _draw_line(player_center, corner)

    print("Drawing line to rectangle", shape.extents)