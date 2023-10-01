extends Node2D

@export_range(0,1) var slider : float = 0

signal success()

signal failure()

func roll():
	if Randomizer.rng.randf() < slider:
		success.emit()
	else:
		failure.emit()

