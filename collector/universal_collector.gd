extends Area2D
class_name UniversalCollector
## Area that will pick up all [Collectible]s which enter inside it.


## The current amount of collected entities.
var collected_count: int = 0

## The goal amount of entities to collect.
##
## When [collected_count] reaches it, it will be reset to zero, and the "goal" signal will be emitted.
@export var collecting_amount: int

## The collector has picked up an object.
signal collected(body: PhysicsBody2D)

## The collector has received its collection goal and is about to reset.
signal goal


func _on_body_entered(body: Node2D):
	if body is PhysicsBody2D:
		var collectible: Collectible = body.find_child("Collectible")
		if collectible:
			collected_count += 1
			collectible.collect()
			emit_signal("collected", body)
			if collected_count >= collecting_amount:
				emit_signal("goal")
				collected_count = 0
