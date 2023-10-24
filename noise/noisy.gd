extends Node
class_name Noisy


@export var type: StringName


@onready var target: RigidBody2D = get_parent()


func _on_body_entered(body: Node):
	var other_noisy: Node = body.find_child("Noisy")
	# If both bodies are noisy...
	if other_noisy:
		# Find our sounds...
		var sounds_contact: Array[Node] = self.find_children("*", "SoundContact", false)
		for sound_contact in sounds_contact:
			# Check if the type matches...
			if sound_contact.type == other_noisy.type: 
				# Determine the collision strength
				var collision_normal = (body.position - target.position).normalized()
				var this_velocity_on_normal = target.linear_velocity.dot(collision_normal)
				var other_velocity_on_normal = -body.linear_velocity.dot(collision_normal)
				var velocity_on_normal = this_velocity_on_normal + other_velocity_on_normal
				if sound_contact.min_velocity <= velocity_on_normal:
					sound_contact.play()
