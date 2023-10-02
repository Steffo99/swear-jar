extends Node


@export var min_value: int
@export var max_value: int


func _ready():
	get_parent().value = Randomizer.rng.randi_range(min_value, max_value)
