extends Camera2D
class_name GameCamera


func set_camera_position(scaling_factor: float):
	var cutouts: Array[Rect2] = DisplayServer.get_display_cutouts()

	var bottom

	if len(cutouts) == 0:
		bottom = 8
	else:
		var screen: Vector2i = DisplayServer.screen_get_size()
		var rect: Rect2i = DisplayServer.get_display_safe_area()
		bottom = max(8, screen.y - rect.end.y)

	print("[GameCamera] Bottom margin is: ", bottom)

	var size = get_window().size.y / scaling_factor
	position.y = 480 - (size / 2)
