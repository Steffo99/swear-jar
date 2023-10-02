extends Node
class_name Colored

@export var shader: Shader

@onready var hue: float = Randomizer.rng.randf()
@onready var parent: Sprite2D = get_parent()


func _ready():
	var material = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("hue", hue)
	parent.material = material
