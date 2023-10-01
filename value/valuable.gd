extends Node
class_name Valuable

@export var value: int

## Emitted when this entity has been counted.
signal evaluated

## Mark this entity as evaluated.
##
func evaluate():
	emit_signal("evaluated")

