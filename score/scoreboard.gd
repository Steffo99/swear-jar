extends Control

class_name ScoreBoard

@export var score: int = 0

func _ready():
	$Label.text = "Score: " + str(score)

func _process(delta):
	pass

func _on_evaluator_score_changed(total_value):
	$Label.text = "Score: " + str(total_value)
