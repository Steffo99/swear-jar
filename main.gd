extends Node
class_name Main


@onready var tree: SceneTree = get_tree()
@onready var game_safe_ui: MarginContainer = $CustomUI/GameSafeUI
@onready var game_ui: GameUI = $CustomUI/GameSafeUI/GameUI
@onready var shop_safe_ui: MarginContainer = $CustomUI/ShopSafeUI
@onready var shop_ui: ShopUI = $CustomUI/ShopSafeUI/ShopUI


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
				game_safe_ui.show()
				shop_safe_ui.hide()
				shop_safe_ui.process_mode = Node.PROCESS_MODE_DISABLED
			UIState.SHOP:
				tree.paused = true
				game_safe_ui.hide()
				shop_safe_ui.show()
				shop_safe_ui.process_mode = Node.PROCESS_MODE_ALWAYS
			UIState.SCORE:
				pass


func _on_game_ui_score_button_pressed():
	ui_state = UIState.SCORE

func _on_shop_ui_back_button_pressed():
	ui_state = UIState.GAME

func _on_shop_ui_score_button_pressed():
	ui_state = UIState.SCORE

func _on_game_ui_shop_button_pressed():
	ui_state = UIState.SHOP

func _on_shop_ui_purchase_begin(_what):
	ui_state = UIState.GAME

func _on_shop_ui_purchase_cancel(_what):
	ui_state = UIState.GAME
			
func _on_shop_ui_delete_begin():
	ui_state = UIState.GAME

func _on_shop_ui_delete_cancel():
	ui_state = UIState.GAME
