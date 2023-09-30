extends Node2D
class_name Spawner


@export var scene: PackedScene

var buffer: int = 0
@export var buffer_cap: int

@onready var area: Area2D = $Area


func spawn():
	buffer = clampi(buffer + 1, 0, buffer_cap)


func _physics_process(_delta):
	if buffer > 0:
		var overlapping_bodies = area.get_overlapping_bodies()
		for overlapping_body in overlapping_bodies:
			if overlapping_body.collision_layer && 0b100:
				return		
		var scene_instant = scene.instantiate()
		scene_instant.position = Vector2.ZERO
		buffer -= 1
		add_child(scene_instant)
