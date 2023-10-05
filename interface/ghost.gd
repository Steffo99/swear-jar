extends Area2D
class_name Ghost

## Ghost previewing the instantiation of a scene.

## The [CollisionShape2D] to use to check for placement checks.
##
## MUST consist of a [RectangleShape2D].
@onready var placement_shape: CollisionShape2D = $PlacementShape

## The [Sprite2D] node previewing the scene.
@onready var preview_sprite: Sprite2D = $PlacementShape/PreviewSprite

## The collision mask of objects that should prevent this object's placement.
@export_flags_2d_physics var collision_mask_prevent_placement: int

## The collision mask of objects that should be deleted on this object's placement.
@export_flags_2d_physics var collision_mask_delete_placement: int

## The texture that the preview sprite should display. 
@export var preview_texture: Texture2D:
	get:
		return preview_texture
	set(value):
		preview_texture = value
		# Quick priority fix
		if preview_sprite:
			preview_sprite.texture = value

## Whether the ghost can be placed at the current location of the ghost.
##
## Computed by checking if [placement_shape] overlaps any entity and is inside the [PlacementArea] of the [Bottle].
var can_place: bool:
	get: 
		return can_place
	set(value):
		can_place = value
		if value:
			preview_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			preview_sprite.modulate = Color(1.0, 0.0, 0.0, 0.5)


## Whether the ghost is currently being dragged or not.
var is_being_dragged: bool


func _ready():
	collision_mask = collision_mask_prevent_placement | collision_mask_delete_placement
	preview_sprite.texture = preview_texture


## The degrees to rotate by when rotation is quantized.
@export_range(1, 180, 1) var rotation_quantized_degrees: float = 45

## The degrees to rotate by when rotation is quantized and precise rotation is being requested.
@export_range(1, 180, 1) var rotation_quantized_precise_degrees: float = 5


## Get the degrees a piece should be rotated by when rotation is quantized.
func get_rotation_quantized_degrees() -> float:
	var degrees = rotation_quantized_precise_degrees if Input.is_action_pressed("ghost_precise") else rotation_quantized_degrees
	var intensity = 1.0 if Input.is_action_just_pressed("ghost_clockwise") else 0.0 - 1.0 if Input.is_action_just_pressed("ghost_counterclockwise") else 0.0
	return degrees * intensity

## The last [InputEventMouse] received.
var last_mouse_event: InputEventMouse = null

## The last [InputEventScreenTouch] or [InputEventScreenDrag] received for each possible touch index.
var last_touch_events: Array[InputEvent] = [
	null, null, null, null, null, 
	null, null, null, null, null,
]

func count_active_touch_events() -> int:
	var total = 0
	for event in last_touch_events:
		if event != null:
			total += 1
	return total

func _input(event: InputEvent):
	# Count active events
	var count = count_active_touch_events()
	#print("[Ghost] Counting ", count, " active events!")
	
	# Mouse drag
	if count == 0:
		# Mouse drag
		if event is InputEventMouseMotion and last_mouse_event:
			position += event.relative
	# Touch drag
	elif count == 1:
		# Touch drag
		if event is InputEventScreenDrag:
			position += event.relative
	# Handle rotation
	elif count == 2:
		# Find the previous event
		var previous
		if event is InputEventScreenTouch or event is InputEventScreenDrag:
			previous = last_touch_events[event.index]
		# At this point previous shouldn't be null
		# If it is, just try again at the next frame
		if previous == null:
			print("[Ghost] Rotation occurred, but previous was null, so it was cancelled.")
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
			print("[Ghost] Rotation occurred, but other was null, so it was cancelled.")
			return
		# Find the two vectors between the touches, one using the previous position, and one using the current one
		var previous_vec: Vector2 = previous.position - other.position
		var current_vec: Vector2 = event.position - other.position
		print("[Ghost] previous_vec: ", previous_vec, " | current_vec: ", current_vec)
		# Find the angle between the two vectors
		var rotation_radians = previous_vec.angle_to(current_vec)
		print("[Ghost] Rotation was successful, rotating by: ", rotation_radians)
		# Apply the rotation
		rotation += rotation_radians	

	# Store last events
	if event is InputEventMouseButton:
		last_mouse_event = event if event.pressed else null
		#print("[Ghost] last_mouse_event updated in response to a InputEventMouseButton: ", last_mouse_event)
	elif event is InputEventMouseMotion and last_mouse_event != null:
		last_mouse_event = event
		#print("[Ghost] last_mouse_event updated in response to a InputEventMouseMotion: ", last_mouse_event)
	elif event is InputEventScreenTouch:
		last_touch_events[event.index] = event if event.pressed else null
		#print("[Ghost] last_touch_events[", event.index , "] updated in response to a InputEventScreenTouch: ", last_mouse_event)
	elif event is InputEventScreenDrag:
		last_touch_events[event.index] = event
		#print("[Ghost] last_touch_events[", event.index , "] updated in response to a InputEventScreenDrag: ", last_mouse_event)


func _physics_process(_delta: float):
	# Handle quantized rotation
	rotation_degrees += get_rotation_quantized_degrees()


## Update the value of [can_place].
# DIRTY HACK: Relies on the placeable area being perfectly surrounded by solid bodies.
func update_can_place():
	var no_overlapping_bodies: bool = true
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is TileMap:
			no_overlapping_bodies = false
		elif body is PhysicsBody2D:
			var body_prevents_placement = bool(body.collision_layer & collision_mask_prevent_placement)
			no_overlapping_bodies = no_overlapping_bodies and not body_prevents_placement

	var is_in_placeable_area: bool = false
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area is PlaceableArea:
			is_in_placeable_area = true
	
	can_place = no_overlapping_bodies and is_in_placeable_area


## The [PackedScene] that this node should instantiate.
@export var scene_to_instantiate: PackedScene

## The [Node] instatiated scenes should be added as children to.
@export var target: Node

## Emitted when the [materialize] function has finished executing.
signal materialized(node: Node)

func materialize():
	if not can_place:
		return null
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is PhysicsBody2D:
			if body.collision_layer & collision_mask_delete_placement:
				body.queue_free()
	var instantiated = scene_to_instantiate.instantiate()
	instantiated.global_position = global_position
	instantiated.rotation = rotation
	target.add_child(instantiated)
	materialized.emit(instantiated)
	return instantiated
