extends Node2D
class_name Spawner


@export var scene: PackedScene


func spawn():
	var overlapping_bodies = $Area.get_overlapping_bodies()
	for overlapping_body in overlapping_bodies:
		if overlapping_body.collision_layer && 0b100:
			print("[Spawner] Not spawning, overlapping with: ", overlapping_body)
			return
	
	var scene_instant = scene.instantiate()
	scene_instant.position = Vector2.ZERO
	print("[Spawner] Created: ", scene_instant)
	add_child(scene_instant)
