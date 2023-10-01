extends StaticBody2D

@export var scene: PackedScene

func _on_collector_collected(body):
	body.queue_free()


func _on_collector_goal():
	print("silver")
	$Spawner.spawn()
	
