extends Node2D

@onready var lasers = $lasers
@onready var player = $Player
@onready var asteroids = $asteroids
@onready var hud = $UI/HUD
@onready var game_over_screen = $UI/GameOverScreen
@onready var player_spawn_pos = $playerRespawnPos
@onready var player_spawn_area = $playerRespawnPos/PlayerSpawnArea

var score = 0:
	set (value):
		score = value
		hud.score = score

var lives = 3:
	set(value):
		lives = value
		hud.init_lives(lives)

var asteroid_scene = preload("res://scenes/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over_screen.visible = false	
	score = 0
	lives = 3
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser):
	$LazerSound.play()
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size, points):
	$AsteroidHitSound.pitch_scale = randf()
	$AsteroidHitSound.play()
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

func _on_player_died():
	$PlayerDieSound.play(0.5)
	lives -= 1
	player.global_position = player_spawn_pos.global_position
	if lives < 1:      
		await get_tree().create_timer(2).timeout
		game_over_screen.visible = true	
	else:
		await get_tree().create_timer(1).timeout
		while !player_spawn_area.isEmpty:
			await  get_tree().create_timer(0.1).timeout
		player.respawn(player_spawn_pos.global_position)
