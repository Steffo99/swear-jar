extends Node
class_name Colored

@export var shader: Shader

@onready var hue: float:
	get:
		return hue
	set(value):
		hue = value
		if parent.material:
			parent.material.set_shader_parameter("hue", value)

@onready var parent: Sprite2D = get_parent()


func _ready():
	var material = ShaderMaterial.new()
	hue = Randomizer.rng.randf()
	material.shader = shader
	parent.material = material

	
