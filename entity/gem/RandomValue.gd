extends Node

func _ready():
	get_parent().value=Randomizer.rng.randi_range(0,360)
