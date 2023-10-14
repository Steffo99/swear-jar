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

## The position the ghost should have when a new body starts being placed.
@onready var starting_position: Vector2 = position

## The rotation the ghost should have when a new body starts being placed.
@onready var starting_rotation_radians: float = rotation


## Whether this object can currently be placed.
var can_place: bool = false:
	get:
		return can_place
	set(value):
		if value != can_place:
			can_place_changed.emit(value)
		can_place = value
		modulate = valid_color if value else invalid_color

## Emitted when [can_place] changes value.
signal can_place_changed(to: bool)


func _ready():
	# Initialize the Area's collision mask
	collision_mask = overlap_checker.overlap_mask | placeable_area_checker.overlap_mask | overlap_freer.overlap_mask

## Update the value of [can_place].
func update_state():
	# DIRTY HACK: Relies on the placeable area being perfectly surrounded by solid bodies.
	can_place = overlap_checker.is_overlapping_with == null and placeable_area_checker.is_overlapping_with != null

## For retro-compatibility, configure this for the placement of a [PurchasableItem].
func COMPAT_set_to_purchasable_item(pi: PurchasableItem):
	push_warning("COMPAT_set_to_purchasable_item is deprecated.")
	instantiator.scene_to_instantiate = pi.item_scene
	var item_scene = pi.item_scene.instantiate()
	placement_shape.shape = item_scene.get_node("PlacementObstruction/ShieldConverterObstructionShape").shape
	placement_shape.scale = item_scene.scale
	item_scene.queue_free()
	preview_sprite.texture = pi.item_icon
	position = starting_position
	rotation = starting_rotation_radians
	update_state()


## Configure this for the placement of a [ShopItem].
func set_to_shop_item(si: ShopItem):
	instantiator.scene_to_instantiate = si.placement_scene
	placement_shape.shape = si.placement_shape  # TODO: Hmmm. Not the best interface.
	placement_shape.scale = si.placement_scene.scale
	preview_sprite.texture = si.placement_texture
	position = starting_position
	rotation = starting_rotation_radians
	update_state()

## Emitted when [materialize] is called.
signal materialized(what: Node)

## Try to materialize the scene, returning it if the instantiation was successful, or null if it wasn't. 
##
## Remember to try the placement again if this returns null!
func materialize() -> Node:
	if not can_place:
		return null
	overlap_freer.update_is_overlapping_with()
	overlap_freer.area_queue_free()
	var inst = instantiator.instantiate()
	materialized.emit(inst)
	return inst


func _on_moved(_from, _to):
	overlap_checker.update_is_overlapping_with()
	overlap_freer.update_is_overlapping_with()
	placeable_area_checker.update_is_overlapping_with()
	update_state()

func _on_rotated_radians(_from, _to):
	overlap_checker.update_is_overlapping_with()
	overlap_freer.update_is_overlapping_with()
	placeable_area_checker.update_is_overlapping_with()
	update_state()

func _on_area_entered(_area):
	placeable_area_checker.update_is_overlapping_with()
	update_state()

func _on_area_exited(_area):
	placeable_area_checker.update_is_overlapping_with()
	update_state()

func _on_body_entered(_body):
	overlap_checker.update_is_overlapping_with()
	overlap_freer.update_is_overlapping_with()
	update_state()

func _on_body_exited(_body):
	overlap_checker.update_is_overlapping_with()
	overlap_freer.update_is_overlapping_with()
	update_state()
