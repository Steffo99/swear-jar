extends StaticBody2D
class_name ItemConverter

@onready var sprite_front: AnimatedSprite2D = $SpriteFront
@onready var sprite_back: AnimatedSprite2D = $SpriteBack
@onready var sound_working: AudioStreamPlayer = $SoundWorking

@export var crown_chance: float = 0.1
@export var chalice_chance: float = 0.4

@export var required_gold = 25

@onready var stored_gold: int = 0
@onready var gem_hue_ready: Array[float] = []
@onready var gem_hue_stored: Array[float] = []
@onready var gem_hue_spawn: Array[float] = []

@onready var conversion_timer: Timer = $ConversionTimer
@onready var ring_spawner = $RingSpawner
@onready var chalice_spawner = $ChaliceSpawner
@onready var crown_spawner = $CrownSpawner

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


func _on_gem_collector_collected(body: RigidBody2D):
	print("[ItemConverter] Collected gem: ", body)
	var colored: Colored = body.get_node("CollisionShape2D/Sprite/Colored")
	gem_hue_ready.append(colored.hue)
	try_produce()

func _on_gold_collector_collected(body: RigidBody2D):
	print("[ItemConverter] Collected gold: ", body)
	stored_gold += 1
	try_produce()

func try_produce():
	if stored_gold >= required_gold:
		var hue = gem_hue_ready.pop_front()
		if hue:
			stored_gold -= required_gold
			gem_hue_stored.append(hue)

func _physics_process(_delta):
	if conversion_timer.is_stopped():
		var hue = gem_hue_stored.pop_front()
		if hue:
			gem_hue_spawn.append(hue)
			conversion_timer.start()
			if sprite_front:
				sprite_front.play()
			if sprite_back:
				sprite_back.play()
			if sound_working:
				sound_working.play()

func _on_timer_timeout():
	var rand = Randomizer.rng.randf()
	if rand <= crown_chance:
		crown_spawner.spawn()
	elif rand <= chalice_chance:
		chalice_spawner.spawn()
	else:
		ring_spawner.spawn()
	if sprite_front:
		sprite_front.stop()
	if sprite_back:
		sprite_back.stop()
	if sound_working:
		sound_working.stop()

func _on_spawner_spawned(what: RigidBody2D):
	var hue = gem_hue_spawn.pop_front()
	if not hue:
		push_error("Missing gem hue, defualting to red")
		hue = 0
	var colored: Colored = what.get_node("CollisionShape2D/Sprite/Colored")
	colored.hue = hue
