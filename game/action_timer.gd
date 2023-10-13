extends Timer
class_name ActionTimer

## A timer which keeps repeating as long as an action is held.

## The name of the action to check.
@export var action: String


func _physics_process(_delta):
	if is_stopped() and Input.is_action_pressed(action):
		start()
