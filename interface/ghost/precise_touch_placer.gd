extends Node
class_name PreciseTouchPlacer


## The degrees to rotate by when rotation is quantized.
@export_range(1, 180, 1) var rotation_quantized_degrees: float = 45

## The degrees to rotate by when rotation is quantized and precise rotation is being requested.
@export_range(1, 180, 1) var rotation_quantized_precise_degrees: float = 5


## The [Node2D] this script should act on.
@onready var target: Node2D = get_parent()


## Whether the target is currently being dragged or not.
var is_dragging: bool = false

## The last [InputEventMouse] received.
var last_mouse_event: InputEventMouse = null

## The last [InputEventScreenTouch] or [InputEventScreenDrag] received for each possible touch index.
var last_touch_events: Array[InputEvent] = [
	null, null, null, null, null, 
	null, null, null, null, null,
]


## Count the number of non-[null] [last_touch_events].
func count_active_touch_events() -> int:
	var total = 0
	for event in last_touch_events:
		if event != null:
			total += 1
	return total

## Handle event-based input
func _input(event: InputEvent):
	# Count active events
	var count = count_active_touch_events()
	
	# Mouse drag
	if count == 0:
		# Mouse drag
		if event is InputEventMouseMotion and last_mouse_event:
			target.position += event.relative
	# Touch drag
	elif count == 1:
		# Touch drag
		if event is InputEventScreenDrag:
			target.position += event.relative
	# Handle rotation
	elif count == 2:
		# Find the previous event
		var previous
		if event is InputEventScreenTouch or event is InputEventScreenDrag:
			previous = last_touch_events[event.index]
		# At this point previous shouldn't be null
		# If it is, just try again at the next frame
		if previous == null:
			return
		# Find the other event
		var other
		for last_touch_index in len(last_touch_events):
			if event is InputEventScreenTouch or event is InputEventScreenDrag:
				if event.index == last_touch_index:
					continue
			if last_touch_events[last_touch_index] != null:
				other = last_touch_events[last_touch_index]
		# At this point other shouldn't be null
		# If it is, just try again at the next frame
		if other == null:
			return
		# Find the two vectors between the touches, one using the previous position, and one using the current one
		var previous_vec: Vector2 = previous.position - other.position
		var current_vec: Vector2 = event.position - other.position
		# Find the angle between the two vectors
		var rotation_radians = previous_vec.angle_to(current_vec)
		# Apply the rotation
		target.rotation += rotation_radians	

	# Store last events
	if event is InputEventMouseButton:
		last_mouse_event = event if event.pressed else null
	elif event is InputEventMouseMotion and last_mouse_event != null:
		last_mouse_event = event
	elif event is InputEventScreenTouch:
		last_touch_events[event.index] = event if event.pressed else null
	elif event is InputEventScreenDrag:
		last_touch_events[event.index] = event

## Get the degrees that the target should be rotated by in a given frame when rotation is quantized.
func get_rotation_quantized_degrees() -> float:
	var degrees = rotation_quantized_precise_degrees if Input.is_action_pressed("ghost_precise") else rotation_quantized_degrees
	var intensity = 1.0 if Input.is_action_just_pressed("ghost_clockwise") else 0.0 - 1.0 if Input.is_action_just_pressed("ghost_counterclockwise") else 0.0
	return degrees * intensity

## Handle polling-based input
func _physics_process(_delta):
	# Handle quantized rotation
	target.rotation_degrees += get_rotation_quantized_degrees()
