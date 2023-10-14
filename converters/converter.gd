extends StaticBody2D
class_name Converter

@onready var sprite_front: AnimatedSprite2D = find_children("SpriteFront", "AnimatedSprite2D", false, true).pop_front()
@onready var sprite_back: AnimatedSprite2D = find_children("SpriteBack", "AnimatedSprite2D", false, true).pop_front()
@onready var working_timer: Timer = $WorkingTimer
@export var spawner: Spawner
@export var spawner_alt: Spawner
@export_range(0.0, 1.0, 0.01) var spawner_alt_chance: float

## Amount of scenes this converter should produce.
var to_produce: int = 0

func _on_collector_goal():
	to_produce += 1

func _physics_process(_delta):
	if to_produce >= 1 and working_timer.is_stopped():
		to_produce -= 1
		produce()

func produce():
	working_timer.start()
	if sprite_front:
		sprite_front.play()
	if sprite_back:
		sprite_back.play()

func _on_working_timer_timeout():
	if spawner_alt and Randomizer.rng.randf() < spawner_alt_chance:
		spawner_alt.spawn()
	else:
		spawner.spawn()
	if sprite_front:
		sprite_front.stop()
	if sprite_back:
		sprite_back.stop()


var is_pending_deletion: bool = false

func pending_deletion():
	modulate = Color.RED
	is_pending_deletion = true

func ending_deletion():
	modulate = Color.WHITE
	is_pending_deletion = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if is_pending_deletion:
		if event is InputEventMouseButton or event is InputEventScreenTouch:
			queue_free()


func _on_gold_converter_spawner_spawned(what: RigidBody2D):
	# Randomize gem colors.
	var colored: Colored = what.get_node("CollisionShape2D/Sprite/Colored")
	colored.randomize_hue()
