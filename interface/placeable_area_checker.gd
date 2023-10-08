extends Node
class_name PlaceableAreaChecker


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

func _update_is_overlapping_with() -> void:
	var current_overlap = get_first_overlapping_placeable_area()
	if current_overlap != is_overlapping_with:
		overlap_changing.emit(current_overlap)
	is_overlapping_with = current_overlap

## Calculate overlap on every physics frame.
func _physics_process(_delta):
	_update_is_overlapping_with()
