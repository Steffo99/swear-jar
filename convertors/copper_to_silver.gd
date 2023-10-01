extends StaticBody2D

@export var scene: PackedScene

@onready var _animated_sprite = $AnimatedSprite2D

func _on_collector_collected(body):
	body.queue_free()

func _on_collector_goal():
	$AnimatedSprite2D.play()
	$Timer.start()

func _on_timer_timeout():
	$AnimatedSprite2D.stop()
	$Spawner.spawn()
