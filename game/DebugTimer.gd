extends Timer
class_name DebugTimer


func _input(event):
	if event.is_action("turbo"):
		start()