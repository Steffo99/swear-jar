extends Panel
class_name ShopUI

@onready var score_button: ScoreButton = $Rows/UpperButtons/ScoreButton

## Emitted when the Score button is pressed.
signal score_button_pressed

## Emitted when the Back button is presesd.
signal back_button_pressed

## Emitted when any purchase has started.
signal purchase_begin(what: PurchasableItem)

## Emitted when any purchase is cancelled.
signal purchase_cancel(what: PurchasableItem)

## Emitted when any purchase is completed.
##
## Emitted by complete_purchase().
signal purchase_success(what: PurchasableItem)

## Array of all PurchasableItems that this ShopUI should control.
@onready var purchasable_items: Array[Node] = find_children("*", "PurchasableItem")

signal ghost_requested(scene: PackedScene, texture: Texture2D)


func _ready():
	for item in purchasable_items:
		item.purchase_begin.connect(_on_any_purchase_begin.bind(item))
		item.purchase_cancel.connect(_on_any_purchase_cancel.bind(item))
		item.purchase_success.connect(_on_any_purchase_success.bind(item))

func _on_any_purchase_begin(what: Node):
	if not what is PurchasableItem:
		push_error("Purchase began outside a PurchasableItem")
		return
	if what.item_scene:
		ghost_requested.emit(what.item_scene, what.item_icon)
	purchase_begin.emit(what)
	for item in purchasable_items:
		if item == what:
			continue
		item.can_buy = false

func _on_any_purchase_cancel(what: Node):
	if not what is PurchasableItem:
		push_error("Purchase cancelled outside a PurchasableItem")
		return
	purchase_cancel.emit(what)
	for item in purchasable_items:
		if item == what:
			continue
		item.can_buy = true

func _on_any_purchase_success(what: Node):
	if not what is PurchasableItem:
		push_error("Purchase succeeded outside a PurchasableItem")
		return
	if what.item_scene:
		ghost_materialize.emit()
	purchase_success.emit(what)
	for item in purchasable_items:
		if item == what:
			continue
		item.can_buy = true

func _on_game_score_changed(total: int):
	score_button.set_score(total)
		
func _on_score_button_pressed():
	score_button_pressed.emit()

func _on_back_button_pressed():
	back_button_pressed.emit()


@export var copper_coin_scene: PackedScene
@export var silver_coin_scene: PackedScene
@export var gold_coin_scene: PackedScene


signal upgraded_auto_spawn(scene: PackedScene, period: float)

func _on_buy_auto_copper_purchase_success():
	print("[ShopUI] Upgrading to Auto Copper * 2...")
	upgraded_auto_spawn.emit(copper_coin_scene, 0.5)
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ManualCategory/BuyHeliCopper.has_unlocked = true

func _on_buy_heli_copper_purchase_success():
	print("[ShopUI] Upgrading to Auto Copper * 8...")
	upgraded_auto_spawn.emit(copper_coin_scene, 0.125)
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ManualCategory/BuyAutoSilver.has_unlocked = true

func _on_buy_auto_silver_purchase_success():
	print("[ShopUI] Upgrading to Auto Silver * 2...")
	upgraded_auto_spawn.emit(silver_coin_scene, 0.5)
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ManualCategory/BuySuperSilver.has_unlocked = true

func _on_buy_super_silver_purchase_success():
	print("[ShopUI] Upgrading to Auto Silver * 8...")
	upgraded_auto_spawn.emit(silver_coin_scene, 0.125)
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ManualCategory/BuyAutoGold.has_unlocked = true

func _on_buy_auto_gold_purchase_success():
	print("[ShopUI] Upgrading to Auto Gold * 2...")
	upgraded_auto_spawn.emit(gold_coin_scene, 0.5)
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ManualCategory/BuyMidasTouch.has_unlocked = true

func _on_buy_midas_touch_purchase_success():
	print("[ShopUI] Upgrading to Auto Gold * 8...")
	upgraded_auto_spawn.emit(gold_coin_scene, 0.125)


signal upgraded_manual_spawn(scene: PackedScene)

func _on_buy_silver_star_purchase_success():
	print("[ShopUI] Upgrading to Manual Silver...")
	upgraded_manual_spawn.emit(silver_coin_scene)

func _on_buy_gold_star_purchase_success():
	print("[ShopUI] Upgrading to Manual Gold...")
	upgraded_manual_spawn.emit(gold_coin_scene)


signal ghost_materialize

func _on_buy_silverifier_purchase_success():
	print("[ShopUI] Completing Silver-ifier...")
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ConvertCategory/BuyGoldenser.has_unlocked = true

func _on_buy_goldenser_purchase_success():
	print("[ShopUI] Completing Gold-enser...")
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ConvertCategory/BuyGemificator.has_unlocked = true
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ConvertCategory/BuyCompressor.has_unlocked = true

func _on_buy_gemificator_purchase_begin():
	print("[ShopUI] Completing Gem-ificator...")
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ConvertCategory/BuyArtifactomatic.has_unlocked = true

func _on_buy_compressor_purchase_success():
	print("[ShopUI] Completing Coal-pressor...")
	$Rows/PaddedScrollable/Scrollable/ScrollableItems/ConvertCategory/BuyArtifactomatic.has_unlocked = true

func _on_buy_artifactomatic_purchase_success():
	print("[ShopUI] Completing Arti-factory...")


var is_deleting = false

signal delete_begin
signal delete_cancel

func _on_delete_button_pressed():
	if is_deleting:
		is_deleting = false
		delete_cancel.emit()
	else:
		is_deleting = true
		delete_begin.emit()
