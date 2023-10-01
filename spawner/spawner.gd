extends Node2D
class_name Spawner


@export var scene: PackedScene

var buffer: int = 0
@export var buffer_cap: int

@onready var area: Area2D = $Area

@export var spawn_position_range_x: float
@export_range(0, 90) var spawn_rotation_range: float
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func spawn():
	buffer += 1
	if buffer > buffer_cap:
		print("Hit buffer!")
		buffer = buffer_cap


func _select_spawn_position() -> Vector2:
	return Vector2(rng.randf_range(-spawn_position_range_x, +spawn_position_range_x), 0)

func _select_spawn_rotation() -> float:
	return rng.randf_range(-spawn_rotation_range, spawn_rotation_range)

func _do_spawn():
	var overlapping_bodies = area.get_overlapping_bodies()
	for overlapping_body in overlapping_bodies:
		if overlapping_body.collision_layer && 0b100:
			return
	var scene_instant = scene.instantiate()
	scene_instant.position = _select_spawn_position()
	scene_instant.rotation_degrees = _select_spawn_rotation()
	add_child(scene_instant)
	buffer -= 1


func _physics_process(_delta):
	if buffer > 0:
		_do_spawn()
