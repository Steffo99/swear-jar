extends Control
class_name GameUI

@onready var score_button: ScoreButton = $ScoreButton
@onready var spawn_button: Button = $SpawnButton

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


func _on_shop_ui_purchase_begin(_what: PurchasableItem):
	spawn_button.disabled = true
	spawn_button.text = "Pay"

func _on_shop_ui_purchase_cancel(_what: PurchasableItem):
	spawn_button.disabled = false
	spawn_button.text = "Put"

func _on_shop_ui_purchase_success(_what: PurchasableItem):
	spawn_button.disabled = false
	spawn_button.text = "Put"
