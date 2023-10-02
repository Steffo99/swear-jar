extends Area2D
class_name Ghost

var is_dragging: bool
var previous_position: Vector2

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		is_dragging = event.pressed
		previous_position = event.position
	elif event is InputEventScreenTouch:
		is_dragging = event.pressed
		previous_position = event.position
	
	if is_dragging:
		if event is InputEventMouseMotion:
			var delta = event.position - previous_position
			print(delta)
			position += delta
			previous_position = event.position
		elif event is InputEventScreenDrag:
			var delta = event.position - previous_position
			print(delta)
			position += delta
			previous_position = event.position
