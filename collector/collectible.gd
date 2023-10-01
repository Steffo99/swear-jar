extends Node
class_name Collectible

enum CollectibleType {
	UNSET,
	COIN_COPPER,
	COIN_SILVER,
	COIN_GOLD,
	GEM,
	DIAMOND,
	COAL,
	CROWN,
	SUPERCROWN,
}

@export var type: CollectibleType

signal collected


func collect():
	emit_signal("collected")
	get_parent().queue_free()
