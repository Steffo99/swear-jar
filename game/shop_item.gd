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
@export var cost_tag: StringName

## The quantity of items to collect to purchase the item.
##
## If cost_tag is null, counts the items' value.
@export var cost_quantity: int

## The shape that the ghost should use to determine if the item's placement is valid.
##
## Concave shapes might have problems interacting with the placeable area.
##
## May be null if the purchase does not involve the placement of an item.
@export var placement_shape: Shape2D

## The texture that should be rendered when the ghost is placing this item.
##
## Will be made transparent and modulated to red by the ghost.
##
## May be null if the purchase does not involve the placement of an item.
@export var placement_texture: Texture2D

## The scene to instantiate when the purchase is complete.
##
## May be null if the purchase does not involve the placement of an item.
@export var placement_scene: PackedScene

## What to do when this item is purchased.
signal on_purchase
