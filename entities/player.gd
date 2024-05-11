extends CharacterBody2D

@export var speed = 400
signal area_observe_add(area: Area2D)
signal area_observe_remove(area: Area2D)

func _process(_delta):
    PlayerVariables.position_set(global_position)
    PlayerVariables.rotation_set(rotation)

func get_input():
    var input_direction = Input.get_vector("left", "right", "up", "down")
    velocity = input_direction * speed

func _physics_process(_delta):
    get_input()
    move_and_slide()

func _on_area_2d_area_entered(area: Area2D):
    area_observe_add.emit(area)

func _on_area_2d_area_exited(area: Area2D):
    area_observe_remove.emit(area)
