extends Node
class_name PlaceableAreaChecker


## Layers to consider when checking overlap with [PhysicBody2D].
##
## Ignored during the actual collision check, just used to expand it in the Ghost's initialization phase.
@export_flags_2d_physics var overlap_mask: int


## The [Area2D] this script should act on.
@onready var target: Area2D = get_parent()


## What the [target] object is currently overlapping with.
var is_overlapping_with: PlaceableArea = null


## Get the first [PlaceableArea] overlapping the [target].
func get_first_overlapping_placeable_area() -> PlaceableArea:
	for area in target.get_overlapping_areas():
		if area is PlaceableArea:
			return area
	return null

## Emitted when the value of [is_overlapping_with] changes because of [_update_is_overlapping_with].
signal overlap_changing(to: PlaceableArea)

func update_is_overlapping_with() -> void:
	var current_overlap = get_first_overlapping_placeable_area()
	if current_overlap != is_overlapping_with:
		overlap_changing.emit(current_overlap)
	is_overlapping_with = current_overlap
