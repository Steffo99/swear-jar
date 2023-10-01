extends Node2D
class_name Game


@onready var button_spawner = $ButtonSpawner


func trigger_spawn():
	button_spawner.spawn()
