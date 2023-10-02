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
		if value:
			preview_sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
		else:
			preview_sprite.modulate = Color(1.0, 0.0, 0.0, 0.5)

## The last input event of the input that's dragging the ghost around, or null if the ghost isn't being dragged.
var last_input_event: InputEvent


func _ready():
	collision_mask = collision_mask_prevent_placement | collision_mask_delete_placement
	preview_sprite.texture = preview_texture


func _input(event: InputEvent):
	# Handle mouse click
	if event is InputEventMouseButton:
		last_input_event = event if event.pressed else null
	# Handle touch begin
	elif event is InputEventScreenTouch:
		last_input_event = event if event.pressed else null
	
	# If is dragging
	if last_input_event:
		# Handle mouse drag
		if last_input_event is InputEventMouse and event is InputEventMouse:
			var delta = event.position - last_input_event.position
			position += delta
			last_input_event = event
		# Handle touch drag
		elif (last_input_event is InputEventScreenTouch or last_input_event is InputEventScreenDrag) and event is InputEventScreenDrag:
			if event.index == last_input_event.index:
				var delta = event.position - last_input_event.position
				position += delta
				last_input_event = event

# DIRTY HACK: Relies on the placeable area being perfectly surrounded by solid bodies.
func _physics_process(_delta: float):
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
	var instantiated = scene_to_instantiate.instantiate()
	instantiated.global_position = global_position
	instantiated.rotation = rotation
	target.add_child(instantiated)
	materialized.emit(instantiated)
	return instantiated
