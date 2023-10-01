extends Node2D
class_name Spawner


@export var scene: PackedScene

var buffer: int = 0
@export var buffer_cap: int

@onready var area: Area2D = $Area

@export var spawn_position_range_x: float
@export_range(0, 90) var spawn_rotation_range: float
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

@export_flags_2d_physics var overlapping_bodies_collision_mask: int
@export_range(0, 16) var overlapping_body_count_limit: int

signal spawned(what: Node2D)


func spawn():
	buffer += 1
	if buffer > buffer_cap:
		buffer = buffer_cap

func _count_overlapping_bodies() -> int:
	var overlapping_bodies = area.get_overlapping_bodies()
	var overlapping_body_count = 0
	for overlapping_body in overlapping_bodies:
		if overlapping_body.collision_layer & overlapping_bodies_collision_mask:
			overlapping_body_count += 1
	return overlapping_body_count


func _select_spawn_position() -> Vector2:
	return Vector2(rng.randf_range(-spawn_position_range_x, +spawn_position_range_x), 0)

func _select_spawn_rotation() -> float:
	return rng.randf_range(-spawn_rotation_range, spawn_rotation_range)

func _do_spawn():
	if _count_overlapping_bodies() > overlapping_body_count_limit:
		return
	var scene_instant = scene.instantiate()
	scene_instant.position = _select_spawn_position()
	scene_instant.rotation_degrees = _select_spawn_rotation()
	add_child(scene_instant)
	emit_signal("spawned", scene_instant)
	buffer -= 1


func _physics_process(_delta):
	if buffer > 0:
		_do_spawn()
