extends MarginContainer
class_name SafeUI


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
		left = rect.position.x
		right = screen.x - rect.end.x
		top = rect.position.y
		bottom = screen.y - rect.end.y

	print("[SafeUI] Left margin is: ", left)
	print("[SafeUI] Right margin is: ", right)
	print("[SafeUI] Top margin is: ", top)
	print("[SafeUI] Bottom margin is: ", bottom)
	add_theme_constant_override("margin_left", left / scaling_factor)
	add_theme_constant_override("margin_right", right / scaling_factor)
	add_theme_constant_override("margin_top", top / scaling_factor)
	add_theme_constant_override("margin_bottom", bottom / scaling_factor)
