extends StaticBody2D

var coda : int = 0

@export var scene: PackedScene

@onready var _animated_sprite = $AnimatedSprite2D

func _on_collector_collected(body):
	body.queue_free()

func _on_collector_goal():
	coda+=1

func _process(delta):
	if coda>=1 and $Timer.is_stopped():
		$AnimatedSprite2D.play()
		$converter_working.play()
		$Timer.start()

func _on_timer_timeout():
	coda-=1
	$AnimatedSprite2D.stop()
	$converter_working.stop()
	$New_item.play()
	$Spawner.spawn()
