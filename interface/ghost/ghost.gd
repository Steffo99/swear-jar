extends Area2D
class_name Ghost
## Ghost previewing the instantiation of a scene.


## Color to modulate this with if the body currently isn't overlapping anything.
@export var valid_color: Color = Color.WHITE

## Color to modulate this with if the body currently is overlapping something.
@export var invalid_color: Color = Color.RED


## The [Instantiator] to use to spawn the ghosted item.
@onready var instantiator: Instantiator = $Instantiator

## The [OverlapChecker] to use to see if a solid block is overlapping the ghost.
@onready var overlap_checker: OverlapChecker = $OverlapChecker

## The [PlaceableAreaChecker] to use to see if the ghost is currently inside the placeable area.
@onready var placeable_area_checker: PlaceableAreaChecker = $PlaceableAreaChecker

## The [OverlapFreer] to use to delete the [PhysicsBody2D] behind the ghost before instantiation.
@onready var overlap_freer: OverlapFreer = $OverlapFreer

## The [CollisionShape2D] to use to check for placement checks.
##
## MUST consist of a [RectangleShape2D].
@onready var placement_shape: CollisionShape2D = $PlacementShape

## The [Sprite2D] node previewing the scene.
@onready var preview_sprite: Sprite2D = $PlacementShape/PreviewSprite


var can_place: bool = false


func _ready():
	# Initialize the Area's collision mask
	collision_mask = overlap_checker.collision_mask | placeable_area_checker.collision_mask | overlap_freer.collision_mask


## Update the value of [can_place].
func update_state():
	# DIRTY HACK: Relies on the placeable area being perfectly surrounded by solid bodies.
	can_place = overlap_checker.is_overlapping_with == null and placeable_area_checker.is_overlapping_with != null


func set_to_shop_item(si: ShopItem):
	pass


func materialize():
	# Compatibility stub for Instantiator
	if not can_place:
		return null
	var overlapping_bodies = get_overlapping_bodies()
	for body in overlapping_bodies:
		if body is PhysicsBody2D:
			if body.collision_layer & collision_mask_delete_placement:
				body.queue_free()
	var inst = instantiator.instantiate()
	# TODO: Remove this
	return inst
