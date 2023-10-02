extends Node2D
class_name Game


@onready var button_spawner: Spawner = $ButtonSpawner
@onready var time_spawner: Spawner = $TimeSpawner
@onready var time_spawner_timer: Timer = $TimeSpawner/Timer
@onready var store_collector: Collector = $StoreCollector
@onready var store_collector_panel: Panel = $StoreCollector/Panel
@onready var store_collector_texturerect: TextureRect = $StoreCollector/Panel/TextureRect
@onready var store_collector_counter: Label = $StoreCollector/Panel/Label
@onready var ghost: Ghost = $Ghost


func trigger_spawn():
	button_spawner.spawn()


signal score_changed(total: int)

func _on_score_changed(total: int):
	score_changed.emit(total)


func _on_upgraded_auto_spawn(scene: PackedScene, period: float):
	time_spawner.scene = scene
	time_spawner_timer.wait_time = period
	time_spawner_timer.start()

func _on_upgraded_manual_spawn(scene: PackedScene):
	button_spawner.scene = scene


func _on_purchase_begin(what: PurchasableItem):
	print("[Game] Beginning purchase of ", what.name, " costing ", what.item_cost_goal, "x ", what.item_cost_type)
	store_collector.collecting_types = [what.item_cost_type]
	store_collector.collecting_amount = what.item_cost_goal
	store_collector.goal.connect(_handle_purchase_success.bind(what))
	update_counter_icon()
	update_counter_text()
	store_collector_panel.show()
	time_spawner_timer.stop()

func _handle_purchase_success(what: PurchasableItem):
	what.complete_purchase()

func _on_purchase_cancel(what: PurchasableItem):
	print("[Game] Cancelled purchase of ", what.name, " costing ", what.item_cost_goal, "x ", what.item_cost_type)
	store_collector.collecting_types = []
	store_collector.goal.disconnect(_handle_purchase_success)
	store_collector_panel.hide()
	ghost.process_mode = Node.PROCESS_MODE_DISABLED
	ghost.hide()
	time_spawner_timer.start()

func _on_purchase_success(what: PurchasableItem):
	print("[Game] Succedeed purchase of ", what.name, " costing ", what.item_cost_goal, "x ", what.item_cost_type)
	store_collector.collecting_types = []
	store_collector.goal.disconnect(_handle_purchase_success)
	store_collector_panel.hide()
	ghost.process_mode = Node.PROCESS_MODE_DISABLED
	ghost.hide()
	time_spawner_timer.start()

func _on_store_collector_collected(_body: RigidBody2D):
	update_counter_text()

func update_counter_text():
	store_collector_counter.text = "%d" % (store_collector.collecting_amount - store_collector.collected_count)

@export var upgrade_copper_texture: Texture2D
@export var upgrade_silver_texture: Texture2D
@export var upgrade_gold_texture: Texture2D

func update_counter_icon():
	if len(store_collector.collecting_types) == 0:
		store_collector_texturerect.texture = null
	elif store_collector.collecting_types[0] == &"Copper":
		store_collector_texturerect.texture = upgrade_copper_texture
	elif store_collector.collecting_types[0] == &"Silver":
		store_collector_texturerect.texture = upgrade_silver_texture
	elif store_collector.collecting_types[0] == &"Gold":
		store_collector_texturerect.texture = upgrade_gold_texture
	else:
		store_collector_texturerect.texture = null

func _on_ghost_requested(scene: PackedScene, texture: Texture2D):
	ghost.scene_to_instantiate = scene
	ghost.preview_texture = texture
	ghost.process_mode = Node.PROCESS_MODE_INHERIT
	ghost.show()

func _on_ghost_materialize():
	ghost.materialize()
