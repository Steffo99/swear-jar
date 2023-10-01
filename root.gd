extends Node
class_name Root


@onready var tree: SceneTree = get_tree()
@onready var game_ui: GameUI = $UI/GameUI
@onready var shop_ui: ShopUI = $UI/ShopUI


enum UIState {
	GAME,
	SHOP,
	SCORE,
}

@export var ui_state: UIState:
	get:
		return ui_state
	set(value):
		match value:
			UIState.GAME:
				tree.paused = false
				game_ui.show()
				shop_ui.hide()
			UIState.SHOP:
				tree.paused = true
				game_ui.hide()
				shop_ui.show()
			UIState.SCORE:
				pass


func _on_game_ui_score_button_pressed():
	ui_state = UIState.SCORE

func _on_shop_ui_back_button_pressed():
	ui_state = UIState.GAME

func _on_shop_ui_delete_button_pressed():
	ui_state = UIState.GAME

func _on_shop_ui_score_button_pressed():
	ui_state = UIState.SCORE

func _on_game_ui_shop_button_pressed():
	ui_state = UIState.SHOP

func _on_shop_ui_purchase_begin(_what):
	ui_state = UIState.GAME
