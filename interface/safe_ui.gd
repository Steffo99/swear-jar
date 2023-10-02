extends MarginContainer
class_name SafeUI


@export var apply_margin_left: bool
@export var apply_margin_right: bool 
@export var apply_margin_top: bool
@export var apply_margin_bottom: bool


func set_safe_margins(scaling_factor: float):
	var cutouts: Array[Rect2] = DisplayServer.get_display_cutouts()

	var left
	var right
	var top
	var bottom

	if len(cutouts) == 0:
		left = 8
		right = 8
		top = 8
		bottom = 8
	else:
		var screen: Vector2i = DisplayServer.screen_get_size()
		var rect: Rect2i = DisplayServer.get_display_safe_area()
		left = max(8, rect.position.x)
		right = max(8, screen.x - rect.end.x)
		top = max(8, rect.position.y)
		bottom = max(8, screen.y - rect.end.y)

	print("[SafeUI] Left margin is: ", left)
	print("[SafeUI] Right margin is: ", right)
	print("[SafeUI] Top margin is: ", top)
	print("[SafeUI] Bottom margin is: ", bottom)

	if apply_margin_left:
		add_theme_constant_override("margin_left", left / scaling_factor)
	if apply_margin_right:
		add_theme_constant_override("margin_right", right / scaling_factor)
	if apply_margin_top:
		add_theme_constant_override("margin_top", top / scaling_factor)
	if apply_margin_bottom:
		add_theme_constant_override("margin_bottom", bottom / scaling_factor)
