extends Node
class_name ShopItem


## The name of the item to display in the shop.
@export var title_text: String

## The description of the item to display in the shop.
@export var description_text: String

## The cost of the item to display in the shop.
@export var cost_text: String

## The item type to collect to purchase the item.
##
## If null, counts the items' value.
@export var cost_tag: StringPath

## The quantity of items to collect to purchase the item.
##
## If cost_tag is null, counts the items' value.
@export var cost_quantity: int

## The shape that the ghost should use to determine if the item's placement is valid.
##
## Concave shapes might have problems interacting with the placeable area.
@export var placement_shape: Shape2D


## What to do when this item is purchased.
signal on_purchase
