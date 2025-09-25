extends Node2D

@onready var lasers = $lasers
@onready var player = $Player
@onready var asteroids = $asteroids

var score = 0

var asteroid_scene = preload("res://scenes/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = 0
	player.connect("laser_shot", _on_player_laser_shot)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points):
	score += points
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				create_new_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				create_new_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass
	print(score)
	
func create_new_asteroid(pos, size):
	var a = asteroid_scene.instantiate()
	a.global_position = pos
	a.size = size
	a.connect("exploded", _on_asteroid_exploded)
	asteroids.call_deferred("add_child", a)
