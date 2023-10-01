extends Area2D
class_name Collector
## Area that will pick up [Collectible]s with a given name, keeping track of the amount collected.


## The current amount of collected entities.
var collected_count: int = 0

## The types of [Collectible]s to pick up.
##
## The strings will match only if exactly the same.
@export var collecting_types: Array[StringName]

## The collision mask to check colliding body against.
@export_flags_2d_physics var collecting_collision_mask: int

## The goal amount of entities to collect.
##
## When [collected_count] reaches it, it will be reset to zero, and the "goal" signal will be emitted.
@export var collecting_amount: int

## The collector has picked up an object.
signal collected(what: PhysicsBody2D)

## The collector has received its collection goal and is about to reset.
signal goal


func _on_body_entered(body: Node2D):
	if body is PhysicsBody2D:
		if body.collision_layer & collecting_collision_mask:
			var collectible: Collectible = body.get_node("Collectible")
			if collectible.type in collecting_types:
				collected_count += 1
				collectible.collect()
				emit_signal("collected", body)
				if collected_count >= collecting_amount:
					emit_signal("goal")
					collected_count = 0
