extends Node
class_name GravityFromGyro


var emulated_gravity = Vector3.ZERO


func _physics_process(_delta):
	var accel_3d = Input.get_accelerometer()
	if accel_3d == Vector3.ZERO:  # If accelerometer is not supported
		accel_3d = (Vector3.UP * Input.get_action_strength("gravity_up") + Vector3.DOWN * Input.get_action_strength("gravity_down") + Vector3.LEFT * Input.get_action_strength("gravity_left") + Vector3.RIGHT * Input.get_action_strength("gravity_right")) * 9.8
	if accel_3d == Vector3.ZERO:  # If nothing is being pressed
		accel_3d = (Vector3.DOWN * 0.05) * 9.8

	
	var accel_2d = Vector2(accel_3d.x, -accel_3d.y) / 9.8
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, accel_2d)
