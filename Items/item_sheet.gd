extends Node2D

# TODO: This currently does not work!!!!!
# It wont upload the image in the slot


# Items details for editor window
@export var item_type = ""
@export var item_name = ""
@export var item_effect = ""
@export var item_texture : Texture
@export var selected_frame = 0

var scene_path : String = "res://Items/item_sheet.gd"

# Variables
var player_in_range = false

# SceneTree node reference
@onready var icon_sprite = $Sprite2D

func _ready():
	#if not Engine.is_editor_hint():
	icon_sprite.frame = Global.selected_frame
	#icon_sprite.texture = icon_sprite


func _process(_delta):
	#if Engine.is_editor_hint():
	#icon_sprite.frame = Global.selected_frame
	#icon_sprite.texture = icon_sprite
	if player_in_range:
		pickup_item()


func pickup_item():
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"texture" : icon_sprite,
		"name" : item_name,
		"effect" : item_effect,
		"scene_path" : scene_path,
	}
	if Global.player_node:
		Global.add_item(item)
		self.queue_free()



func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		#print("Player in Range")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		#print("Player in Range")
