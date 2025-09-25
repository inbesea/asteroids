extends Control

@onready var score = $score:
	set(value):
		score.text = "SCORE:" + str(value)
		
