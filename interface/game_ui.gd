extends Control
class_name GameUI

@export var score_button: ScoreButton

## Emitted when the Score button is pressed.
signal score_button_pressed

## Emitted when the Spawn button is pressed.
signal spawn_button_pressed 

## Emitted when the Shop button is presesd.
signal shop_button_pressed


func _on_score_button_pressed():
	score_button_pressed.emit()

func _on_spawn_button_pressed():
	spawn_button_pressed.emit()

func _on_shop_button_pressed():
	shop_button_pressed.emit()

func _on_game_score_changed(total: int):
	score_button.set_score(total)
