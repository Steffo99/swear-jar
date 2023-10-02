extends StaticBody2D
class_name Converter

var coda : int = 0

@export var sprite_front: AnimatedSprite2D
@export var sprite_back: AnimatedSprite2D
@export var conversion_timer: Timer
@export var sound_working: AudioStreamPlayer
@export var sound_complete: AudioStreamPlayer
@export var spawner: Spawner

func _on_collector_goal():
	coda+=1

func _process(_delta):
	if coda>=1 and conversion_timer.is_stopped():
		sprite_front.play()
		if not sprite_back==null:
			sprite_back.play()
		conversion_timer.start()
		sound_working.play()

func _on_timer_timeout():
	coda-=1
	sprite_front.stop()
	if not sprite_back==null:
		sprite_back.stop()
	sound_working.stop()
	sound_complete.play()
	spawner.spawn()

var is_pending_deletion: bool = false

func pending_deletion():
	sprite_front.modulate = Color.RED
	is_pending_deletion = true

func ending_deletion():
	sprite_front.modulate = Color.WHITE
	is_pending_deletion = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if is_pending_deletion:
		if event is InputEventMouseButton or event is InputEventScreenTouch:
			queue_free()
