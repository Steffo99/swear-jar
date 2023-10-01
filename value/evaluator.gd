extends Area2D
class_name Evaluator
## aggiunge al totale i valori dei Valuable che ci body_enterano e sottrae quelli che ci body_exitano


## The current amount of value evaluated.
var total_value: int = 0

## The types of [Collectible]s to value.
##
## The strings will match only if exactly the same.
@export var collecting_types: Array[StringName]

## The collision mask to check colliding body against.
@export_flags_2d_physics var collecting_collision_mask: int


## The evaluator has added the value of an object.
signal added(what: PhysicsBody2D)

## The evaluator has removed the value of an object.
signal removed(what: PhysicsBody2D)


func _on_body_entered(body: Node2D):
	pass
					



