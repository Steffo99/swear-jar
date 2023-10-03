extends Control
class_name CustomUI


@onready var window: Window = get_window()
@onready var viewport: Viewport = window.get_viewport()

@onready var game_safe_ui: MarginContainer = $GameSafeUI
@onready var shop_safe_ui: MarginContainer = $ShopSafeUI
@onready var score_safe_ui: MarginContainer = $ScoreSafeUI
@onready var game_camera: GameCamera = $GameViewport/Viewport/GameCamera


func _ready():
	viewport.size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()


func _on_viewport_size_changed():
	var window_size: Vector2i = DisplayServer.window_get_size()
	print("[View] Window size is: ", window_size)
	var scaling_factor
	if window_size.x < window_size.y:
		scaling_factor = window_size.x / 270.0
	else:
		scaling_factor = window_size.y / 480.0
	print("[View] Scaling factor is: ", scaling_factor)
	get_window().set_content_scale_factor(scaling_factor)
	game_safe_ui.set_safe_margins(scaling_factor)
	shop_safe_ui.set_safe_margins(scaling_factor)
	score_safe_ui.set_safe_margins(scaling_factor)
	game_camera.set_camera_position(scaling_factor)
