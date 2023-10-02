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
			move_and_check(position + delta)
			previous_position = event.position
		elif event is InputEventScreenDrag:
			var delta = event.position - previous_position
			move_and_check(position + delta)
			previous_position = event.position


@onready var sprite: Sprite2D = $Sprite

@export var can_place: bool:
	get: 
		return can_place
	set(value):
		if value:
			sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			sprite.modulate = Color(1.0, 0.0, 0.0, 0.5)


func move_and_check(destination):
	position = destination
	can_place = not has_overlapping_bodies()
	print(can_place)
