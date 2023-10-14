extends Timer
class_name WorkingTimer


@export var working_sound: AudioStreamPlayer2D


func do_start():
	if working_sound:
		working_sound.play()
	start()


func _on_timeout():
	if working_sound:
		working_sound.stop()
