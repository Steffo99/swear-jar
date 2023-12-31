extends Area2D
class_name Spawner

## A node which spawns things!

## The scene to spawn.
@export var scene: PackedScene

## The node to add new scenes to.
@export var target: Node

## Count of how many items should be spawned when possible.
var buffer: int = 0

## Maximum amount of items whose spawn can be buffered.
@export var buffer_cap: int

## Rect in which scenes can be spawned randomly in.
@export var spawn_rect: Rect2

## Minimum rotation degrees that an object can spawn with.
@export_range(0, 360) var spawn_rotation_degrees_min: float

## Maximum rotation degrees that an object can spawn with.
@export_range(0, 360) var spawn_rotation_degrees_max: float

## Maximum amount of bodies overlapping the spawner's area before the spawner stops spawning.
@export_range(0, 16, 1, "or_greater") var overlapping_body_count_limit: int

## Sound to play when spawning an item.
##
## Doesn't spawn anything if not set.
@export var sound_complete: AudioStreamPlayer2D

@export_range(0.01, 8.0, 0.01, "or_greater") var sound_complete_pitch_min: float = 1.00
@export_range(0.01, 8.0, 0.01, "or_greater") var sound_complete_pitch_max: float = 1.00


signal spawned(what: Node2D)


func spawn():
	buffer += 1
	if buffer > buffer_cap:
		buffer = buffer_cap

func _select_spawn_position() -> Vector2:
	return Vector2(
		Randomizer.rng.randf_range(spawn_rect.position.x, spawn_rect.end.x), 
		Randomizer.rng.randf_range(spawn_rect.position.y, spawn_rect.end.y),
	)

func _select_spawn_rotation() -> float:
	return Randomizer.rng.randf_range(
		spawn_rotation_degrees_min, 
		spawn_rotation_degrees_max
	)

func _do_spawn():
	var overlapping_bodies = get_overlapping_bodies()
	if len(overlapping_bodies) > overlapping_body_count_limit:
		return
	if scene == null:
		return
#	if scene._bundled["names"][0]=="Coal":
#		var scene = PackedScene.new()
#		scene.pack(get_node(""))
#		print("ehi")
	var instantiated = scene.instantiate()
	instantiated.global_position = global_position + _select_spawn_position()
	instantiated.rotation_degrees = global_rotation_degrees + _select_spawn_rotation()
	target.add_child(instantiated)
	if sound_complete:
		sound_complete.pitch_scale = Randomizer.rng.randf_range(sound_complete_pitch_min, sound_complete_pitch_max)
		sound_complete.play()
	spawned.emit(instantiated)
	buffer -= 1

func _physics_process(_delta):
	if buffer > 0:
		_do_spawn()
