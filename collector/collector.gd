extends Area2D
class_name Collector


var collected_count: int = 0

@export var collecting_types: Array[Collectible.CollectibleType]
@export_flags_2d_physics var collecting_collision_mask: int

signal collected(what: PhysicsBody2D)


func _on_body_entered(body: Node2D):
	if body is PhysicsBody2D:
		if body.collision_layer & collecting_collision_mask:
			var collectible: Collectible = body.get_node("Collectible")
			if collectible.type in collecting_types:
				collected_count += 1
				collectible.collect()
				emit_signal("collected", body)
