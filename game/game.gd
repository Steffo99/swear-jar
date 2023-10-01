extends Node2D
class_name Game


@onready var button_spawner = $ButtonSpawner


func trigger_spawn():
	button_spawner.spawn()


signal score_changed(total: int)

func _on_score_changed(total: int):
	score_changed.emit(total)
