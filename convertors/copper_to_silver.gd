extends StaticBody2D

@export var scene: PackedScene

func _on_collector_collected(body):
	body.queue_free()


func _on_collector_goal():
	print("silver coin")
	var scene_instant = scene.instantiate()
	print(position)
	print(scene_instant.position)
	scene_instant.set_position(position)
	print(scene_instant.position)
	add_child(scene_instant)
	#emit_signal("spawned", scene_instant)
