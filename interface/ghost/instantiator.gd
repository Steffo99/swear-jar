extends Node
class_name Instantiator


## The [PackedScene] that this node should instantiate.
@export var scene_to_instantiate: PackedScene

## The [Node] instantiated scenes should be attached to.
@export var container: Node


## The [Node2D] instantiated scenes should get properties from.
@onready var target: Node2D = get_parent()


func instantiate():
	var inst = scene_to_instantiate.instantiate()
	inst.global_position = target.global_position
	inst.rotation = target.rotation
	container.add_child(inst)
	instantiated.emit(inst)
	# TODO: Remove this
	return inst


## Emitted when the [instantiate] function has finished executing.
signal instantiated(new_scene: Node)
