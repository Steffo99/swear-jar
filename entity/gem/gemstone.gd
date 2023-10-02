extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D/Sprite.set_material($CollisionShape2D/Sprite.get_material().duplicate(true))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var rand_hue = float(randi() % 3)/2.0/3.2
	#$CollisionShape2D/Sprite.material.set_shader_param("Shift_Hue", rand_hue)
	#print($CollisionShape2D/Sprite.modulate)
	#CollisionShape2D/Sprite.modulate = Color.from_ok_hsl(0.5,0,0.9)

