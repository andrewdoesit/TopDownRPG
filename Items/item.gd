#@tool
extends Node2D

# Items details for editor window
@export var item_type = ""
@export var item_name = ""
@export var item_effect = ""
@export var item_texture : Texture

var scene_path : String = "res://Items/item.tscn"

# Variables
var player_in_range = false

# SceneTree node reference
@onready var icon_sprite = $Sprite

func _ready():
	#if not Engine.is_editor_hint():
	icon_sprite.texture = item_texture


func _process(delta):
	#if Engine.is_editor_hint():
	icon_sprite.texture = item_texture
	if player_in_range:
		pickup_item()


func pickup_item():
	var item = {
		"quantity" : 1,
		"type" : item_type,
		"texture" : item_texture,
		"name" : item_name,
		"effect" : item_effect,
		"scene_path" : scene_path,
	}
	if Global.player_node:
		Global.add_item(item, false)
		self.queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		#print("Player in Range")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		#print("Player out of range")


func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]

# Set the Items value for spawning
func initiate_items(type, name, effect, texture):
	item_type = type
	item_name = name
	item_effect = effect
	item_texture = texture
