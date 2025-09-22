extends Area2D

var speed := 50

var movement_vector := Vector2(0,-1)

func _ready() -> void:
	rotation = randf_range(0, 2*PI)

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * delta * speed
