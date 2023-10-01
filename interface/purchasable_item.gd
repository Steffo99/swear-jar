extends Panel
class_name PurchasableItem

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
		$Contents/Header/DescriptionLabel.text = value

## Text to be displayed on the cost label of the item.
@export var item_cost_text: String: 
	get:
		return item_cost_text
	set(value):
		item_cost_text = value
		$Contents/Action/CostLabel.text = value

## Collectible type of the item required to buy the item.
@export var item_cost_type: StringName

## Amount of items of the given type to collect to buy the item.
@export var item_cost_goal: int

## Whether the player can click or not the Buy button.
##
## Used to prevent two items from getting bought at the same time.
@export var can_buy: bool:
	get:
		return can_buy
	set(value):
		can_buy = value
		$Contents/Action/BuyButton.disabled = not can_buy

## Whether the player is currently buying this item.
##
## Used to cancel the purchase.
var is_buying: bool: 
	get:
		return is_buying
	set(value):
		is_buying = value
		$Contents/Action/BuyButton.text = "Cancel" if value else "Buy"


## Emitted when a purchase has started.
signal purchase_begin

## Emitted when a purchase is cancelled.
signal purchase_cancel

## Emitted when a purchase is completed.
##
## Emitted by complete_purchase().
signal purchase_success


func _on_buy_button_pressed():
	if is_buying:
		is_buying = false
		purchase_cancel.emit()
	else:
		is_buying = true
		purchase_begin.emit()


func complete_purchase():
	is_buying = false
	purchase_success.emit()