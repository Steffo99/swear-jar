extends Node
class_name OverlapFreer


## Layers to consider when checking overlap with [PhysicBody2D].
@export_flags_2d_physics var overlap_mask: int

## Whether [TileMap]s should be considered in collisions or not.
##
## Their [collision_layer]s are always ignored.
@export var overlap_with_tilemap: bool = false


## The [Area2D] this script should act on.
@onready var target: Area2D = get_parent()


## Get all bodies overlapping the [target].
func get_all_overlapping_bodies() -> Array[Node2D]:
	var bodies: Array[Node2D] = []
	for body in target.get_overlapping_bodies():
		if body is TileMap:
			if overlap_with_tilemap:
				bodies.append(body)
		elif body is PhysicsBody2D:
			if body.collision_layer & overlap_mask:
				bodies.append(body)
	return bodies

## Emitted when a body is about to be [queue_free]d.
signal body_queueing_free(body: Node2D)

## Queue free all overlapping bodies.
func area_queue_free() -> void:
	for body in get_all_overlapping_bodies():
		body_queueing_free.emit(body)
		body.queue_free()
