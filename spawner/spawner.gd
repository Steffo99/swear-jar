extends Node2D
class_name Spawner
@export var scene: PackedScene
@export var target_parent: NodePath

func spawn():
	if len($Area2D.get_overlapping_bodies()) > 0:
		return
	var scene_instant = scene.instantiate()
	scene_instant.position=Vector2.ZERO
	add_child(scene_instant)
