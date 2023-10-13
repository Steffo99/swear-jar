extends Panel
class_name PurchasableItem

## Icon of the item that can be purchased.
@export var item_icon: Texture2D:
	get: 
		return item_icon
	set(value):
		item_icon = value
		$Contents/Header/IconRect.texture = item_icon

## Name of the item that can be purchased.
@export var item_name: String:
	get:
		return item_name
	set(value):
		item_name = value
		$Contents/Header/NameLabel.text = value

## Description of the item that can be purchased.
@export var item_description: String:
	get:
		return item_description
	set(value):
		item_description = value
		$Contents/Description/DescriptionLabel.text = value

## Text to be displayed on the cost label of the item.
@export var item_cost_text: String: 
	get:
		return item_cost_text
	set(value):
		item_cost_text = value
		$Contents/Action/CostLabel.text = value

## If this is a converter, the scene to instantiate.
@export var item_scene: PackedScene

## Collectible type of the item required to buy the item.
@export var item_cost_type: StringName

## Amount of items of the given type to collect to buy the item.
@export var item_cost_goal: int

## Whether the player can click or not the Buy button.
##
## Used to prevent two items from getting bought at the same time.
@export var can_buy: bool = true:
	get:
		return can_buy
	set(value):
		can_buy = value
		$Contents/Action/BuyButton.disabled = not (has_bought or (can_buy and has_unlocked))

## Whether the player has unlocked this item for purchase.
##
## Used to force the player to follow the tech tree.
@export var has_unlocked: bool = true:
	get:
		return has_unlocked
	set(value):
		has_unlocked = value
		$Contents/Action/BuyButton.disabled = not (has_bought or (can_buy and has_unlocked))
		$Contents/Action/BuyButton.text = "Buy" if value else "Lock"

## Whether the player is currently buying this item.
##
## Used to cancel the purchase.
var is_buying: bool = false: 
	get:
		return is_buying
	set(value):
		is_buying = value
		$Contents/Action/BuyButton.text = "Undo" if value else "Buy"

## Whether this item can be bought one or infinite times.
@export var one_shot: bool

## Whether the player has already bought this item.
##
## Always false if one_shot is true.
var has_bought: bool:
	get:
		return has_bought
	set(value):
		has_bought = value
		$Contents/Action/BuyButton.disabled = (has_bought or (can_buy and has_unlocked))
		$Contents/Action/BuyButton.add_theme_color_override("font_color", Color.GREEN)
		$Contents/Action/BuyButton.text = "Buy" if value else "Own"


## Emitted when a purchase has started.
signal purchase_begin(what: PurchasableItem)

## Emitted when a purchase is cancelled.
signal purchase_cancel(what: PurchasableItem)

## Emitted when a purchase is completed.
##
## Emitted by complete_purchase().
signal purchase_success(what: PurchasableItem)


func _on_buy_button_pressed():
	if is_buying:
		is_buying = false
		purchase_cancel.emit(self)
	else:
		is_buying = true
		purchase_begin.emit(self)

func complete_purchase():
	is_buying = false
	purchase_success.emit(self)
