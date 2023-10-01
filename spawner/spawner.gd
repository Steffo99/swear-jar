extends Node2D
class_name Spawner


@export var scene: PackedScene

var buffer: int = 0
@export var buffer_cap: int

@onready var area: Area2D = $Area
@onready var shape: CollisionShape2D = $Area/Shape

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func spawn():
	buffer += 1
	if buffer > buffer_cap:
		print("Hit buffer!")
		buffer = buffer_cap


func _select_spawn_position() -> Vector2:
	var variance = shape.shape.size.x / 2
	var x = rng.randf_range(-variance, +variance)
	return Vector2(x, 0)

func _do_spawn():
	var overlapping_bodies = area.get_overlapping_bodies()
	for overlapping_body in overlapping_bodies:
		if overlapping_body.collision_layer && 0b100:
			return
	var scene_instant = scene.instantiate()
	scene_instant.position = _select_spawn_location()
	add_child(scene_instant)
	buffer -= 1


func _physics_process(_delta):
	if buffer > 0:
		_do_spawn()
