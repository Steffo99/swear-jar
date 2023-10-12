extends Node
class_name OverlapChecker


## Layers to consider when checking overlap with [PhysicBody2D].
@export_flags_2d_physics var overlap_mask: int

## Whether [TileMap]s should be considered in collisions or not.
##
## Their [collision_layer]s are always ignored.
@export var overlap_with_tilemap: bool = true


## The [Area2D] this script should act on.
@onready var target: Area2D = get_parent()


## What the [target] object is currently overlapping with.
var is_overlapping_with: Node2D = null


## Get the first body overlapping the [target].
func get_first_overlapping_body() -> Node2D:
	for body in target.get_overlapping_bodies():
		if body is TileMap:
			if overlap_with_tilemap:
				return body
		elif body is PhysicsBody2D:
			if body.collision_layer & overlap_mask:
				return body
	return null

## Update the [is_overlapping_with] variable.
func update_is_overlapping_with() -> void:
	var current_overlap = get_first_overlapping_body()
	if current_overlap != is_overlapping_with:
		overlap_changing.emit(current_overlap)
	is_overlapping_with = current_overlap

## Emitted when the value of [is_overlapping_with] changes because of [_update_is_overlapping_with].
signal overlap_changing(to: Node2D)
