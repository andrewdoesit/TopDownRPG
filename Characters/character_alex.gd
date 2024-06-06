extends CharacterBody2D

@export var move_speed = 100
@export var player_health = 100
@export var player_mana = 100

@onready var inventory_ui = $InventoryUI
@onready var inventory_hotbar = $InventoryHotbar
func _ready():
	Global.set_player_reference(self)


# TODO: Clean this up and fix the movement so when two keys are pressed at once it doesn't move
func get_input():
	var input_direction = Input.get_vector("left", "right", "down", "up").normalized()
	# Had to create the if and else because of the UP and Down reverse
	# print(input_direction)
	if input_direction == Vector2(0, -1):
		velocity = -input_direction * move_speed
		$AnimationPlayer.play("walk_down")
	elif input_direction == Vector2(-1, 0):
		velocity = input_direction * move_speed
		$AnimationPlayer.play("walk_left")
	elif input_direction == Vector2(1, 0):
		velocity = input_direction * move_speed
		$AnimationPlayer.play("walk_right")
	elif input_direction == Vector2(0, 1):
		velocity = -input_direction * move_speed
		$AnimationPlayer.play("walk_up")
	else:
		$AnimationPlayer.stop()
		velocity = input_direction * move_speed
		
func _physics_process(delta):
	start_menu()
	get_input()
	move_and_slide()
	
	
	# TODO: This is currently not working properly
func start_menu():
	var start_button = Input.is_action_pressed("start")
	#print(start_button)
	if start_button == true:
		var start_screen = preload("res://Characters/start_menu.tscn")
		var start_instance = start_screen.instantiate()
		add_child(start_instance)
	else:
		pass
		
func _input(event):
	if event.is_action_pressed("options"):
		# Creates a flip flop to open and close
		# TODO: use this with the start menu as well
		# try this with player controller as well
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
		# This hides the hotbar when the inventory is out 
		inventory_hotbar.visible = !inventory_hotbar.visible

func apply_item_effect(item):
	match item["effect"]:
		"Stamina":
			move_speed += 50
			print("Speed was increased to: ", move_speed)
		"Slot Boost":
			Global.increase_inventory_size(5)
			print("Slots increased to: ", Global.inventory.size())
		_:
			print("There is no effect for this item")

# hotbar shortcut keys 
func _use_hotbar_item(slot_index):
	if slot_index < Global.hotbar_inventory.size():
		var item = Global.hotbar_inventory[slot_index]
		if item != null:
			# Use item slot
			apply_item_effect(item)
			# Remove item
			item["quantity"] -= 1
			if item["quantity"] <= 0:
				Global.hotbar_inventory[slot_index] = null
				Global.remove_item(item["type"], item["effect"])
			Global.inventory_updated.emit()
		
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		for i in range(Global.hotbar_size):
			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):
				_use_hotbar_item(i)
				break
