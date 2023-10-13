extends Node
class_name OverlapFreer


## Layers to consider when checking overlap with [PhysicBody2D].
@export_flags_2d_physics var overlap_mask: int

## Whether [TileMap]s should be considered in collisions or not.
##
## Their [collision_layer]s are always ignored.
@export var overlap_with_tilemap: bool = false


## Color to restore modulation on objects that wouldn't be deleted anymore.
@export var valid_color: Color = Color.WHITE

## Color to modulate objects that would be deleted if [area_queue_free] was called right now.
@export var invalid_color: Color = Color.MAROON


var is_overlapping_with: Array[Node2D] = []:
	get:
		return is_overlapping_with
	set(value):
		for body in is_overlapping_with:
			body.modulate = valid_color
		for body in value:
			body.modulate = invalid_color
		is_overlapping_with = value


## The [Area2D] this script should act on.
@onready var target: Area2D = get_parent()


## Get all bodies overlapping the [target].
func update_is_overlapping_with() -> void:
	var bodies: Array[Node2D] = []
	for body in target.get_overlapping_bodies():
		if body is TileMap:
			if overlap_with_tilemap:
				bodies.append(body)
		elif body is PhysicsBody2D:
			if body.collision_layer & overlap_mask:
				bodies.append(body)
	is_overlapping_with = bodies

## Emitted when a body is about to be [queue_free]d by [area_queue_free].
signal queueing_free(body: Node2D)

## Queue free the passed nodes.
func mass_queue_free(nodes: Array[Node2D]):
	for node in nodes:
		queueing_free.emit(node)
		node.queue_free()

## Queue free all overlapping bodies.
func area_queue_free() -> void:
	mass_queue_free(is_overlapping_with)
