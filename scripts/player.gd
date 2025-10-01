
class_name Player extends CharacterBody2D

signal	laser_shot(laser)
signal died

@export var acceleration := 10
@export var max_speed := 350.0
@export var rotation_speed := 250.0

@onready var muzzle: Node2D = $muzzle
@onready var sprite: Sprite2D = $Sprite2D

var laser_scene = preload("res://scenes/laser.tscn")

var shoot_cd = false
var firerate = 0.15
var alive = true

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if !shoot_cd : 
			shoot_cd = true
			shoot_laser()
			await get_tree().create_timer(firerate).timeout
			shoot_cd = false

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(0, Input.get_axis("move_forward", "move_backward"))
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	
	if Input.is_action_pressed("rotate_right"):
		rotate(deg_to_rad(rotation_speed*delta))
	if Input.is_action_pressed("rotate_left"):
		rotate(deg_to_rad(-rotation_speed*delta))
		
	if input_vector.y == 0 :
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	if global_position.y > screen_size.y:
		global_position.y = 0
	if global_position.x < 0:
		global_position.x = screen_size.x
	if global_position.x > screen_size.x:
		global_position.x = 0
	pass

func shoot_laser():
	var l = laser_scene.instantiate()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	emit_signal("laser_shot", l)

func die():
	if alive:
		alive = false
		emit_signal("died")
		sprite.visible = false
		process_mode = Node.PROCESS_MODE_DISABLED

func respawn(pos):
	if !alive:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		process_mode = Node.PROCESS_MODE_INHERIT
