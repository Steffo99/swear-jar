extends StaticBody2D
class_name Converter

@export var sprite_front: AnimatedSprite2D
@export var sprite_back: AnimatedSprite2D
@export var conversion_timer: Timer
@export var sound_working: AudioStreamPlayer
@export var sound_complete: AudioStreamPlayer
@export var spawner: Spawner

## Amount of scenes this converter should produce.
var to_produce: int = 0

## Amount of scenes this converter should spawn.
var to_spawn: int = 0

func _on_collector_goal():
	to_produce += 1

func _physics_process(_delta):
	if to_produce >= 1 and conversion_timer.is_stopped():
		to_produce -= 1
		produce()

func produce():
	conversion_timer.start()
	if sprite_front:
		sprite_front.play()
	if sprite_back:
		sprite_back.play()
	if sound_working:
		sound_working.play()

func _on_timer_timeout():
	spawner.spawn()
	if sprite_front:
		sprite_front.stop()
	if sprite_back:
		sprite_back.stop()
	if sound_working:
		sound_working.stop()


var is_pending_deletion: bool = false

func pending_deletion():
	sprite_front.modulate = Color.RED
	is_pending_deletion = true

func ending_deletion():
	sprite_front.modulate = Color.WHITE
	is_pending_deletion = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if is_pending_deletion:
		if event is InputEventMouseButton or event is InputEventScreenTouch:
			queue_free()
