extends Node
class_name Colored

@export var shader: Shader

@onready var parent: Sprite2D = get_parent()

var hue: float:
	get:
		return hue
	set(value):
		hue = value
		if parent.material:
			parent.material.set_shader_parameter("hue", value)


func _ready():
	var material = ShaderMaterial.new()
	material.shader = shader
	parent.material = material
	randomize_hue()


func randomize_hue():
	hue = Randomizer.rng.randf()
