extends Control

@onready var inventory_scene = preload("res://Characters/Inventory/inventory.tscn")
var inventory_instance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory_instance = inventory_scene.instantiate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_inventory_pressed():
	if inventory_instance != null:
		add_child(inventory_instance)
	else:
		print("Not Working")


func _on_resume_pressed():
	get_tree().change_scene_to_file("res://Scenes/demo_scene.tscn")


func _on_quit_pressed():
	print("Still need to do this")
