extends Control
class_name View


@onready var window: Window = get_window()
@onready var viewport: Viewport = window.get_viewport()


func _ready():
	viewport.size_changed.connect(_on_viewport_size_changed)


func _on_viewport_size_changed():
	var window_size: Vector2i = DisplayServer.window_get_size()
	print("[View] Window size is: ", window_size)
	var scaling_factor
	if window_size.x < window_size.y:
		scaling_factor = window_size.x / 270
	else:
		scaling_factor = window_size.y / 480
	print("[View] Scaling factor is: ", scaling_factor)
	get_window().set_content_scale_factor(scaling_factor)
	$SafeUI.set_safe_margins(scaling_factor)
