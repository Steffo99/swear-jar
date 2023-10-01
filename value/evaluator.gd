extends Area2D
class_name Evaluator
## aggiunge al totale i valori dei Valuable che ci body_enterano e sottrae quelli che ci body_exitano


## The current amount of value evaluated.
var total: int = 0

## The evaluator has added the value of an object to the total.
signal added(what: Valuable, total: int)

## The evaluator has removed the value of an object to the total.
signal removed(what: Valuable, total: int)

## The total value of the evaluated items has changed.
signal changed(total: int)


func _on_body_entered(body: PhysicsBody2D):
	var valuable: Valuable = body.get_node("Valuable")
	total += valuable.value
	added.emit(valuable, total)
	changed.emit(total)
			
func _on_body_exited(body: PhysicsBody2D):
	var valuable: Valuable = body.get_node("Valuable")
	total -= valuable.value
	removed.emit(valuable, total)
	changed.emit(total)

