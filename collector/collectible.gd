extends Node
class_name Collectible
## A marker for collectible entities.
##
## Used by [Collector]s to determine which entities to pick up.


## The type of collectible entity the parent entity represents.
@export var type: StringName

## Emitted when this entity has been collected by a collector.
signal collected

## Mark this entity as collected.
##
## You'll probably want to connect this to an AudioSource2D, which will disable the node and play a sound, and when the sound is over a new signal will queue_free it.
func collect():
	collected.emit()


func _on_done():
	get_parent().queue_free()
