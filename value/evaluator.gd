extends Area2D
class_name Evaluator
## aggiunge al totale i valori dei Valuable che ci body_enterano e sottrae quelli che ci body_exitano


## The current amount of value evaluated.
var total_value: int = 0

## The types of [Collectible]s to value.
##
## The strings will match only if exactly the same.
#@export var collecting_types: Array[StringName]

## The collision mask to check colliding body against.
@export_flags_2d_physics var collecting_collision_mask: int

## The evaluator has added the value of an object to the total.
signal added(what: PhysicsBody2D, total_value: int)
## The evaluator has removed the value of an object to the total.
signal removed(what: PhysicsBody2D)

signal score_changed(total_value: int)

func _on_body_entered(body):
	if body is PhysicsBody2D:
		if body.collision_layer & collecting_collision_mask:
			var evaluable: Valuable = body.get_node("Valuable")
			print("sommato")
			total_value += evaluable.value
			evaluable.evaluate()
			score_changed.emit(total_value)
			print("totale= "+str(total_value))
			
func _on_body_exited(body):
	if body is PhysicsBody2D:
		if body.collision_layer & collecting_collision_mask:
			var evaluable: Valuable = body.get_node("Valuable")
			print("sottratto")
			total_value -= evaluable.value
			evaluable.evaluate()
			score_changed.emit(total_value)
			print("totale= "+str(total_value))

