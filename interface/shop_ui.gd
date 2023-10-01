extends Panel
class_name ShopUI

## Emitted when the Score button is pressed.
signal score_button_pressed

## Emitted when the Delete button is pressed.
signal delete_button_pressed 

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
@onready var purchasable_items: Array[Node] = find_children("*", "PurchasableItem") as Array[Node]


func _ready():
	for item in purchasable_items:
		item.purchase_begin.connect(_on_any_purchase_begin.bind(item))
		item.purchase_cancel.connect(_on_any_purchase_cancel.bind(item))
		item.purchase_success.connect(_on_any_purchase_success.bind(item))

func _on_any_purchase_begin(what: Node):
	if not what is PurchasableItem:
		push_error("Purchase began outside a PurchasableItem")
		return
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
	purchase_success.emit(what)
	for item in purchasable_items:
		if item == what:
			continue
		item.can_buy = true

func _on_score_button_pressed():
	score_button_pressed.emit()
	
func _on_delete_button_pressed():
	delete_button_pressed.emit()

func _on_back_button_pressed():
	back_button_pressed.emit()
