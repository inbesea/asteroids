extends Control

@onready var score = $score:
	set(value):
		score.text = "SCORE:" + str(value)
		
var ulivesScene = preload("res://scenes/ui_life.tscn")
@onready var lives = $lives

func init_lives(amount):
	for ul in lives.get_children():
		ul.queue_free()
	for i in amount:
		var ul = ulivesScene.instantiate()
		lives.add_child(ul)
		print(lives)
