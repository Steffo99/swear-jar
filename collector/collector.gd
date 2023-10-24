extends Area2D
class_name Collector
## Area that will pick up [Collectible]s with a given name, keeping track of the amount collected.


## The current amount of collected entities.
var collected_count: int = 0

## The types of [Collectible]s to pick up.
##
## The strings will match only if exactly the same.
@export var collecting_types: Array[StringName]

## The sound played when an item is collected.
@export var sound_absorb: AudioStreamPlayer2D

@export_range(0.01, 4) var sound_absorb_min_pitch: float = 1.0
@export_range(0.01, 4) var sound_absorb_max_pitch: float = 1.0

## The goal amount of entities to collect.
##
## When [collected_count] reaches it, it will be reset to zero, and the "goal" signal will be emitted.
@export var collecting_amount: int

## The collector has picked up an object.
signal collected(body: PhysicsBody2D)

## The collector has received its collection goal and is about to reset.
signal goal


func _on_body_entered(body: Node2D):
	if body is PhysicsBody2D:
		var collectible: Collectible = body.find_child("Collectible")
		if collectible and collectible.type in collecting_types:
			collected_count += 1
			collectible.collect()
			if sound_absorb:
				sound_absorb.pitch_scale = sound_absorb_min_pitch + (float(collected_count) / float(collecting_amount)) * (sound_absorb_max_pitch - sound_absorb_min_pitch)
				sound_absorb.play()
			collected.emit(body)
			if collected_count >= collecting_amount:
				goal.emit()
				collected_count = 0
