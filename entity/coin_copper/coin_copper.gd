#extends RigidBody2D
#
#@export var sound_touch: AudioStreamPlayer
#
#var touched=false
#var was_sleeping: bool = false
#
#func set_touched():
#	touched=true
#
#func _on_sleeping_state_changed():
#	was_sleeping = true
#
#func _on_body_entered(body):
#	if not was_sleeping:
#		if touched==false and $Timer.is_stopped():
#			#$sound_touch.play()
#			$Timer.start()
#		var other_node=body
#		if other_node.has_method("set_touched"):
#			other_node.set_touched()
#
#func _on_body_exited(body):
#	touched=false



