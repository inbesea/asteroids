extends Node2D

@onready var lasers = $lasers
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("laser_shot", _on_player_laser_shot)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_player_laser_shot(laser):
	lasers.add_child(laser)
